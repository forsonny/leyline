# Codex install (quick reference)

> **UNVERIFIED.** The Codex `[[plugins]]` and `[[hooks.session_start]]` TOML keys below have not been confirmed against current Codex documentation. Treat as a starting point; if Codex rejects the config or fails to fire the hook, consult the latest Codex docs and update this file plus `../docs/README.codex.md`.

Full guide: `../docs/README.codex.md`.

1. Clone into `~/.codex/plugins/leyline  (after `git clone https://github.com/forsonny/leyline.git ~/.codex/plugins/leyline`)`.
2. Register the plugin in `~/.codex/config.toml`:

   ```
   [[plugins]]
   name = "leyline"
   path = "~/.codex/plugins/leyline  (after `git clone https://github.com/forsonny/leyline.git ~/.codex/plugins/leyline`)"
   manifest = "AGENTS.md"
   ```

3. Wire the session-start hook in the same file:

   ```
   [[hooks.session_start]]
   command = "~/.codex/plugins/leyline  (after `git clone https://github.com/forsonny/leyline.git ~/.codex/plugins/leyline`)/hooks/session-start"
   args = ["session-start"]
   async = false
   ```

   On Windows, substitute `hooks/run-hook.cmd`.

4. Restart Codex. Confirm by starting a new session and asking "let's build X".
