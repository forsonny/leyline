# Leyline - Gemini CLI manifest

Leyline is an opinionated developer-session workflow plugin that ships a behavior-shaping skill library, two specialized reviewer subagents, and a session-start hook that injects the entry skill on every new or reset conversation.

This file is the entry manifest Gemini CLI reads when the Leyline extension is installed. It complements `gemini-extension.json`, which carries machine-readable extension metadata.

## First-response rule

```
Before any response or action - including clarifying questions - check whether any Leyline skill applies. If one does (probability >= 1%), invoke it before narrating. If none does, name the skills you considered and why you rejected each.
```

This rule is the single highest-leverage instruction in this manifest. It appears verbatim in `CLAUDE.md`, `AGENTS.md`, `README.md`, and `skills/using-leyline/SKILL.md` so every load path delivers it to the agent. Drift between files is caught by `scripts/check-manifests.sh`.

## Gemini CLI skill activation

In Gemini CLI, skill metadata is loaded at session start and full skill content is activated on demand via the `activate_skill` tool. When the agent identifies a skill that applies, it calls `activate_skill` with the skill name. The tool returns the skill content for the agent to follow.

Leyline's entry skill `using-leyline` is pre-activated by the session-start hook so skill-checking begins before the first response.

## Discovery

- **Skills** under `skills/` (flat namespace). Each skill is a folder with `SKILL.md`.
- **Subagents** under `agents/`.
- **Session-start hook** wired through `gemini-extension.json`.

## Pipeline

| # | Stage | Skill(s) |
|---|-------|----------|
| 1 | Discovery | `brainstorming`, `design-brainstorming` |
| 2 | Interrogate | `deep-discovery`, `design-interrogation` (conditional) |
| 3 | Isolate | `using-git-worktrees` |
| 4 | Plan | `writing-plans` |
| 5 | Execute | `subagent-driven-development` or `executing-plans` |
| 6 | Discipline | Code + Experience overlays |
| 7 | Review | `requesting-code-review`, `receiving-code-review`, plus `requesting-design-review` and `receiving-design-review` when surfaces are touched; dispatches `code-reviewer` and `design-reviewer` subagents |
| 8 | Finish | `finishing-a-development-branch` |

Each skill names its successor.

## Iron laws

- `NO PRODUCTION CODE WITHOUT A FAILING TEST FIRST`
- `NO FIXES WITHOUT ROOT CAUSE INVESTIGATION FIRST`
- `NO COMPLETION CLAIMS WITHOUT FRESH VERIFICATION EVIDENCE`
- `NO USER-FACING SURFACE WITHOUT AN APPROVED DESIGN ARTIFACT FIRST`
- `NO COMPLETION CLAIMS ON A USER-FACING SURFACE WITHOUT FRESH ACCESSIBILITY EVIDENCE`

> Violating the letter of the rules is violating the spirit of the rules.

## Tool-name mapping for Gemini CLI

Skills are authored against Claude Code tool names. Substitute as follows when acting in Gemini CLI:

| Skill text (Claude Code) | Gemini CLI equivalent |
|--------------------------|-----------------------|
| `Skill` | `activate_skill` |
| `Read` | `read_file` |
| `Edit` | `edit_file` or `replace` |
| `Write` | `write_file` |
| `Glob` | `glob` |
| `Grep` | `search_file_content` |
| `Bash` | `run_shell_command` |
| `TodoWrite` | the native task-tracking tool, if enabled |
| `Task` (subagent dispatch) | the native subagent dispatch tool, if enabled |

If a skill references a tool that has no Gemini CLI equivalent, the skill still applies; execute the closest available action and document the substitution.

## Terminology

- **Human partner** (never "user").
- **Discovery** (stage 1), not "Design".
- **Experience** (6b overlay), not "Frontend" / "UI".
- **UX artifact**, not "mockup".

## Contributor rules

- No third-party dependencies except to add harness support.
- No domain-specific skills; those belong in standalone plugins that extend Leyline.
- Skills are behavior-shaping code. Modifications require pressure-test evidence under `tests/`.
- Final step of any work: update `CHANGELOG.md` and bump version via `scripts/bump-version.sh`.

## Related

- `gemini-extension.json` - extension manifest for Gemini CLI
- `README.md`
- `CLAUDE.md`, `AGENTS.md` - manifests for other harnesses
- `skills/using-leyline/SKILL.md` - entry skill
