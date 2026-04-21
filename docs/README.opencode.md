# Leyline on OpenCode

Leyline installs on OpenCode as a real plugin module, not as a metadata shim and not via manual hook wiring.

OpenCode discovers local plugin files from either `.opencode/plugins/` in the current project or `~/.config/opencode/plugins/` globally. Leyline's recommended install uses the global plugin directory and a symlink back to your repo checkout.

The plugin does three things on startup:

1. Syncs Leyline's `skills/`, `commands/`, and OpenCode-compatible `agents/` into `~/.config/opencode/`
2. Injects `AGENTS.md` into the system prompt
3. Injects `skills/using-leyline/SKILL.md` into the system prompt so the first-response rule is active from the first turn

## Install from a local checkout

1. Clone Leyline anywhere convenient:

       git clone https://github.com/forsonny/leyline.git ~/src/leyline

2. Symlink the plugin entry into OpenCode's global plugin directory.

   POSIX:

        mkdir -p ~/.config/opencode/plugins
        ln -sf ~/src/leyline/.opencode/plugins/leyline.js ~/.config/opencode/plugins/leyline.js

   PowerShell:

       New-Item -ItemType Directory -Force "$HOME/.config/opencode/plugins" | Out-Null
       New-Item -ItemType SymbolicLink -Force -Path "$HOME/.config/opencode/plugins/leyline.js" -Target "$HOME/src/leyline/.opencode/plugins/leyline.js" | Out-Null

3. Restart OpenCode.

Because the plugin resolves its real path before loading assets, symlinking the single `leyline.js` entry file is enough; you do not need to copy the whole repository into the plugin directory.

Do not copy only `leyline.js` into `~/.config/opencode/plugins/` by itself. The plugin expects to resolve back to the full Leyline checkout so it can read `AGENTS.md`, `skills/`, `commands/`, and `agents/` from the repo.

If you prefer a project-only install, create the same symlink at `<your-project>/.opencode/plugins/leyline.js` instead. OpenCode discovers project-local plugins from that directory too.

## Install from npm

If Leyline is published to npm, OpenCode can install it directly from `opencode.json` because the package now exports a valid plugin module:

```json
{
  "$schema": "https://opencode.ai/config.json",
  "plugin": ["leyline"]
}
```

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
