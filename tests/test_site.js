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

  // Smoke test only: the page boots webR, and one spin produces a complete
  // suggestion. The filter and no-repeat logic is covered, faster and more
  // thoroughly, by test_generator.js.
  await page.click("#spin");
  await page.waitForSelector("#result:not([hidden])", { timeout: 60000 });
  const shown = {
    dataset: (await page.textContent("#ds-name")).trim(),
    question: (await page.textContent("#q-text")).trim(),
    challenge: (await page.textContent("#ch-name")).trim(),
    difficulty: (await page.textContent("#ch-difficulty")).trim(),
  };
  console.log("Suggestion:", shown);
  for (const [field, text] of Object.entries(shown)) {
    if (!text) throw new Error(`suggestion rendered with an empty ${field}`);
  }
  if (shown.question.includes("{dataset}")) throw new Error("placeholder not filled in the UI");
  await page.screenshot({ path: __dirname + "/site.png", fullPage: true });

  await browser.close();
  server.close();
  console.log("TEST PASSED");
})().catch((e) => { console.error("TEST FAILED:", e); process.exit(1); });
