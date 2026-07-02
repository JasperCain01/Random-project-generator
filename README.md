# 🎲 Random Project Generator

Spin up a random data analysis & visualisation project: a **public dataset**,
a **question to answer**, and a **challenge** to spice it up — filtered by the
themes you care about (health, finance, politics, …) and by how spicy a
challenge you fancy (🌶️ mild → 🌶️🌶️🌶️🌶️ extra spicy).

The draw itself runs in **R, in your browser**, via
[webR](https://docs.r-wasm.org/webr/latest/): the exact same `generator.R`
that works in a local R session is executed as WebAssembly on a static
GitHub Pages site. No server, no install.

## How it works

```
data/datasets.yaml     26 curated public datasets, tagged by theme + data shape
data/questions.yaml    35 question archetypes with {dataset} placeholders
data/challenges.yaml   40 dataset-independent challenges, rated mild → extra-spicy
        │
        │  python3 tools/build_registry.py   (or Rscript R/build_registry.R)
        ▼
docs/registry.json     compiled registry (read by the JS UI for chips/counts)
docs/registry.R        same registry as an R literal (read by R via dget())
docs/generator.R       copy of R/generator.R served to the browser
docs/index.html + app.js + style.css   the GitHub Pages site
```

Variety comes from combinatorics, not volume: question archetypes declare
which data shapes they need (`requires_any` / `requires_all` against each
dataset's `shape_tags`), so every pairing is coherent — you'll never be asked
to run a PCA on a two-column table. The current registry yields **~15,000
valid combinations**, and the site remembers what you've been dealt
(localStorage) so a combination never repeats on your device.

## Play it

Enable GitHub Pages for this repo (**Settings → Pages → Deploy from a
branch → `/docs` folder**) and the generator is live. webR works on Pages
out of the box — it falls back to its PostMessage channel when
cross-origin-isolation headers aren't available.

## Use it from a local R session

No packages needed — the generator is dependency-free base R:

```r
source("R/generator.R")
registry <- rpg_load_registry("docs/registry.R")
rpg_print(rpg_suggest(registry, themes = c("health", "finance"),
                      difficulties = c("mild", "medium")))

rpg_n_combos(registry)                            # total combinations
rpg_n_combos(registry, "politics")                # ... for one theme
rpg_n_combos(registry, difficulties = "spicy")    # ... at one heat level
```

Pass `seen = <character vector of combo_ids>` to exclude previous draws, or
`seed =` for a reproducible dip. Difficulty levels are `mild`, `medium`,
`spicy` and `extra-spicy`; an empty selection means any heat.

## Add a dataset (or question, or challenge)

1. Edit the relevant file in `data/` — each entry is a small YAML block; the
   field vocabulary is documented in comments at the top of each file.
2. Tag datasets honestly: `themes` controls the filter chips, `shape_tags`
   controls which question archetypes can be drawn for it.

   Current shape-tag vocabulary: `time_series`, `panel`, `cross_section`,
   `multivariate_numeric`, `categorical`, `geographic`, `network`, `text`,
   `events`, `individual_level`, `country_level`, `transactions`, `survey`,
   `relational`, `large`.
3. Rebuild the compiled registry:

   ```sh
   python3 tools/build_registry.py     # or: Rscript R/build_registry.R
   ```

   The build validates ids, placeholders, and that every dataset matches at
   least one archetype. Commit the regenerated `docs/` files along with your
   YAML change — CI fails if they drift out of sync. (CI rebuilds with the
   Python script, so its output formatting is canonical; the R build script
   is equivalent in content but formats the artefacts slightly differently.)

## Development notes

- `R/generator.R` is the single source of truth for the drawing logic; the
  build copies it into `docs/`. It deliberately avoids all packages (even
  jsonlite — it ships a ~30-line JSON encoder) so webR needs zero package
  downloads at startup.
- The end-to-end behaviour (webR boot, theme filter, no-repeat history,
  exhaustion) is exercised headlessly with Playwright against the `webr`
  npm distribution; the generator logic itself is unit-tested inside
  Node-hosted webR.
