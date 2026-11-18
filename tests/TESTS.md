# What the tests protect

There are two scripts, run from this directory after `npm install`:

```
npm run test:generator   # node test_generator.js: the R engine, inside webR under Node
npm run test:site        # node test_site.js: the real page in headless Chromium
```

Neither runs in CI. `validate.yml` only checks that the generated `docs/` files are in sync with the YAML sources. Both scripts stop at the first failure and print `TEST FAILED` with the reason.

Severity describes what goes wrong for a visitor if the guarded behaviour breaks:

- **Critical**: the page doesn't work.
- **High**: the page suggests something invalid.
- **Medium**: a feature visibly misbehaves.

## `test_generator.js`: the suggestion engine (`docs/generator.R`)

This script loads the same `generator.R` and `registry.R` the page loads, inside webR, so it tests the code users actually run.

| Check | Purpose | Severity |
|---|---|---|
| 1. The registry loads with no empty table | The datasets, questions and challenges tables all load and are non-empty. An empty table would make every draw fail. | Critical |
| 2. Combo count agrees between R and JS; difficulties partition it | The R count of valid (dataset, question, challenge) combinations matches an independent JS re-implementation of the tag-matching rules over `registry.json`, and the four per-difficulty counts add up to the total. The page displays this count and uses it to decide when a selection is exhausted. If both implementations misread the YAML in the same way, both will be wrong together; this check can't catch that. | Medium |
| 3. Fifty filtered draws | With a theme filter and a difficulty filter both on, every draw has a dataset in a chosen theme and a challenge at a chosen difficulty, its question genuinely fits the dataset's shape tags, and nothing repeats. These are the invariants that make a suggestion valid. | High |
| 4. Exhaustion | A narrow selection (`sport`) reports `exhausted` after exactly as many draws as it has combinations. This is the only test of the end state the user sees when they've seen everything. | Medium |
| 5. Unknown theme or difficulty → `empty` | A selection that matches nothing reports `empty` rather than erroring. | Medium |
| 6. Themed draw through the JSON bridge | `rpg_suggest_json()`, the exact call the page makes, returns parseable JSON, honours the theme by exact match (not substring), and fills the `{dataset}` placeholder in the question text. A raw `{dataset}` on screen is the most visible defect the engine could produce. | High |
| 7. `rpg_to_json` escaping and value types | Quotes, backslashes, newlines, tabs and carriage returns survive a round trip through `JSON.parse`, and scalar, vector, empty, logical, numeric and `NULL` values serialise as the page expects. A one-element vector becomes a scalar, not an array; check 6 relies on knowing that. | Critical |
| 8. Every registry entry serialises to valid JSON | Each shipped dataset, question and challenge passes through `rpg_to_json` and parses. One stray quote or control character in registry text would otherwise break every draw that picked that entry, with no warning until a user hit it. | Critical |

## `test_site.js`: the page itself

| Check | Purpose | Severity |
|---|---|---|
| Boot and one spin | The page loads, webR boots (up to 120 seconds), and one spin renders a dataset, question, challenge and difficulty, with no unfilled placeholder. This is the only check of the page wiring and the JS↔R call. A screenshot is saved to `site.png` (git-ignored) for eyeballing. | Critical |

The test can't see one real risk. The page imports `https://webr.r-wasm.org/latest/webr.mjs`, always the latest webR release. The sandbox can't reach that host, so the test intercepts the URL and serves the npm `webr` package pinned in `package.json` instead. A new webR release that broke the page would therefore still pass here. Pinning the page to a specific webR version would close that gap and make the interception an honest stand-in.

To run the site test where Playwright's own browser isn't installed, point it at a system Chromium with `CHROMIUM_PATH=/path/to/chromium npm run test:site`.
