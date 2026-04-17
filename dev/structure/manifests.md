# Per-harness manifests (repo root)

Each supported harness (Claude Code, Cursor, Codex, OpenCode, Copilot CLI, Gemini CLI) reads a specific entry file at the repo root to discover skills, agents, and hooks.

## Files

| File | Harness | Role |
|------|---------|------|
| `CLAUDE.md` | Claude Code (also serves as the contributor guidelines for the repo) | Entry file + project rules |
| `AGENTS.md` | Codex and other AGENTS.md-reading harnesses | Entry file |
| `GEMINI.md` | Gemini CLI | Entry file with platform adaptation notes |
| `gemini-extension.json` | Gemini CLI | Extension manifest (discovery/metadata) |
| `README.md` | Humans | Installation and philosophy |

## Manifest content

`AGENTS.md`, `CLAUDE.md`, and `GEMINI.md` are independent regular files. They share substantial content (pipeline table, iron laws, terminology) but are not symlinks; each carries harness-specific framing (tool-name mapping notes for AGENTS.md and GEMINI.md; contributor guidelines in CLAUDE.md). A drift lint (`scripts/check-manifests.sh`) keeps the shared sections in sync.

## Contributor content in `CLAUDE.md`

The project's `CLAUDE.md` doubles as strict contributor guidelines. Notable rules:
- 94% PR rejection rate; most rejected PRs are agent-submitted "slop"
- Every PR must read and fully complete `.github/PULL_REQUEST_TEMPLATE.md`
- Search for duplicate PRs (open AND closed) before submitting
- "Compliance" changes to skills require extensive eval evidence
- No third-party dependencies unless adding a new harness
- No domain-specific skills — those belong in standalone plugins
- No speculative/theoretical fixes; real problems only
- Skills are behavior-shaping code; modifications require before/after eval evidence

## Related

- `structure/hooks.md` — how `hooks.json` / `hooks-cursor.json` complement the manifests
- `reference/harness-matrix.md` — per-harness feature availability
- `principles/behavior-shaping.md` — why terminology/discipline in these files is treated as load-bearing
