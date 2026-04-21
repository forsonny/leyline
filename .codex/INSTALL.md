# Codex install (quick reference)

> Verified locally against `codex-cli 0.122.0` on 2026-04-20 / 2026-04-21 UTC.
>
> Current Codex expects a repo marketplace at `.agents/plugins/marketplace.json` and a plugin manifest at `.codex-plugin/plugin.json`.
>
> Current Codex docs also load hooks from `.codex/hooks.json` or `~/.codex/hooks.json` and custom agents from `.codex/agents/*.toml` or `~/.codex/agents/*.toml`. Hooks are experimental and the official Codex hooks docs currently disable them on Windows (checked 2026-04-21 UTC).

Full guide: `../docs/README.codex.md`.

1. Register the marketplace from the repo root:

       codex plugin marketplace add forsonny/leyline

   For a local checkout, run from the repo root:

       codex plugin marketplace add .

2. Restart Codex.

3. Open Plugins and switch the source filter away from `Built by OpenAI` if needed.

4. Install `leyline` from the `Leyline Plugins` / `leyline-marketplace` entry in Codex's plugin UI.

5. If you are working in this repo on macOS/Linux, trust the project so Codex can load the bundled `.codex/config.toml`, `.codex/hooks.json`, and `.codex/agents/*.toml`.

6. If you are using Leyline as an installed plugin from some other repo, copy this repo's `.codex/hooks.json` and `.codex/agents/*.toml` into `~/.codex/`. Codex loads hooks and custom agents from active config layers, not from the plugin manifest itself.

7. On Windows, skip hook setup. Current Codex hooks are disabled there; start sessions with `@leyline` or invoke a bundled skill explicitly.

8. Update later with:

       codex plugin marketplace upgrade leyline-marketplace

9. Confirm by starting a new thread.

   On macOS/Linux with the repo-scoped or home-scoped hook configured, the first response should cite `using-leyline`.

   On Windows, verify with `@leyline` or one of Leyline's bundled skills explicitly.

Codex does not currently expose Leyline's `commands/` files as plugin slash commands. Expect built-in Codex slash commands like `/plugins`, but use `@leyline` or explicit skills for Leyline itself.
