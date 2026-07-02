// Unit-test the R generator inside webR (Node), no network needed.
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

  // Registry loads with expected counts.
  const counts = await webR.evalRString(
    "paste(length(registry$datasets), length(registry$questions), length(registry$challenges))"
  );
  console.log("datasets/questions/challenges:", counts);

  // Total combos matches an independent JS computation over the JSON registry.
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
  console.log(`total combos (R vs JS): ${total} vs ${expectedTotal}`);
  if (total !== expectedTotal) throw new Error("combo count mismatch between R and JS");

  // Difficulty subsets partition the total.
  const parts = await webR.evalRString(`
    lv <- c('mild','medium','spicy','extra-spicy')
    per <- sapply(lv, function(d) rpg_n_combos(registry, difficulties = d))
    paste(sum(per) == rpg_n_combos(registry), paste(per, collapse=' '))
  `);
  console.log("per-difficulty combos [sums-to-total mild medium spicy extra]:", parts);
  if (!parts.startsWith("TRUE")) throw new Error("difficulty counts do not partition total");

  // Difficulty filter is honoured across 30 draws.
  await webR.evalRVoid(`
    seen <- character(0)
    for (i in 1:30) {
      s <- rpg_suggest(registry, seen = seen, difficulties = c('mild', 'extra-spicy'))
      stopifnot(s$status == 'ok')
      stopifnot(s$challenge$difficulty %in% c('mild', 'extra-spicy'))
      seen <- c(seen, s$combo_id)
    }
  `);
  console.log("30 draws with difficulty filter: all challenges mild or extra-spicy");

  // Unknown difficulty returns status 'empty'.
  await webR.evalRVoid(`
    stopifnot(rpg_suggest(registry, difficulties = 'nuclear')$status == 'empty')
  `);
  console.log("unknown difficulty correctly returns status 'empty'");

  // A themed draw returns valid JSON with a dataset in that theme.
  const out = JSON.parse(
    await webR.evalRString("rpg_suggest_json(registry, c('health'), character(0))")
  );
  if (out.status !== "ok") throw new Error("draw failed: " + JSON.stringify(out));
  if (!out.dataset.themes.includes("health")) throw new Error("theme filter violated");
  if (out.question.text.includes("{dataset}")) throw new Error("placeholder not filled");
  console.log("themed draw ok:", out.dataset.id, "/", out.question.id, "/", out.challenge.id);

  // Question archetype must actually match the dataset's tags (spot check via combo across 50 draws).
  await webR.evalRVoid(`
    seen <- character(0)
    for (i in 1:50) {
      s <- rpg_suggest(registry, themes = c('finance', 'politics'), seen = seen)
      stopifnot(s$status == 'ok')
      stopifnot(any(unlist(s$dataset$themes) %in% c('finance', 'politics')))
      q <- Filter(function(q) q$id == s$question$id, registry$questions)[[1]]
      stopifnot(rpg_question_matches(q, s$dataset))
      stopifnot(!(s$combo_id %in% seen))
      seen <- c(seen, s$combo_id)
    }
  `);
  console.log("50 sequential draws: theme filter, tag matching, no-repeat all hold");

  // Exhaustion: a narrow selection eventually reports 'exhausted', never repeats.
  const exhaust = await webR.evalRString(`
    seen <- character(0); n <- 0
    repeat {
      s <- rpg_suggest(registry, themes = c('sport'), seen = seen)
      if (s$status != 'ok') break
      n <- n + 1; seen <- c(seen, s$combo_id)
    }
    paste(s$status, n, rpg_n_combos(registry, 'sport'))
  `);
  console.log("exhaustion test [status drawn expected]:", exhaust);
  const [st, drawn, expected] = exhaust.split(" ");
  if (st !== "exhausted" || drawn !== expected) throw new Error("exhaustion mismatch");

  // Empty theme intersection reports 'empty'.
  const empty = JSON.parse(
    await webR.evalRString("rpg_suggest_json(registry, c('no-such-theme'), character(0))")
  );
  if (empty.status !== "empty") throw new Error("expected empty status");
  console.log("unknown theme correctly returns status 'empty'");

  await webR.close();
  console.log("ALL GENERATOR TESTS PASSED");
  process.exit(0);
})().catch((e) => { console.error("TEST FAILED:", e); process.exit(1); });
