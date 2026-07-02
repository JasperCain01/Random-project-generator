# Compile the YAML registries into docs/registry.json and copy the generator
# into docs/ so GitHub Pages serves everything the webR app needs.
#
#   Rscript R/build_registry.R
#
# Requires: yaml, jsonlite

registry <- list(
  datasets   = yaml::read_yaml("data/datasets.yaml"),
  questions  = yaml::read_yaml("data/questions.yaml"),
  challenges = yaml::read_yaml("data/challenges.yaml")
)

# Basic validation: unique ids, themes and tags present, templates well-formed.
stopifnot(
  !anyDuplicated(vapply(registry$datasets, `[[`, "", "id")),
  !anyDuplicated(vapply(registry$questions, `[[`, "", "id")),
  !anyDuplicated(vapply(registry$challenges, `[[`, "", "id")),
  all(vapply(registry$datasets, function(d) length(d$themes) > 0, logical(1))),
  all(vapply(registry$datasets, function(d) length(d$shape_tags) > 0, logical(1))),
  all(vapply(registry$questions, function(q) grepl("{dataset}", q$template, fixed = TRUE) ||
        identical(q$id, "simulation-uncertainty"), logical(1)))
)

# Every dataset must match at least one question archetype.
source("R/generator.R")
for (ds in registry$datasets) {
  n <- sum(vapply(registry$questions, rpg_question_matches, logical(1), dataset = ds))
  if (n == 0) stop("Dataset matches no question archetype: ", ds$id)
  message(sprintf("%-28s %2d matching archetypes", ds$id, n))
}

dir.create("docs", showWarnings = FALSE)
jsonlite::write_json(registry, "docs/registry.json",
                     auto_unbox = TRUE, pretty = TRUE)
dput(registry, file = "docs/registry.R")  # dget()-readable, no JSON pkg needed
file.copy("R/generator.R", "docs/generator.R", overwrite = TRUE)

message(sprintf(
  "Wrote docs/registry.json: %d datasets, %d questions, %d challenges (%d total combos)",
  length(registry$datasets), length(registry$questions), length(registry$challenges),
  rpg_n_combos(registry)
))
