# Codex install (quick reference)

> Verified locally against `codex-cli 0.122.0` on 2026-04-20 / 2026-04-21 UTC.
>
> `codex plugin marketplace add` works against this repo. The old `[[plugins]]` / `[[hooks.session_start]]` TOML flow is no longer the recommended path here.

Full guide: `../docs/README.codex.md`.

1. Register the marketplace:

       codex plugin marketplace add forsonny/leyline

   For a local checkout, run from the repo root:

       codex plugin marketplace add .

2. Restart Codex.

3. Install `leyline` from the `leyline-marketplace` entry in Codex's plugin UI.

4. Update later with:

       codex plugin marketplace upgrade leyline-marketplace

5. Confirm by starting a new session and asking "let's build X".
