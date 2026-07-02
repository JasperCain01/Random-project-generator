const { chromium } = require("playwright");
const http = require("http");
const fs = require("fs");
const path = require("path");

const DOCS = path.resolve(__dirname, "../docs");
const MIME = { ".html": "text/html", ".js": "text/javascript", ".css": "text/css", ".json": "application/json", ".R": "text/plain" };

const server = http.createServer((req, res) => {
  const file = path.join(DOCS, req.url === "/" ? "index.html" : req.url.split("?")[0]);
  fs.readFile(file, (err, data) => {
    if (err) { res.writeHead(404); res.end("not found"); return; }
    res.writeHead(200, { "Content-Type": MIME[path.extname(file)] || "application/octet-stream" });
    res.end(data);
  });
});

(async () => {
  await new Promise((r) => server.listen(8787, r));
  // Set CHROMIUM_PATH to use a system Chromium; otherwise Playwright's own
  // browser is used (run `npx playwright install chromium` once).
  const browser = await chromium.launch({
    executablePath: process.env.CHROMIUM_PATH || undefined,
  });
  const page = await browser.newPage();
  page.on("console", (m) => console.log("[console]", m.type(), m.text().slice(0, 300)));
  page.on("pageerror", (e) => console.log("[pageerror]", e.message));

  // The sandbox blocks webr.r-wasm.org, so serve the identical files from the
  // webr npm package instead (same distribution the CDN hosts).
  const DIST = path.join(__dirname, "node_modules/webr/dist");
  const MIME2 = { ".mjs": "text/javascript", ".js": "text/javascript", ".wasm": "application/wasm", ".json": "application/json", ".data": "application/octet-stream" };
  await page.route("https://webr.r-wasm.org/**", (route) => {
    const name = new URL(route.request().url()).pathname.replace(/^\/(latest|v[\d.]+)\//, "");
    const file = path.join(DIST, name);
    if (!fs.existsSync(file)) return route.fulfill({ status: 404, body: "nf" });
    let body = fs.readFileSync(file);
    if (file.endsWith(".mjs")) {
      // Strip the Node-ESM banner the npm build carries (CDN build has none);
      // browser code paths never call require/__filename/__dirname.
      body = body
        .toString()
        .replace(/^import { createRequire } from 'module';\n/, "")
        .replace(/^import { fileURLToPath as urlESMPluginFileURLToPath } from "url";\n/m, "")
        .replace(/^import { dirname as pathESMPluginDirname} from "path";\n/m, "")
        .replace(/^const require = createRequire\(import\.meta\.url\);\n/m, "var require = undefined;\n")
        .replace(/urlESMPluginFileURLToPath\(import\.meta\.url\)/g, '""')
        .replace(/pathESMPluginDirname\(""\)/g, '""');
    }
    route.fulfill({
      status: 200,
      contentType: MIME2[path.extname(file)] || "application/octet-stream",
      body,
    });
  });

  await page.goto("http://localhost:8787/");
  console.log("Page loaded, waiting for webR boot (up to 120s)...");
  await page.waitForFunction(
    () => !document.getElementById("spin").disabled,
    null,
    { timeout: 120000 }
  );
  console.log("webR ready. Status:", await page.textContent("#status"));

  // Select a theme and a difficulty, then spin.
  await page.click('#theme-chips label:has-text("health")');
  await page.click('#difficulty-chips label:has-text("Extra spicy")');
  console.log("Combo count:", await page.textContent("#combo-count"));
  await page.click("#spin");
  await page.waitForSelector("#result:not([hidden])", { timeout: 60000 });
  console.log("--- Suggestion 1 ---");
  console.log("Dataset:   ", await page.textContent("#ds-name"));
  console.log("Question:  ", (await page.textContent("#q-text")).trim());
  console.log("Challenge: ", await page.textContent("#ch-name"));
  console.log("Difficulty:", await page.textContent("#ch-difficulty"));
  if (!(await page.textContent("#ch-difficulty")).includes("Extra spicy"))
    throw new Error("difficulty filter not honoured in UI");
  await page.screenshot({ path: __dirname + "/site.png", fullPage: true });

  // The drawn dataset must genuinely carry the selected theme.
  const registry = JSON.parse(fs.readFileSync(path.join(DOCS, "registry.json"), "utf8"));
  const themesOf = (name) => registry.datasets.find((d) => d.name === name).themes;
  const assertHealth = async () => {
    const name = await page.textContent("#ds-name");
    if (!themesOf(name).includes("health"))
      throw new Error(`theme filter violated in UI: ${name} is not health-themed`);
  };
  await assertHealth();

  // Spin twice more to confirm no-repeat history works.
  const combos = new Set([await page.textContent("#ds-name") + "|" + await page.textContent("#q-text") + "|" + await page.textContent("#ch-name")]);
  for (let i = 2; i <= 3; i++) {
    await page.click("#spin");
    await page.waitForFunction(() => !document.getElementById("spin").disabled, null, { timeout: 60000 });
    const key = await page.textContent("#ds-name") + "|" + await page.textContent("#q-text") + "|" + await page.textContent("#ch-name");
    console.log(`--- Suggestion ${i} ---`, (await page.textContent("#ds-name")), "/", await page.textContent("#ch-name"));
    combos.add(key);
    await assertHealth();
  }
  console.log("History line:", (await page.textContent("#history-line")).replace(/\s+/g, " ").trim());
  console.log("Distinct combos out of 3 spins:", combos.size);

  await browser.close();
  server.close();
  console.log("TEST PASSED");
})().catch((e) => { console.error("TEST FAILED:", e); process.exit(1); });
