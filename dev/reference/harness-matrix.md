# Harness matrix

Per-harness support for the plugin's mechanisms.

## Supported harnesses

| Harness | Install method | Entry manifest | Hook file | Slash commands | Subagents | End-to-end verified |
|---------|----------------|----------------|-----------|----------------|-----------|---------------------|
| Claude Code (self-hosted marketplace) | `/plugin marketplace add forsonny/leyline` then `/plugin install leyline@leyline-marketplace` | `CLAUDE.md` | `hooks/hooks.json` | yes | yes | alpha (install paths set up; traces pending per `tests/skill-triggering/`) |
| Cursor | `/add-plugin leyline` or marketplace search | `CLAUDE.md` | `hooks/hooks-cursor.json` | yes | yes | unverified (see `hooks/hooks-cursor.json` and `docs/windows/launcher-notes.md`; the env variable name `${CURSOR_PLUGIN_ROOT}` has not been confirmed against current Cursor docs) |
| Codex | `codex plugin marketplace add forsonny/leyline`, then install from Codex's plugin UI via the repo marketplace in `.agents/plugins/marketplace.json` | `AGENTS.md` | `.codex/hooks.json` (repo/home config layer; experimental; disabled on Windows per current Codex docs) | built-in only; plugin command files are not surfaced | yes (enabled by default in current Codex docs) | partial (marketplace registration verified on `codex-cli 0.122.0`; repo now ships `.codex` config aligned with current docs; final UI install and live POSIX hook trace still unverified) |
| OpenCode | Clone repo + symlink `.opencode/plugins/leyline.js` into `~/.config/opencode/plugins/` | `AGENTS.md` (injected by plugin) | none; plugin injects `AGENTS.md` + `using-leyline` directly | yes | yes | partial (plugin export, asset sync, and prompt injection covered by `tests/opencode/plugin-install.test.mjs`; live TUI smoke still recommended) |
| GitHub Copilot CLI | `copilot plugin marketplace add` + `plugin install` | `AGENTS.md` | via marketplace | yes | limited | unverified |
| Gemini CLI | `gemini extensions install https://github.com/.../leyline` | `GEMINI.md` + `gemini-extension.json` | via extension | yes | limited | unverified |

## Capability notes

- **Subagent support is not universal.** `executing-plans` exists as a fallback for harnesses without strong subagent support. The skill itself tells the human partner that the plugin works significantly better with subagents and recommends switching to `subagent-driven-development` when possible.
- **Hook formats differ.** Claude Code uses `hooks.json`; Cursor uses `hooks-cursor.json`. Both point at the same launcher script.
- **Codex hooks are config-layer features.** Current Codex docs load them from `~/.codex/hooks.json` or `<repo>/.codex/hooks.json`, behind `[features].codex_hooks`, and the same docs currently disable hooks on Windows.
- **Codex reviewer agents are config-layer features too.** Current Codex docs load custom agents from `~/.codex/agents/` or `<repo>/.codex/agents/`; Leyline now ships repo-scoped `code-reviewer` and `design-reviewer` TOML definitions there.
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

Start a new session in the chosen harness. Ask for something that should trigger a skill (e.g., "help me plan this feature" or "let's debug this issue"). The agent should automatically invoke the relevant skill and announce it. In Codex on macOS/Linux, that automatic path depends on `.codex/hooks.json` being active. In Codex on Windows, current official docs disable hooks, so verify with explicit `@leyline` or a direct skill invocation instead.

## Related

- `structure/manifests.md` — the per-harness manifest files
- `structure/hooks.md` — hook registration
- `reference/session-start-hook.md` — hook wiring
- `structure/docs.md` — per-harness README files under `docs/`
