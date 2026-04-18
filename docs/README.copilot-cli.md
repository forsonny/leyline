# Leyline on GitHub Copilot CLI

> **UNVERIFIED.** The marketplace registration, plugin install, hook wiring, and tool-name mapping below have not been validated end-to-end against the current Copilot CLI release. They reflect the published Copilot CLI plugin documentation as of 2026-04-17 plus the AGENTS.md / `.github/plugin/marketplace.json` Leyline ships. If anything here is wrong, file an issue and update this file plus `../.github/plugin/marketplace.json` and `../AGENTS.md` accordingly.

Full guide: see also [`.codex/INSTALL.md`](../.codex/INSTALL.md) and [`.opencode/INSTALL.md`](../.opencode/INSTALL.md) for Codex / OpenCode parallels.

## Install

```
copilot plugin marketplace add https://github.com/forsonny/leyline
copilot plugin install leyline
```

The `marketplace add` command fetches the repo and reads `.github/plugin/marketplace.json`, which lists `leyline` as a plugin. The `install` command installs it.

Confirm with:

```
copilot plugin list
```

`leyline` should appear in the installed list.

## Verify

Start a new Copilot CLI session and say:

> Let's build a small CLI tool that counts files in a directory.

The agent should:
1. Recognize "let's build X" matches the routing table in `AGENTS.md`.
2. Invoke the `brainstorming` skill via the harness's skill mechanism.
3. Begin the brainstorming hard-gate sequence (do not write code; ask clarifying questions; produce a product spec).

If the agent writes code immediately or skips the skill check, the session-start hook may have failed. See "Hook-failure detection" in `AGENTS.md`.

## Tool-name mapping

Copilot CLI's tool naming overlaps Claude Code's at the top level but uses lowercase / different verbs in some places. Substitute when reading skill text:

| Skill text (Claude Code) | Copilot CLI equivalent |
|--------------------------|------------------------|
| `Read` | `read` / file-read |
| `Write` | `write` / file-write |
| `Edit` | `edit` / file-edit |
| `Glob` | `glob` / find |
| `Grep` | `grep` / search |
| `Bash` | `run` / shell |
| `Skill` | `skill` (lowercase; same semantics as Claude Code's Skill) |
| `WebFetch` | `fetch` (when enabled) |
| `WebSearch` | `search` (when enabled) |
| `TodoWrite` | Copilot's task-tracking tool, if enabled (opt-in) |
| `Task` (subagent dispatch) | Copilot's subagent dispatch tool, if enabled |

If a skill names a tool that has no Copilot CLI equivalent, the skill still applies; execute the closest available action and document the substitution in your reply so the human partner can see what was adapted.

## Limitations

- **Subagent support is more limited than Claude Code.** Skills that dispatch subagents (`subagent-driven-development`, the per-task review wrappers, `dispatching-parallel-agents`) work best when the harness exposes a clean dispatch primitive; Copilot CLI's primitive is partial. Use `executing-plans` as a fallback when `subagent-driven-development` cannot dispatch reviewers properly.

- **Parallel-dispatch primitive.** `dispatching-parallel-agents` (used by Stage 5 for independent failures and by Stage 7 for parallel code + design review) requires the harness to dispatch 2+ subagents concurrently in a single batch. Copilot CLI's subagent primitive does not always expose parallel batching; sequential dispatch is the fallback but leaks the first agent's framing into the second's context. When the parallel primitive is unavailable, the plugin works but Stage 7's code and design reviews run sequentially with reduced independence guarantees.

- **Hook firing.** Copilot CLI's hook format evolves; if `using-leyline` is not appearing as system context at session start, run `copilot plugin show leyline` to check the registered hook and consult the Copilot CLI release notes for the current hook schema.

- **Marketplace fetching.** Marketplace updates are not automatic by default. Re-run `copilot plugin marketplace add` periodically to pick up changes, or use `copilot plugin marketplace update` if your Copilot CLI version exposes it.

## Related

- `../AGENTS.md` - entry manifest Copilot CLI reads
- `../.github/plugin/marketplace.json` - Copilot CLI marketplace manifest
- `README.codex.md` - sibling install guide for Codex
- `README.opencode.md` - sibling install guide for OpenCode
- `../skills/using-leyline/SKILL.md` - entry skill the hook injects
- `../dev/reference/recommended-optional-tools.md` - optional tools the harness may expose
