#!/usr/bin/env python3
"""Python twin of R/build_registry.R for environments without R (e.g. CI).

Compiles data/*.yaml -> docs/registry.json and copies R/generator.R into docs/.
"""
import json
import pathlib
import shutil
import sys

import yaml

ROOT = pathlib.Path(__file__).resolve().parent.parent


def load(name):
    with open(ROOT / "data" / name) as f:
        return yaml.safe_load(f)


def question_matches(question, dataset):
    tags = set(dataset["shape_tags"])
    req_all = question.get("requires_all")
    req_any = question.get("requires_any")
    if req_all and not set(req_all) <= tags:
        return False
    if req_any and not set(req_any) & tags:
        return False
    return True


def r_literal(x, indent=0):
    """Serialise nested dict/list/scalar structures as an R list() literal."""
    pad = "  " * indent
    if x is None:
        return "NULL"
    if isinstance(x, bool):
        return "TRUE" if x else "FALSE"
    if isinstance(x, (int, float)):
        return repr(x)
    if isinstance(x, str):
        esc = x.replace("\\", "\\\\").replace('"', '\\"').replace("\n", "\\n")
        return f'"{esc}"'
    if isinstance(x, dict):
        items = ",\n".join(
            f"{pad}  `{k}` = {r_literal(v, indent + 1)}" for k, v in x.items()
        )
        return f"list(\n{items}\n{pad})"
    if isinstance(x, list):
        if all(isinstance(v, str) for v in x):
            return "c(" + ", ".join(r_literal(v) for v in x) + ")"
        items = ",\n".join(f"{pad}  {r_literal(v, indent + 1)}" for v in x)
        return f"list(\n{items}\n{pad})"
    raise TypeError(f"cannot serialise {type(x)}")


def main():
    registry = {
        "datasets": load("datasets.yaml"),
        "questions": load("questions.yaml"),
        "challenges": load("challenges.yaml"),
    }

    errors = []
    for key in registry:
        ids = [item["id"] for item in registry[key]]
        if len(ids) != len(set(ids)):
            errors.append(f"duplicate ids in {key}")
    for ds in registry["datasets"]:
        if not ds.get("themes"):
            errors.append(f"{ds['id']}: no themes")
        if not ds.get("shape_tags"):
            errors.append(f"{ds['id']}: no shape_tags")
        n = sum(question_matches(q, ds) for q in registry["questions"])
        if n == 0:
            errors.append(f"{ds['id']}: matches no question archetype")
        else:
            print(f"{ds['id']:<28} {n:2d} matching archetypes")
    for q in registry["questions"]:
        if "{dataset}" not in q["template"] and q["id"] != "simulation-uncertainty":
            errors.append(f"{q['id']}: template missing {{dataset}} placeholder")
    DIFFICULTIES = {"mild", "medium", "spicy", "extra-spicy"}
    for ch in registry["challenges"]:
        if ch.get("difficulty") not in DIFFICULTIES:
            errors.append(f"{ch['id']}: difficulty must be one of {sorted(DIFFICULTIES)}")
    if errors:
        sys.exit("Validation failed:\n  " + "\n  ".join(errors))

    docs = ROOT / "docs"
    docs.mkdir(exist_ok=True)
    with open(docs / "registry.json", "w") as f:
        json.dump(registry, f, indent=2, ensure_ascii=False)
        f.write("\n")
    # dget()-readable R literal so the webR app needs no JSON package.
    with open(docs / "registry.R", "w") as f:
        f.write(r_literal(registry) + "\n")
    shutil.copy(ROOT / "R" / "generator.R", docs / "generator.R")

    pairs = sum(
        question_matches(q, ds)
        for ds in registry["datasets"]
        for q in registry["questions"]
    )
    total = pairs * len(registry["challenges"])
    print(
        f"Wrote docs/registry.json: {len(registry['datasets'])} datasets, "
        f"{len(registry['questions'])} questions, "
        f"{len(registry['challenges'])} challenges ({total} total combos)"
    )


if __name__ == "__main__":
    main()
