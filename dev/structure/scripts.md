# `scripts/` — build and lifecycle helpers

**Location:** `scripts/` at the repo root.

## Current contents

- `bump-version.sh` — version bump helper used when cutting a release. Edits `package.json` version, updates `CHANGELOG.md` / `RELEASE-NOTES.md`, tags appropriately.

## Role

The plugin ships zero-dependency at runtime. `scripts/` is the seam for tooling that supports the release and maintenance lifecycle without adding a runtime dependency on third-party tools.

## Candidates for expansion

- Frontmatter linter for `skills/**/SKILL.md` (validate `name` regex, `description` presence, <1024-char total)
- Graphviz/DOT rendering for skill process diagrams (pairs with `reference/diagrams.md`)
- Per-harness install automation (mirrors the install docs under `docs/`)
- Test harness for the `tests/` scenarios

Anything runtime-required by the plugin itself should live in `skills/*/scripts/` alongside the skill that uses it, not in top-level `scripts/`.

## Related

- `structure/metadata.md` — `package.json`, `CHANGELOG.md`, `RELEASE-NOTES.md` conventions that `bump-version.sh` touches
- `structure/tests.md` — what `scripts/` might orchestrate
- `reference/skill-file-format.md` — frontmatter rules a linter would enforce
