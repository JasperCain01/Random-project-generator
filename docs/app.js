// Random Project Generator — front end.
//
// All the actual drawing logic lives in R (docs/generator.R), executed in the
// browser by webR. This file only boots webR, wires up the UI, and keeps the
// draw history in localStorage so combinations never repeat on this device.

import { WebR } from "https://webr.r-wasm.org/latest/webr.mjs";

const $ = (id) => document.getElementById(id);
const SEEN_KEY = "rpg-seen-combos";

let webR = null;
let registry = null;
let seen = JSON.parse(localStorage.getItem(SEEN_KEY) || "[]");

function setStatus(text) {
  $("status").textContent = text;
}

// Escape a JS string into a single-quoted R string literal.
function rString(s) {
  return "'" + s.replaceAll("\\", "\\\\").replaceAll("'", "\\'") + "'";
}

// Build an R character-vector literal from a JS string array.
function rCharVec(arr) {
  if (arr.length === 0) return "character(0)";
  return "c(" + arr.map(rString).join(",") + ")";
}

function selectedThemes() {
  return [...document.querySelectorAll("#theme-chips input:checked")].map(
    (el) => el.value
  );
}

// Mirror of the R matching rules, used only to show live combination counts.
function questionMatches(q, ds) {
  const tags = new Set(ds.shape_tags);
  if (q.requires_all && !q.requires_all.every((t) => tags.has(t))) return false;
  if (q.requires_any && !q.requires_any.some((t) => tags.has(t))) return false;
  return true;
}

function comboCount(themes) {
  const datasets = registry.datasets.filter(
    (ds) => themes.length === 0 || ds.themes.some((t) => themes.includes(t))
  );
  let pairs = 0;
  for (const ds of datasets) {
    for (const q of registry.questions) {
      if (questionMatches(q, ds)) pairs++;
    }
  }
  return { combos: pairs * registry.challenges.length, datasets: datasets.length };
}

function updateComboCount() {
  const { combos, datasets } = comboCount(selectedThemes());
  $("combo-count").textContent =
    combos === 0
      ? "No datasets match this selection."
      : `${datasets} datasets in scope · ${combos.toLocaleString()} possible projects`;
}

function buildThemeChips() {
  const themes = [...new Set(registry.datasets.flatMap((d) => d.themes))].sort();
  const box = $("theme-chips");
  for (const theme of themes) {
    const label = document.createElement("label");
    label.className = "chip";
    const input = document.createElement("input");
    input.type = "checkbox";
    input.value = theme;
    input.addEventListener("change", updateComboCount);
    const span = document.createElement("span");
    span.textContent = theme.replaceAll("-", " ");
    label.append(input, span);
    box.append(label);
  }
  $("themes-section").hidden = false;
  updateComboCount();
}

function renderSuggestion(s) {
  $("ds-name").textContent = s.dataset.name;
  $("ds-desc").textContent = s.dataset.description.trim();
  $("ds-hint").textContent = s.dataset.access.hint;
  $("ds-url").href = s.dataset.url;
  $("ds-license").textContent = `Licence: ${s.dataset.license}`;
  $("ds-size").textContent = `Size: ${s.dataset.size}`;
  $("q-family").textContent = s.question.family;
  $("q-text").textContent = s.question.text.trim();
  $("ch-name").textContent = s.challenge.name;
  $("ch-desc").textContent = s.challenge.description.trim();
  $("result").hidden = false;
}

function updateHistoryLine() {
  $("history-line").hidden = seen.length === 0;
  $("history-count").textContent = seen.length.toLocaleString();
}

async function spin() {
  const btn = $("spin");
  btn.disabled = true;
  setStatus("Asking R for a project…");
  try {
    const code = `rpg_suggest_json(.rpg_registry, ${rCharVec(
      selectedThemes()
    )}, ${rCharVec(seen)})`;
    const out = await webR.evalRString(code);
    const s = JSON.parse(out);
    if (s.status === "ok") {
      renderSuggestion(s);
      seen.push(s.combo_id);
      localStorage.setItem(SEEN_KEY, JSON.stringify(seen));
      updateHistoryLine();
      setStatus("");
    } else if (s.status === "exhausted") {
      setStatus(
        "You have drawn every combination for this selection! Widen the themes or reset your history."
      );
    } else {
      setStatus("No datasets match this theme selection — pick different themes.");
    }
  } catch (err) {
    console.error(err);
    setStatus(`R call failed: ${err.message}`);
  } finally {
    btn.disabled = false;
  }
}

async function boot() {
  try {
    setStatus("Downloading the webR runtime (~15 MB, cached after first visit)…");
    webR = new WebR();
    const [regJson, regR, genText] = await Promise.all([
      fetch("registry.json").then((r) => r.text()),
      fetch("registry.R").then((r) => r.text()),
      fetch("generator.R").then((r) => r.text()),
      webR.init(),
    ]);
    registry = JSON.parse(regJson);

    setStatus("Loading registry and generator into R…");
    await webR.FS.writeFile("/registry.R", new TextEncoder().encode(regR));
    await webR.evalRVoid(genText);
    await webR.evalRVoid("`.rpg_registry` <- rpg_load_registry('/registry.R')");

    buildThemeChips();
    updateHistoryLine();
    const btn = $("spin");
    btn.textContent = "🎲 Deal me a project";
    btn.disabled = false;
    btn.addEventListener("click", spin);
    setStatus("");
  } catch (err) {
    console.error(err);
    setStatus(
      `Could not start webR (${err.message}). Check your connection and reload.`
    );
  }
}

$("reset").addEventListener("click", () => {
  seen = [];
  localStorage.removeItem(SEEN_KEY);
  updateHistoryLine();
  setStatus("History cleared — all combinations are back in the deck.");
});

boot();
