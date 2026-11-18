// Unit-test the R generator inside webR (Node), no network needed.
// What each check protects is documented in tests/TESTS.md.
const { WebR } = require("webr");
const fs = require("fs");

const ROOT = require("path").resolve(__dirname, "..");

(async () => {
  const webR = new WebR();
  await webR.init();
  console.log("webR (Node) initialised:", await webR.evalRString("R.version.string"));

  await webR.FS.writeFile("/registry.R", fs.readFileSync(`${ROOT}/docs/registry.R`));
  await webR.evalRVoid(fs.readFileSync(`${ROOT}/docs/generator.R`, "utf8"));
  await webR.evalRVoid("registry <- rpg_load_registry('/registry.R')");

  // 1. The registry loads and none of its three tables is empty.
  const counts = (
    await webR.evalRString(
      "paste(length(registry$datasets), length(registry$questions), length(registry$challenges))"
    )
  )
    .split(" ")
    .map(Number);
  if (counts.some((n) => !(n > 0))) throw new Error(`empty registry table: ${counts}`);
  console.log("registry loads: datasets/questions/challenges =", counts.join("/"));

  // 2. Total combos match an independent JS computation over the JSON registry,
  //    and the per-difficulty counts partition that total.
  const reg = JSON.parse(fs.readFileSync(`${ROOT}/docs/registry.json`, "utf8"));
  const matches = (q, ds) => {
    const tags = new Set(ds.shape_tags);
    if (q.requires_all && !q.requires_all.every((t) => tags.has(t))) return false;
    if (q.requires_any && !q.requires_any.some((t) => tags.has(t))) return false;
    return true;
  };
  let pairs = 0;
  for (const ds of reg.datasets) for (const q of reg.questions) if (matches(q, ds)) pairs++;
  const expectedTotal = String(pairs * reg.challenges.length);
  const total = await webR.evalRString("as.character(rpg_n_combos(registry))");
  if (total !== expectedTotal) throw new Error(`combo count mismatch: R ${total} vs JS ${expectedTotal}`);
  const parts = await webR.evalRString(`
    lv <- c('mild','medium','spicy','extra-spicy')
    per <- sapply(lv, function(d) rpg_n_combos(registry, difficulties = d))
    paste(sum(per) == rpg_n_combos(registry), paste(per, collapse=' '))
  `);
  if (!parts.startsWith("TRUE")) throw new Error("difficulty counts do not partition total");
  console.log(`combo count: R and JS agree on ${total}; per difficulty ${parts.slice(5)}`);

  // 3. Fifty sequential draws with a theme filter AND a difficulty filter: every
  //    draw honours both, its question genuinely fits its dataset, and nothing repeats.
  await webR.evalRVoid(`
    seen <- character(0)
    for (i in 1:50) {
      s <- rpg_suggest(registry, themes = c('finance', 'politics'), seen = seen,
                       difficulties = c('mild', 'extra-spicy'))
      stopifnot(s$status == 'ok')
      stopifnot(any(unlist(s$dataset$themes) %in% c('finance', 'politics')))
      stopifnot(s$challenge$difficulty %in% c('mild', 'extra-spicy'))
      q <- Filter(function(q) q$id == s$question$id, registry$questions)[[1]]
      stopifnot(rpg_question_matches(q, s$dataset))
      stopifnot(!(s$combo_id %in% seen))
      seen <- c(seen, s$combo_id)
    }
  `);
  console.log("50 draws: theme and difficulty filters, tag matching, no-repeat all hold");

  // 4. A narrow selection runs out after exactly its combo count, never repeating.
  const exhaust = await webR.evalRString(`
    seen <- character(0); n <- 0
    repeat {
      s <- rpg_suggest(registry, themes = c('sport'), seen = seen)
      if (s$status != 'ok') break
      n <- n + 1; seen <- c(seen, s$combo_id)
    }
    paste(s$status, n, rpg_n_combos(registry, 'sport'))
  `);
  const [st, drawn, expected] = exhaust.split(" ");
  if (st !== "exhausted" || drawn !== expected) throw new Error(`exhaustion mismatch: ${exhaust}`);
  console.log(`exhaustion: 'exhausted' after exactly ${drawn} draws`);

  // 5. An unknown theme or an unknown difficulty reports 'empty' rather than erroring.
  const emptyTheme = JSON.parse(
    await webR.evalRString("rpg_suggest_json(registry, c('no-such-theme'), character(0))")
  );
  const emptyDifficulty = await webR.evalRString(
    "rpg_suggest(registry, difficulties = 'nuclear')$status"
  );
  if (emptyTheme.status !== "empty" || emptyDifficulty !== "empty")
    throw new Error(`expected 'empty', got ${emptyTheme.status} / ${emptyDifficulty}`);
  console.log("unknown theme and unknown difficulty both report 'empty'");

  // 6. The JSON bridge the page parses: a themed draw is valid JSON, honours the
  //    theme exactly (not by substring), and has its {dataset} placeholder filled.
  const out = JSON.parse(
    await webR.evalRString("rpg_suggest_json(registry, c('health'), character(0))")
  );
  if (out.status !== "ok") throw new Error("draw failed: " + JSON.stringify(out));
  // rpg_to_json writes a one-element vector as a scalar, so normalise to an array
  // before testing membership: String.prototype.includes would match "healthcare".
  if (![].concat(out.dataset.themes).includes("health")) throw new Error("theme filter violated");
  if (out.question.text.includes("{dataset}")) throw new Error("placeholder not filled");
  console.log("themed draw ok:", out.dataset.id, "/", out.question.id, "/", out.challenge.id);

  // 7. rpg_to_json escapes text that would otherwise break JSON.parse in the page.
  const tricky = 'He said "hi" \\ then\nleft\ttabbed\r';
  const escaped = JSON.parse(
    await webR.evalRString(`rpg_to_json(list(text = ${JSON.stringify(tricky)},
      one = 'solo', many = c('a', 'b'), none = character(0),
      flag = TRUE, n = 42, nothing = NULL))`)
  );
  const expectedEscaped = {
    text: tricky, one: "solo", many: ["a", "b"], none: [], flag: true, n: 42, nothing: null,
  };
  if (JSON.stringify(escaped) !== JSON.stringify(expectedEscaped))
    throw new Error(`rpg_to_json round-trip mismatch: ${JSON.stringify(escaped)}`);
  console.log("rpg_to_json escapes quotes, backslashes, newlines, tabs and carriage returns");

  // 8. Every dataset, question and challenge in the shipped registry serialises to
  //    JSON the page can parse, so no registry text can break a draw that picks it.
  const bad = JSON.parse(
    await webR.evalRString(`
      entries <- c(registry$datasets, registry$questions, registry$challenges)
      rpg_to_json(Filter(Negate(is.null), lapply(entries, function(e) {
        if (is.null(e$id)) return(NULL)
        list(id = e$id, json = rpg_to_json(e))
      })))
    `)
  );
  const unparsable = [].concat(bad).filter((e) => {
    try {
      JSON.parse(e.json);
      return false;
    } catch {
      return true;
    }
  });
  if (unparsable.length) throw new Error(`unparsable registry entries: ${unparsable.map((e) => e.id)}`);
  console.log(`all ${[].concat(bad).length} registry entries serialise to valid JSON`);

  await webR.close();
  console.log("ALL GENERATOR TESTS PASSED");
  process.exit(0);
})().catch((e) => {
  console.error("TEST FAILED:", e);
  process.exit(1);
});
