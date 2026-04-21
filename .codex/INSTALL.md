# Codex install (quick reference)

> Verified locally against `codex-cli 0.122.0` on 2026-04-20 / 2026-04-21 UTC.
>
> Current Codex expects a repo marketplace at `.agents/plugins/marketplace.json` and a plugin manifest at `.codex-plugin/plugin.json`.

Full guide: `../docs/README.codex.md`.

1. Register the marketplace from the repo root:

       codex plugin marketplace add forsonny/leyline

   For a local checkout, run from the repo root:

       codex plugin marketplace add .

2. Restart Codex.

3. Open Plugins and switch the source filter away from `Built by OpenAI` if needed.

4. Install `leyline` from the `Leyline Plugins` / `leyline-marketplace` entry in Codex's plugin UI.

5. Update later with:

       codex plugin marketplace upgrade leyline-marketplace

6. Confirm by starting a new thread and invoking `@leyline` or one of its bundled skills explicitly.
