# `docs/` — installation guides, spec archive, supplementary reference

**Location:** `docs/` at the repo root.

## Contents

- `README.codex.md` — install and usage guide for Codex
- `README.opencode.md` — install and usage guide for OpenCode
- `testing.md` — testing methodology notes applied across the plugin
- `plans/` — archive of implementation plans (produced by `writing-plans`)
- `leyline/` — design-spec archive:
  - `specs/YYYY-MM-DD-<topic>-design.md` — brainstorming output, committed per project
  - may also contain per-feature design material referenced by plans
- `windows/` — Windows-specific notes (path handling, launcher behavior)

## Why per-harness READMEs live here

Claude Code and Cursor install from plugin marketplaces and don't need standalone install docs — the root `README.md` covers them. Codex and OpenCode still need harness-specific notes beyond the root README, so they keep dedicated docs under `docs/`.

For Codex specifically, the harness doc also explains the repo marketplace and plugin manifest layout:

- `.agents/plugins/marketplace.json` — repo marketplace file Codex reads for discovery
- `.codex-plugin/plugin.json` — plugin manifest Codex reads after installation

## Spec archive convention

The `brainstorming` skill saves its design doc to `docs/leyline/specs/YYYY-MM-DD-<topic>-design.md` and commits it. The timestamp prefix keeps the archive chronologically sortable. User preferences in `CLAUDE.md` can override the location.

## Plan archive convention

The `writing-plans` skill saves its plan to `docs/leyline/plans/YYYY-MM-DD-<feature-name>.md`. Same timestamp convention. Plans reference specs by path.

## Related

- `structure/tests.md` — testing methodology is expanded there from `docs/testing.md`
- `structure/manifests.md` — the root files installers reference
- `stages/01-discovery.md`, `stages/04-plan.md` — skills that write into this directory
