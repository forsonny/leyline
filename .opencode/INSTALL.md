# OpenCode install (quick reference)

Full guide: `../docs/README.opencode.md`.

1. Add Leyline to the `plugin` array in `opencode.json`:

   ```
   {
     "$schema": "https://opencode.ai/config.json",
     "plugin": ["leyline@git+https://github.com/forsonny/leyline.git"]
   }
   ```
2. Restart OpenCode. The plugin installs via Bun and injects its instructions automatically.
3. Confirm by starting a new session and asking "let's build X" - the agent should invoke `brainstorming`.

For local checkout development instead of the native plugin-array install:

   ```
   LEYLINE_REPO="$HOME/path/to/leyline"   # replace with your actual checkout path
   git clone https://github.com/forsonny/leyline.git "$LEYLINE_REPO"
   mkdir -p ~/.config/opencode/plugins
   ln -sf "$LEYLINE_REPO/.opencode/plugins/leyline.js" ~/.config/opencode/plugins/leyline.js
   ```
