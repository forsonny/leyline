# Leyline - AGENTS.md manifest (Codex, OpenCode, Copilot CLI)

Leyline is an opinionated developer-session workflow plugin that ships a behavior-shaping skill library, two specialized reviewer subagents, and a session-start hook that injects the entry skill on every new or reset conversation.

This file is the entry manifest read by agent harnesses that consume `AGENTS.md`: Codex, OpenCode, and GitHub Copilot CLI.

## First-response rule

```
Before any response or action - including clarifying questions - check whether any Leyline skill applies. If one does (probability >= 1%), invoke it before narrating. If none does, name the skills you considered and why you rejected each.
```

This rule is the single highest-leverage instruction in this manifest. It appears verbatim in `CLAUDE.md`, `GEMINI.md`, `README.md`, and `skills/using-leyline/SKILL.md` so every load path delivers it to the agent. Drift between files is caught by `scripts/check-manifests.sh`.

## Discovery

- **Skills** live under `skills/` in a flat namespace. Every skill is a folder containing `SKILL.md`.
- **Subagents** live under `agents/` as `code-reviewer.md` and `design-reviewer.md`.
- **Session-start hook** registration depends on the harness. See `hooks/` for launchers and `docs/README.codex.md` / `docs/README.opencode.md` for per-harness wiring.
- **Slash commands** under `commands/` are thin redirectors to skills.

## Pipeline

Leyline defines an eight-stage pipeline. Each skill names its successor explicitly.

| # | Stage | Skill(s) |
|---|-------|----------|
| 1 | Discovery | `brainstorming`, `design-brainstorming` |
| 2 | Interrogate | `deep-discovery`, `design-interrogation` (conditional) |
| 3 | Isolate | `using-git-worktrees` |
| 4 | Plan | `writing-plans` |
| 5 | Execute | `subagent-driven-development` or `executing-plans` |
| 6 | Discipline | Code Discipline (TDD, systematic-debugging, verification-before-completion) + Experience Discipline (design-driven-development, accessibility-verification) overlays |
| 7 | Review | `requesting-code-review`, `receiving-code-review`, plus `requesting-design-review` and `receiving-design-review` when surfaces are touched; dispatches `code-reviewer` and `design-reviewer` subagents |
| 8 | Finish | `finishing-a-development-branch` |

## Iron laws

**Code Discipline:**
- `NO PRODUCTION CODE WITHOUT A FAILING TEST FIRST`
- `NO FIXES WITHOUT ROOT CAUSE INVESTIGATION FIRST`
- `NO COMPLETION CLAIMS WITHOUT FRESH VERIFICATION EVIDENCE`

**Experience Discipline:**
- `NO USER-FACING SURFACE WITHOUT AN APPROVED DESIGN ARTIFACT FIRST`
- `NO COMPLETION CLAIMS ON A USER-FACING SURFACE WITHOUT FRESH ACCESSIBILITY EVIDENCE`

> Violating the letter of the rules is violating the spirit of the rules.

## How the agent should use this plugin

1. On each new or reset session, load `skills/using-leyline/SKILL.md` as the first context.
2. Before any response - including clarifying questions - check whether any skill's description matches the situation. If a skill might apply (probability >= 1%), invoke it.
3. Announce invocation: "Using [skill] to [purpose]."
4. Follow skill checklists; create per-item task entries using the harness's task-tracking tool.
5. Respect user instructions first. Skills override default system prompt behavior where they conflict; user instructions override skills.

## Tool-name mapping

Skills are authored against Claude Code tool names. Harness-specific mappings:

- **Codex** - see `docs/README.codex.md` for the Codex tool-name table.
- **OpenCode** - see `docs/README.opencode.md`.
- **Copilot CLI** - the `skill` tool is equivalent to Claude Code's `Skill` tool.

When a skill references a Claude Code tool (for example `TodoWrite`), substitute the equivalent from the harness's table before acting.

## Terminology

- The person collaborating with the agent is the **human partner**.
- Stage 1 is **Discovery**. "Design" is reserved for UI/UX.
- **Experience** names the 6b overlay.
- **UX artifact**, not "mockup".

## Contributor rules

- No third-party dependencies except to add harness support.
- Skills are behavior-shaping code. Modifications require pressure-test evidence under `tests/`.
- Final step of any work: update `CHANGELOG.md` and bump version via `scripts/bump-version.sh`.

## Related

- `README.md`
- `CLAUDE.md` - Claude Code entry manifest and contributor guidelines
- `GEMINI.md` - Gemini CLI entry manifest
- `docs/README.codex.md`, `docs/README.opencode.md` - per-harness install notes
- `skills/using-leyline/SKILL.md` - entry skill
