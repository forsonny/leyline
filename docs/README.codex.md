# Leyline on Codex

> Verified locally against `codex-cli 0.122.0` on 2026-04-20 / 2026-04-21 UTC.
>
> Verified in this session:
> - `codex plugin marketplace add <source>` exists and works.
> - This repo is accepted as a Codex marketplace source.
> - Codex records marketplace registrations in `~/.codex/config.toml`.
> - Current Codex docs require a repo marketplace at `.agents/plugins/marketplace.json`.
> - Current Codex docs require a plugin manifest at `.codex-plugin/plugin.json`.
> - Current Codex CLI exposes `marketplace add`, `marketplace upgrade`, and `marketplace remove`, but no shell-level `codex plugin install` subcommand.
>
> Not verified end-to-end in this session:
> - the final install click path inside the Codex UI
> - whether Codex currently injects Leyline's entry skill at session start the same way Claude Code does

Codex currently installs Leyline through Codex's plugin marketplace flow, not through manual `[[plugins]]` or `[[hooks.session_start]]` edits in `~/.codex/config.toml`.

The important distinction is that Codex's official Plugin Directory is curated. Third-party plugins do not show up there automatically. For a repo like Leyline to appear in Codex, the repo itself must expose a repo marketplace at `.agents/plugins/marketplace.json`, and the plugin must expose `.codex-plugin/plugin.json`.

## Install

1. Register the Leyline marketplace from GitHub:

       codex plugin marketplace add forsonny/leyline

   If you are developing from a local checkout instead, run the command from the repo root:

       codex plugin marketplace add .

2. Restart Codex.

3. Open Plugins in Codex.

   In the Codex app, the top filter can be set to `Built by OpenAI`. If it is, third-party repo plugins will be hidden. Switch that filter to `All` or to the marketplace title Codex shows for the repo.

4. Install `leyline` from the `Leyline Plugins` / `leyline-marketplace` entry in Codex's plugin UI.

   As of `codex-cli 0.122.0`, Codex exposes marketplace management in the CLI but does not expose a shell-level `codex plugin install` command, so the final install step happens inside Codex rather than by editing `config.toml`.

5. To pick up marketplace changes later, run:

       codex plugin marketplace upgrade leyline-marketplace

## Verify

Verify in two parts:

1. Open the Plugins UI and confirm `leyline` appears under the repo marketplace, not only under the OpenAI-curated list.
2. Start a new thread and invoke the plugin explicitly, for example `@leyline help me plan a login page`.

Expected behavior after install:

- `leyline` is visible and installable in the Plugins UI.
- Codex can invoke `@leyline` or a bundled skill directly.

Session-start injection remains a separate question. If the agent follows the `AGENTS.md` first-response rule but says the entry skill is missing, treat that as Codex taking the hook-failure path, not as successful session-start injection.

## Tool-name mapping

The install flow above is the part verified against the current Codex CLI. The mapping below remains a working reference rather than a fully revalidated table against Codex 0.122.0.

Codex uses these names; substitute when reading skill text:

| Skill text (Claude Code) | Codex equivalent |
|--------------------------|------------------|
| `Read` | `read` |
| `Write` | `write` |
| `Edit` | `edit` |
| `Glob` | `glob` |
| `Grep` | `grep` |
| `Bash` | `shell` |
| `Skill` | `skill` |
| `TodoWrite` | Codex's task-tracking tool, if enabled |
| `Task` (subagent dispatch) | Codex's subagent tool, if enabled |

## Limitations

- Subagent support in Codex is more limited than Claude Code. Use `executing-plans` as a fallback when `subagent-driven-development` cannot dispatch reviewers properly.
- Leyline's session-start injection path has not yet been revalidated end-to-end on current Codex. Expect explicit `@leyline` or skill invocation to matter until that is confirmed.
- **Parallel-dispatch primitive.** `dispatching-parallel-agents` (used by Stage 5 for independent failures and by Stage 7 for parallel code + design review) requires the harness to dispatch 2+ subagents concurrently in a single batch. Codex's subagent dispatch primitive does not always expose parallel batching; sequential dispatch is a fallback but leaks the first agent's framing into the second's context. When the parallel primitive is unavailable, the plugin works but Stage 7's code and design reviews run sequentially with reduced independence guarantees.

## Related

- `../AGENTS.md` - entry manifest Codex reads
- `../.agents/plugins/marketplace.json` - Codex repo marketplace manifest
- `../.codex-plugin/plugin.json` - Codex plugin manifest
- `../hooks/session-start` - POSIX launcher
- `../hooks/run-hook.cmd` - Windows launcher
- `README.opencode.md` - sibling install guide for OpenCode
