# Harness matrix

Per-harness support for the plugin's mechanisms.

## Supported harnesses

| Harness | Install method | Entry manifest | Hook file | Slash commands | Subagents | End-to-end verified |
|---------|----------------|----------------|-----------|----------------|-----------|---------------------|
| Claude Code (self-hosted marketplace) | `/plugin marketplace add forsonny/leyline` then `/plugin install leyline@leyline-marketplace` | `CLAUDE.md` | `hooks/hooks.json` | yes | yes | alpha (install paths set up; traces pending per `tests/skill-triggering/`) |
| Cursor | `/add-plugin leyline` or marketplace search | `CLAUDE.md` | `hooks/hooks-cursor.json` | yes | yes | unverified (see `hooks/hooks-cursor.json` and `docs/windows/launcher-notes.md`; the env variable name `${CURSOR_PLUGIN_ROOT}` has not been confirmed against current Cursor docs) |
| Codex | `codex plugin marketplace add forsonny/leyline`, then install from Codex's plugin UI | `AGENTS.md` | session-start injection not yet revalidated | limited | yes | partial (marketplace registration verified on `codex-cli 0.122.0`; final UI install and hook firing still unverified) |
| OpenCode | Manual fetch + follow `.opencode/INSTALL.md` | `AGENTS.md` | manual wiring | limited | limited | unverified (auto-discovery path and shim shape have not been confirmed against current OpenCode docs) |
| GitHub Copilot CLI | `copilot plugin marketplace add` + `plugin install` | `AGENTS.md` | via marketplace | yes | limited | unverified |
| Gemini CLI | `gemini extensions install https://github.com/.../leyline` | `GEMINI.md` + `gemini-extension.json` | via extension | yes | limited | unverified |

## Capability notes

- **Subagent support is not universal.** `executing-plans` exists as a fallback for harnesses without strong subagent support. The skill itself tells the human partner that the plugin works significantly better with subagents and recommends switching to `subagent-driven-development` when possible.
- **Hook formats differ.** Claude Code uses `hooks.json`; Cursor uses `hooks-cursor.json`. Both point at the same launcher script.
- **Manifest file discovery.** Claude Code and Cursor read `CLAUDE.md`. Codex/OpenCode/Copilot CLI read `AGENTS.md`. Gemini CLI reads both `GEMINI.md` and `gemini-extension.json` for extension-level metadata.

## Platform-specific docs

- `docs/README.codex.md` — Codex install and notes
- `docs/README.opencode.md` — OpenCode install and notes
- `docs/windows/` — Windows-specific launcher and path notes

## Tool-name adaptation

Skills use Claude Code tool names by default (e.g., `Edit`, `Read`, `TodoWrite`). Non-Claude-Code platforms need tool-name mapping:
- Copilot CLI: see `skills/using-leyline/references/copilot-tools.md`
- Codex: see `skills/using-leyline/references/codex-tools.md`
- Gemini CLI: mapping loaded automatically via `GEMINI.md`

## Verification after install

Start a new session in the chosen harness. Ask for something that should trigger a skill (e.g., "help me plan this feature" or "let's debug this issue"). The agent should automatically invoke the relevant skill and announce it.

## Related

- `structure/manifests.md` — the per-harness manifest files
- `structure/hooks.md` — hook registration
- `reference/session-start-hook.md` — hook wiring
- `structure/docs.md` — per-harness README files under `docs/`
