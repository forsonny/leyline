# OpenCode install (quick reference)

> **UNVERIFIED.** The OpenCode auto-discovery path, plugin shim shape, and `hooks.sessionStart` config below have not been confirmed against current OpenCode documentation. If OpenCode rejects the plugin or fails to fire the hook, consult the latest OpenCode docs and update this file plus `../docs/README.opencode.md` and `../.opencode/plugins/leyline.js`.

Full guide: `../docs/README.opencode.md`.

1. Clone into `~/.opencode/plugins/leyline`:

   ```
   git clone https://github.com/forsonny/leyline.git ~/.opencode/plugins/leyline
   ```
2. OpenCode auto-discovers plugins under `~/.opencode/plugins/`.
3. If the session-start hook does not fire automatically, wire it manually in `~/.opencode/config.json`:

   ```
   {
     "hooks": {
       "sessionStart": {
         "command": "~/.opencode/plugins/leyline/hooks/session-start",
         "args": ["session-start"],
         "async": false
       }
     }
   }
   ```

4. Restart OpenCode. Confirm by starting a new session and asking "let's build X" - the agent should invoke `brainstorming`.
