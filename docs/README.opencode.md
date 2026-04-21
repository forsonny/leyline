# Leyline on OpenCode

Leyline installs on OpenCode as a real plugin module, not as a metadata shim and not via manual hook wiring.

OpenCode supports both npm/git-installed plugins through the `plugin` array and local plugin files from `.opencode/plugins/` or `~/.config/opencode/plugins/`. Leyline's recommended install uses the native `plugin` array, just like other OpenCode plugins.

The plugin does three things on startup:

1. Syncs Leyline's `skills/`, `commands/`, and OpenCode-compatible `agents/` into `~/.config/opencode/`
2. Injects `AGENTS.md` into the system prompt
3. Injects `skills/using-leyline/SKILL.md` into the system prompt so the first-response rule is active from the first turn

## Recommended install

Add Leyline to the `plugin` array in your `opencode.json` (global or project-level):

```json
{
  "$schema": "https://opencode.ai/config.json",
  "plugin": ["leyline@git+https://github.com/forsonny/leyline.git"]
}
```

Restart OpenCode. The plugin auto-installs via Bun and then injects Leyline's manifest and entry skill automatically.

To pin a specific version, add a tag or branch to the git URL:

```json
{
  "$schema": "https://opencode.ai/config.json",
  "plugin": ["leyline@git+https://github.com/forsonny/leyline.git#v1.2.5"]
}
```

## Local checkout install

If you are developing Leyline itself or want to run from a working copy, symlink the local plugin entry instead.

1. Clone Leyline anywhere convenient:

       LEYLINE_REPO="$HOME/path/to/leyline"   # replace with your actual checkout path
       git clone https://github.com/forsonny/leyline.git "$LEYLINE_REPO"

2. Symlink the plugin entry into OpenCode's global plugin directory.

   POSIX:

        mkdir -p ~/.config/opencode/plugins
        ln -sf "$LEYLINE_REPO/.opencode/plugins/leyline.js" ~/.config/opencode/plugins/leyline.js

   PowerShell:

        $LeylineRepo = "$HOME\path\to\leyline"  # replace with your actual checkout path
        git clone https://github.com/forsonny/leyline.git $LeylineRepo
        New-Item -ItemType Directory -Force "$HOME/.config/opencode/plugins" | Out-Null
        Remove-Item "$HOME/.config/opencode/plugins/leyline.js" -Force -ErrorAction SilentlyContinue
        New-Item -ItemType SymbolicLink -Force -Path "$HOME/.config/opencode/plugins/leyline.js" -Target "$LeylineRepo/.opencode/plugins/leyline.js" | Out-Null

3. Restart OpenCode.

Because the plugin resolves its real path before loading assets, symlinking the single `leyline.js` entry file is enough; you do not need to copy the whole repository into the plugin directory.

Do not copy only `leyline.js` into `~/.config/opencode/plugins/` by itself. The plugin expects to resolve back to the full Leyline checkout so it can read `AGENTS.md`, `skills/`, `commands/`, and `agents/` from the repo.

If you prefer a project-only install, create the same symlink at `<your-project>/.opencode/plugins/leyline.js` instead. OpenCode discovers project-local plugins from that directory too.

## Migrating from the old symlink-first install

If you previously installed Leyline with a cloned repo and symlink, you can switch to the native `plugin` array install:

1. Remove the old symlink from `~/.config/opencode/plugins/leyline.js` if you created one.
2. Remove any repo-specific Leyline plugin symlink under `.opencode/plugins/leyline.js` if you created one in a project.
3. Add `"leyline@git+https://github.com/forsonny/leyline.git"` to the `plugin` array in `opencode.json`.
4. Restart OpenCode.

## Verify

Start a new OpenCode session and say:

> let's build a login page

Expected behavior:

- The agent announces it is using Leyline
- The first applicable skill is invoked before any normal narration
- `brainstorming` is selected for this opening

Automated verification for the plugin contract lives in `tests/opencode/plugin-install.test.mjs`.

## Tool-name mapping

OpenCode uses these names; substitute when reading skill text:

| Skill text (Claude Code) | OpenCode equivalent |
|--------------------------|---------------------|
| `Read` | `fs_read` |
| `Write` | `fs_write` |
| `Edit` | `fs_edit` |
| `Glob` | `fs_glob` |
| `Grep` | `fs_grep` |
| `Bash` | `sh` |
| `Skill` | `skill` |
| `TodoWrite` | OpenCode's task tool, if enabled |
| `Task` (subagent dispatch) | OpenCode's subagent tool, if enabled |

## Limitations

- Subagent support in OpenCode is variable. `executing-plans` is the safer choice in sessions without reliable subagent dispatch; `subagent-driven-development` works when the harness provides it.
- `dispatching-parallel-agents` assumes truly concurrent subagent execution. When OpenCode cannot provide that, sequential dispatch is the fallback with reduced independence guarantees.
- The plugin syncs Leyline-owned files into `~/.config/opencode/{skills,commands,agents}`. If you have local customizations with the same names, Leyline's shipped copies will replace them on plugin load.

## Related

- `../AGENTS.md` - Leyline manifest injected by the plugin
- `../.opencode/plugins/leyline.js` - OpenCode plugin module
- `../tests/opencode/plugin-install.test.mjs` - automated plugin verification
- `README.codex.md` - sibling install guide for Codex
