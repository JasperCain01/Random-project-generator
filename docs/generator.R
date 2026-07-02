# Random project generator — core logic.
#
# Pure base R with zero package dependencies, so the same file runs unchanged
# in a local R session and inside webR in the browser (no package downloads).
#
# Local use:
#   source("R/generator.R")
#   registry <- rpg_load_registry("docs/registry.R")
#   rpg_print(rpg_suggest(registry, themes = c("health", "finance")))

# The registry is shipped as a dput()-style R literal (docs/registry.R),
# generated from the YAML sources by the build script.
rpg_load_registry <- function(path) {
  dget(path)
}

# A question archetype matches a dataset when the dataset's shape_tags satisfy
# requires_all (every tag present) and requires_any (at least one present).
rpg_question_matches <- function(question, dataset) {
  tags <- unlist(dataset$shape_tags)
  all_ok <- is.null(question$requires_all) ||
    all(unlist(question$requires_all) %in% tags)
  any_ok <- is.null(question$requires_any) ||
    any(unlist(question$requires_any) %in% tags)
  all_ok && any_ok
}

rpg_dataset_in_themes <- function(dataset, themes) {
  length(themes) == 0 || any(unlist(dataset$themes) %in% themes)
}

# All valid (dataset index, question index) pairs for the chosen themes.
rpg_valid_pairs <- function(registry, themes = character(0)) {
  pairs <- list()
  for (d in seq_along(registry$datasets)) {
    ds <- registry$datasets[[d]]
    if (!rpg_dataset_in_themes(ds, themes)) next
    for (q in seq_along(registry$questions)) {
      if (rpg_question_matches(registry$questions[[q]], ds)) {
        pairs[[length(pairs) + 1L]] <- c(d, q)
      }
    }
  }
  pairs
}

rpg_combo_id <- function(dataset, question, challenge) {
  paste(dataset$id, question$id, challenge$id, sep = "|")
}

# Total number of distinct combinations for a theme selection.
rpg_n_combos <- function(registry, themes = character(0)) {
  length(rpg_valid_pairs(registry, themes)) * length(registry$challenges)
}

# Draw one suggestion, avoiding combo ids listed in `seen`.
# Returns a list with status = "ok" and dataset/question/challenge fields,
# or status = "exhausted" / "empty" when nothing can be drawn.
rpg_suggest <- function(registry, themes = character(0),
                        seen = character(0), seed = NULL) {
  if (!is.null(seed)) set.seed(seed)
  themes <- as.character(themes)
  seen <- as.character(seen)

  pairs <- rpg_valid_pairs(registry, themes)
  n_chal <- length(registry$challenges)
  total <- length(pairs) * n_chal
  if (total == 0) {
    return(list(status = "empty", themes = themes))
  }

  # Enumerate unseen combos lazily: sample combo indices without replacement.
  order <- sample.int(total)
  for (k in order) {
    p <- pairs[[((k - 1L) %/% n_chal) + 1L]]
    c_idx <- ((k - 1L) %% n_chal) + 1L
    ds <- registry$datasets[[p[1]]]
    qu <- registry$questions[[p[2]]]
    ch <- registry$challenges[[c_idx]]
    id <- rpg_combo_id(ds, qu, ch)
    if (!(id %in% seen)) {
      question_text <- gsub("{dataset}", ds$name, qu$template, fixed = TRUE)
      return(list(
        status = "ok",
        combo_id = id,
        remaining = total - length(intersect(seen, rpg_all_combo_ids(pairs, registry))) - 1L,
        total = total,
        dataset = ds,
        question = list(id = qu$id, family = qu$family, text = question_text),
        challenge = ch
      ))
    }
  }
  list(status = "exhausted", themes = themes, total = total)
}

# All combo ids reachable from a set of pairs (used to count remaining).
rpg_all_combo_ids <- function(pairs, registry) {
  ids <- character(0)
  for (p in pairs) {
    ds <- registry$datasets[[p[1]]]
    qu <- registry$questions[[p[2]]]
    for (ch in registry$challenges) {
      ids[length(ids) + 1L] <- rpg_combo_id(ds, qu, ch)
    }
  }
  ids
}

# --- Minimal JSON encoder (base R, output only) -----------------------------
# Named lists -> objects, unnamed lists / length!=1 vectors -> arrays,
# scalars -> literals. Sufficient for the structures this generator returns.

rpg_json_string <- function(s) {
  s <- gsub("\\", "\\\\", s, fixed = TRUE)
  s <- gsub("\"", "\\\"", s, fixed = TRUE)
  s <- gsub("\n", "\\n", s, fixed = TRUE)
  s <- gsub("\r", "\\r", s, fixed = TRUE)
  s <- gsub("\t", "\\t", s, fixed = TRUE)
  paste0("\"", s, "\"")
}

rpg_to_json <- function(x) {
  if (is.null(x)) return("null")
  if (is.list(x)) {
    nm <- names(x)
    if (!is.null(nm) && any(nzchar(nm))) {
      items <- vapply(seq_along(x), function(i) {
        paste0(rpg_json_string(nm[i]), ":", rpg_to_json(x[[i]]))
      }, character(1))
      return(paste0("{", paste(items, collapse = ","), "}"))
    }
    items <- vapply(x, rpg_to_json, character(1))
    return(paste0("[", paste(items, collapse = ","), "]"))
  }
  if (length(x) != 1) {
    items <- vapply(seq_along(x), function(i) rpg_to_json(x[[i]]), character(1))
    return(paste0("[", paste(items, collapse = ","), "]"))
  }
  if (is.character(x)) return(rpg_json_string(x))
  if (is.logical(x)) return(if (isTRUE(x)) "true" else "false")
  format(unclass(x), scientific = FALSE)
}

# Bridge for webR: draw a suggestion and return it as a JSON string.
# `registry` is the object loaded once at startup; themes/seen are plain
# character vectors built by the JavaScript side.
rpg_suggest_json <- function(registry, themes = character(0),
                             seen = character(0)) {
  rpg_to_json(rpg_suggest(registry, themes = themes, seen = seen))
}

# Pretty-print a suggestion in the console.
rpg_print <- function(s) {
  if (!identical(s$status, "ok")) {
    cat("No suggestion available (", s$status, ")\n", sep = "")
    return(invisible(s))
  }
  cat("\n== Your random project ==\n\n")
  cat("Dataset:   ", s$dataset$name, "\n")
  cat("           ", trimws(s$dataset$description), "\n")
  cat("Get it:    ", s$dataset$access$hint, "\n")
  cat("Link:      ", s$dataset$url, "\n\n")
  cat("Question   [", s$question$family, "]\n")
  cat("           ", trimws(s$question$text), "\n\n")
  cat("Challenge: ", s$challenge$name, "\n")
  cat("           ", trimws(s$challenge$description), "\n\n")
  invisible(s)
}
