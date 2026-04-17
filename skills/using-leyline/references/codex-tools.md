# Codex tool-name mapping

Skills are authored against Claude Code tool names. When operating in Codex, substitute as below.

| Skill text (Claude Code) | Codex equivalent | Notes |
|--------------------------|------------------|-------|
| `Read` | `read` | Reads a file path; same semantics. |
| `Write` | `write` | Overwrites or creates a file. |
| `Edit` | `edit` | Targeted edit; prefer over `write` for in-place changes. |
| `Glob` | `glob` | File-pattern search. |
| `Grep` | `grep` | Content search; uses ripgrep under the hood. |
| `Bash` | `shell` | Shell execution. |
| `Skill` | `skill` | Skill invocation - lowercase in Codex. |
| `WebFetch` | `web_fetch` | URL fetch. |
| `WebSearch` | `web_search` | Search engine query. |
| `TodoWrite` | Codex's task-tracking tool, if enabled | Task tracking is opt-in in Codex; if absent, follow checklists inline. |
| `Task` (subagent dispatch) | Codex's subagent tool, if enabled | Subagent support is variable; fall back to `executing-plans` if dispatch is unavailable. |

## Tool-availability rule

If a skill names a tool that has no Codex equivalent, the skill still applies. Execute the closest available action and document the substitution in your reply so the human partner can see what was adapted.

## Verification

Codex's tool naming evolves. This file is a hand-maintained snapshot. If a tool name here disagrees with what Codex exposes, trust the harness and open a PR to fix this file.

## Related

- `../SKILL.md` - the entry skill
- `../../../docs/README.codex.md` - install guide for Codex
- `copilot-tools.md` - sibling mapping for Copilot CLI
