# OpenCode install (quick reference)

Full guide: `../docs/README.opencode.md`.

1. Clone Leyline anywhere convenient:

   ```
   LEYLINE_REPO="$HOME/path/to/leyline"   # replace with your actual checkout path
   git clone https://github.com/forsonny/leyline.git "$LEYLINE_REPO"
   ```
2. Symlink the plugin entry into OpenCode's plugin directory:

   ```
   mkdir -p ~/.config/opencode/plugins
   ln -sf "$LEYLINE_REPO/.opencode/plugins/leyline.js" ~/.config/opencode/plugins/leyline.js
   ```

3. Restart OpenCode. The plugin syncs Leyline assets into `~/.config/opencode/` and injects its instructions automatically; no manual hook config is required.
4. Confirm by starting a new session and asking "let's build X" - the agent should invoke `brainstorming`.
