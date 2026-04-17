# Leyline on OpenCode

> **UNVERIFIED.** The auto-discovery path (`~/.opencode/plugins/`), the JavaScript shim shape, and the `hooks.sessionStart` config below are starting points based on the dev/ corpus. They have not been validated end-to-end against the current OpenCode release. If anything here is wrong, file an issue and update this file plus `.opencode/plugins/leyline.js`.

OpenCode installs Leyline as a local plugin with a small JavaScript shim.

## Install

1. Clone the Leyline repo:

       git clone https://github.com/forsonny/leyline.git ~/.opencode/plugins/leyline

2. OpenCode auto-discovers plugins under `~/.opencode/plugins/`. The plugin entry point is `.opencode/plugins/leyline.js` (referenced by `package.json`'s `main` field).

3. Wire the session-start hook manually if OpenCode does not honor the JSON registration in `hooks/`:

   Add to `~/.opencode/config.json`:

       {
         "hooks": {
           "sessionStart": {
             "command": "~/.opencode/plugins/leyline/hooks/session-start",
             "args": ["session-start"],
             "async": false
           }
         }
       }

   On Windows, substitute `hooks/run-hook.cmd`.

4. Restart OpenCode.

## Verify

Start a new session and say "let's build a login page." The agent should invoke `brainstorming`.

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

- Subagent support in OpenCode is variable. `executing-plans` is the safer choice in most OpenCode sessions; `subagent-driven-development` works when the harness provides a subagent dispatch tool.
- `hooks-cursor.json` is not used by OpenCode; the `hooks/` scripts are the source of truth.
- **Parallel-dispatch primitive.** `dispatching-parallel-agents` requires concurrent dispatch of 2+ subagents. OpenCode's subagent support is limited and parallel batching is not guaranteed. When unavailable, sequential dispatch is a fallback with reduced independence guarantees. Stage 7's code + design review run sequentially in that configuration.

## Related

- `../AGENTS.md` - entry manifest OpenCode reads
- `../.opencode/plugins/leyline.js` - plugin shim
- `../hooks/session-start`, `../hooks/run-hook.cmd`
- `README.codex.md` - sibling install guide for Codex
