# GitHub Copilot CLI tool-name mapping

Skills are authored against Claude Code tool names. When operating in Copilot CLI, substitute as below.

| Skill text (Claude Code) | Copilot CLI equivalent | Notes |
|--------------------------|------------------------|-------|
| `Read` | `read` / file-read | Reads a file path. |
| `Write` | `write` / file-write | Creates or overwrites. |
| `Edit` | `edit` / file-edit | Prefer over `write` for in-place changes. |
| `Glob` | `glob` / find | File-pattern search. |
| `Grep` | `grep` / search | Content search. |
| `Bash` | `run` / shell | Shell execution. |
| `Skill` | `skill` | Lowercase in Copilot CLI; same semantics as Claude Code. |
| `WebFetch` | `fetch` | URL fetch, when enabled. |
| `WebSearch` | `search` | Search engine query, when enabled. |
| `TodoWrite` | Copilot's task-tracking tool, if enabled | Task tracking is opt-in. If absent, follow checklists inline. |
| `Task` (subagent dispatch) | Copilot's subagent dispatch tool, if enabled | Subagent support in Copilot CLI is more limited than Claude Code; fall back to `executing-plans` when dispatch is unavailable. |

## Tool-availability rule

If a skill names a tool that has no Copilot CLI equivalent, the skill still applies. Execute the closest available action and document the substitution in your reply so the human partner can see what was adapted.

## Verification

Copilot CLI's tool naming evolves. This file is a hand-maintained snapshot. If a tool name here disagrees with what Copilot CLI exposes, trust the harness and open a PR to fix this file.

## Related

- `../SKILL.md` - the entry skill
- `codex-tools.md` - sibling mapping for Codex
- `../../../AGENTS.md` - manifest read by Copilot CLI
