# Leyline on Codex

> Verified locally against `codex-cli 0.122.0` on 2026-04-20 / 2026-04-21 UTC.
>
> Verified in this session:
> - `codex plugin marketplace add <source>` exists and works.
> - This repo is accepted as a Codex marketplace source.
> - Codex records marketplace registrations in `~/.codex/config.toml`.
> - Current Codex docs require a repo marketplace at `.agents/plugins/marketplace.json`.
> - Current Codex docs require a plugin manifest at `.codex-plugin/plugin.json`.
> - Current Codex docs load hooks from `~/.codex/hooks.json` or `<repo>/.codex/hooks.json`, behind `[features].codex_hooks`.
> - Current Codex docs load custom agents from `~/.codex/agents/` or `<repo>/.codex/agents/`.
> - Current Codex docs say subagent workflows are enabled by default.
> - Current Codex CLI exposes `marketplace add`, `marketplace upgrade`, and `marketplace remove`, but no shell-level `codex plugin install` subcommand.
>
> Important current product constraint:
> - Official Codex hooks docs say hooks are experimental and disabled on Windows as of 2026-04-21.
>
> Not verified end-to-end in this session:
> - the final install click path inside the Codex UI
> - a live POSIX Codex session trace showing the bundled hook firing after install

Codex installs Leyline through the plugin marketplace flow, but Codex hooks and custom agents are separate config-layer features. Plugin manifests do not auto-register either one.

The important distinction is that Codex's official Plugin Directory is curated. Third-party plugins do not show up there automatically. For a repo like Leyline to appear in Codex, the repo itself must expose a repo marketplace at `.agents/plugins/marketplace.json`, and the plugin must expose `.codex-plugin/plugin.json`.

For direct work inside this repo, Leyline now also ships repo-scoped Codex config in `.codex/config.toml`, `.codex/hooks.json`, and `.codex/agents/*.toml`. If you want the same hook and reviewer-agent behavior outside this repo, copy those files into `~/.codex/`.

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

5. If you are working in this repo on macOS/Linux, trust the project so Codex can load the bundled `.codex/config.toml`, `.codex/hooks.json`, and `.codex/agents/*.toml`.

6. If you are using Leyline as an installed plugin from some other repo, copy this repo's `.codex/hooks.json` and `.codex/agents/*.toml` into `~/.codex/`.

   Codex currently looks for hooks and custom agents next to active config layers, not inside plugin manifests.

7. On Windows, skip hook setup. Current official Codex docs say hooks are disabled there. Use `@leyline` or an explicit skill invocation instead.

8. To pick up marketplace changes later, run:

       codex plugin marketplace upgrade leyline-marketplace

## Verify

Verify in a few short checks:

1. Open the Plugins UI and confirm `leyline` appears under the repo marketplace, not only under the OpenAI-curated list.
2. Start a new thread.
3. If you are on macOS/Linux and the repo-scoped or home-scoped hook is configured, the first response should cite `using-leyline` automatically.
4. If you are on Windows, or you did not copy the `.codex/` hook files into an active config layer, invoke the plugin explicitly, for example `@leyline help me plan a login page`.
5. Ask Codex to use the `code-reviewer` or `design-reviewer` agent names, or run a Leyline stage that dispatches them. When Codex is running in this repo, the repo-scoped `.codex/agents/*.toml` files provide those roles. Outside this repo, copy the same files into `~/.codex/agents/`.

Expected behavior after install:

- `leyline` is visible and installable in the Plugins UI.
- Codex can invoke `@leyline` or a bundled skill directly.
- On macOS/Linux with `.codex/hooks.json` active, Codex can inject `using-leyline` automatically at session start.
- Codex can use the repo-scoped `code-reviewer` and `design-reviewer` custom agents when running inside this repo.
- Codex does **not** surface Leyline's `commands/` markdown files as plugin slash commands. Use `@leyline` or an explicit skill instead.

If the agent follows the `AGENTS.md` first-response rule but says the entry skill is missing, treat that as Codex taking the hook-failure path, not as successful session-start injection.

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
| `Task` (subagent dispatch) | Codex's subagent tool |

## Limitations

- **Plugin-defined slash commands are not exposed in Codex.** Codex's slash-command docs currently describe built-in Codex commands such as `/plugins`, `/model`, and `/permissions`, but the Codex plugin manifest format does not include a `commandsDirectory` equivalent. Leyline's `commands/` directory exists for other harnesses and should not be expected to appear in Codex.
- **Hooks are config-layer features, not plugin-manifest fields.** For Codex, `hooks.json` must live at `~/.codex/hooks.json` or `<repo>/.codex/hooks.json`, and custom agents live at `~/.codex/agents/` or `<repo>/.codex/agents/`.
- **Hooks remain experimental and are disabled on Windows in the current official Codex hooks docs.** On Windows, use explicit `@leyline` or skill invocation.
- **Subagent workflows are built in, but the reviewer role names come from `.codex/agents/*.toml`.** Repo-scoped files work when Codex is running in this repo; copy them to `~/.codex/agents/` for cross-repo use.

## Related

- `../AGENTS.md` - entry manifest Codex reads
- `../.agents/plugins/marketplace.json` - Codex repo marketplace manifest
- `../.codex-plugin/plugin.json` - Codex plugin manifest
- `../.codex/config.toml` - repo-scoped Codex feature and agent settings
- `../.codex/hooks.json` - repo-scoped Codex hook registration
- `../.codex/agents/code-reviewer.toml`
- `../.codex/agents/design-reviewer.toml`
- `../hooks/session-start` - POSIX launcher
- `../hooks/run-hook.cmd` - Windows launcher
- `README.opencode.md` - sibling install guide for OpenCode
