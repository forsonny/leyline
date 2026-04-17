# Leyline on Codex

> **UNVERIFIED.** The TOML config shape (`[[plugins]]`, `[[hooks.session_start]]`) and the tool-name table below are starting points based on the dev/ corpus. They have not been validated end-to-end against the current Codex release. If anything here is wrong, file an issue and update this file plus `skills/using-leyline/references/codex-tools.md`.

Codex does not ship Leyline through a plugin marketplace. Install manually.

## Install

1. Clone the Leyline repo into a location Codex can read at session start:

       git clone https://github.com/forsonny/leyline.git ~/.codex/plugins/leyline

2. Add Leyline to Codex's discovery path. In `~/.codex/config.toml` (create if needed):

       [[plugins]]
       name = "leyline"
       path = "~/.codex/plugins/leyline"
       manifest = "AGENTS.md"

3. Wire the session-start hook manually. Codex supports session hooks; register the launcher:

       [[hooks.session_start]]
       command = "~/.codex/plugins/leyline/hooks/session-start"
       args = ["session-start"]
       async = false

   On Windows, substitute `hooks/run-hook.cmd`.

4. Restart Codex. The entry skill `using-leyline` should appear as system context on the next session.

## Verify

Start a new session and say "let's build a login page." The agent should announce it is using Leyline and invoke `brainstorming`.

## Tool-name mapping

Codex uses these names; substitute when reading skill text:

| Skill text (Claude Code) | Codex equivalent |
|--------------------------|------------------|
| `Read` | `read` |
| `Write` | `write` |
| `Edit` | `edit` |
| `Glob` | `glob` |
| `Grep` | `grep` |
| `Bash` | `shell` |
| `Skill` | `skill` |
| `TodoWrite` | Codex's task-tracking tool, if enabled |
| `Task` (subagent dispatch) | Codex's subagent tool, if enabled |

## Limitations

- Subagent support in Codex is more limited than Claude Code. Use `executing-plans` as a fallback when `subagent-driven-development` cannot dispatch reviewers properly.
- Codex's hook format evolves. Check the Codex release notes if the session-start hook stops firing.
- **Parallel-dispatch primitive.** `dispatching-parallel-agents` (used by Stage 5 for independent failures and by Stage 7 for parallel code + design review) requires the harness to dispatch 2+ subagents concurrently in a single batch. Codex's subagent dispatch primitive does not always expose parallel batching; sequential dispatch is a fallback but leaks the first agent's framing into the second's context. When the parallel primitive is unavailable, the plugin works but Stage 7's code and design reviews run sequentially with reduced independence guarantees.

## Related

- `../AGENTS.md` - entry manifest Codex reads
- `../hooks/session-start` - POSIX launcher
- `../hooks/run-hook.cmd` - Windows launcher
- `README.opencode.md` - sibling install guide for OpenCode
