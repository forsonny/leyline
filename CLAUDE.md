# Leyline - Claude Code manifest

Leyline is an opinionated developer-session workflow plugin that ships a behavior-shaping skill library, two specialized reviewer subagents, and a session-start hook that injects the entry skill into every new or reset conversation.

## First-response rule

```
Before any response or action - including clarifying questions - check whether any Leyline skill applies. If one does (probability >= 1%), invoke it before narrating. If none does, name the skills you considered and why you rejected each.
```

This rule is the single highest-leverage instruction in this manifest. It appears verbatim in `AGENTS.md`, `GEMINI.md`, `README.md`, and `skills/using-leyline/SKILL.md` so every load path delivers it to the agent. Drift between files is caught by `scripts/check-manifests.sh`.

## Discovery

- **Skills** live under `skills/` in a flat namespace. Every skill is a folder containing `SKILL.md`.
- **Subagents** live under `agents/` as `code-reviewer.md` and `design-reviewer.md`.
- **Session-start hook** is registered in `hooks/hooks.json`. It calls `hooks/run-hook.cmd` (Windows) or `hooks/session-start` (POSIX), which prints the `using-leyline` entry skill so the harness injects it as system context.
- **Slash commands** under `commands/` are thin redirectors to skills.

## How Claude Code should use this plugin

1. On session start / clear / compact the hook injects `using-leyline`.
2. `using-leyline` mandates a skill check before any response, including clarifying questions.
3. When a skill's description matches the situation (probability >= 1%), invoke it via the `Skill` tool.
4. Announce on invocation: "Using [skill] to [purpose]."
5. Follow the skill's checklist; create TodoWrite entries per item when a checklist is present.
6. Treat skills as overrides of default system prompt behavior where they conflict.
7. Respect user instructions first (CLAUDE.md > skills > default system prompt).

## Pipeline (stages in order)

| # | Stage | Skill(s) | Exit |
|---|-------|----------|------|
| 1 | Discovery | `brainstorming`, `design-brainstorming` | Both specs approved |
| 2 | Interrogate | `deep-discovery`, `design-interrogation` (conditional) | Specs survive 100-question pressure test |
| 3 | Isolate | `using-git-worktrees` | Isolated branch workspace, green baseline |
| 4 | Plan | `writing-plans` | Plan of 2-5 minute tasks with exact paths and code |
| 5 | Execute | `subagent-driven-development` or `executing-plans` | All tasks complete; reviews passed |
| 6 | Discipline | Code Discipline + Experience Discipline overlays | Five iron laws satisfied |
| 7 | Review | `requesting-code-review`, `receiving-code-review`, plus `requesting-design-review` and `receiving-design-review` when surfaces are touched; dispatches `code-reviewer` and `design-reviewer` subagents | Critical + Important findings resolved |
| 8 | Finish | `finishing-a-development-branch` | Merge / PR / keep / discard executed |

Each skill names its successor explicitly. The pipeline is deterministic.

## Iron laws

**Code Discipline:**
- `NO PRODUCTION CODE WITHOUT A FAILING TEST FIRST`
- `NO FIXES WITHOUT ROOT CAUSE INVESTIGATION FIRST`
- `NO COMPLETION CLAIMS WITHOUT FRESH VERIFICATION EVIDENCE`

**Experience Discipline:**
- `NO USER-FACING SURFACE WITHOUT AN APPROVED DESIGN ARTIFACT FIRST`
- `NO COMPLETION CLAIMS ON A USER-FACING SURFACE WITHOUT FRESH ACCESSIBILITY EVIDENCE`

> Violating the letter of the rules is violating the spirit of the rules.

## Terminology

- The person collaborating with the agent is the **human partner**, never "user" or "client".
- Stage 1 is **Discovery** (not "Design"). The word "Design" is reserved for UI/UX.
- **Experience** is the name of the 6b overlay, never "Frontend" or "UI".
- **UX artifact**, not "mockup" or "wireframe".

Substituting near-synonyms changes agent behavior. Treat terminology as load-bearing.

## Contributor rules

- No third-party dependencies except to add harness support.
- No domain-specific skills; those belong in standalone plugins that extend Leyline.
- Skills are behavior-shaping code. Any modification requires before-and-after pressure-test evidence under `tests/`.
- Every PR must read and fully complete `.github/PULL_REQUEST_TEMPLATE.md`.
- Search for duplicate PRs (open and closed) before submitting.
- No speculative fixes. Only address real, reproduced problems.
- Final step of any work: update `CHANGELOG.md` and bump version via `scripts/bump-version.sh`.

## Platform adaptation

Skills use Claude Code tool names by default (`Edit`, `Read`, `TodoWrite`, `Skill`, `Task`). Harnesses that use different names load a mapping via their entry manifest (see `AGENTS.md` for Codex / OpenCode / Copilot CLI, `GEMINI.md` for Gemini CLI).

## Related

- `README.md` - install and high-level overview
- `AGENTS.md`, `GEMINI.md`, `gemini-extension.json` - other harness entry points
- `hooks/hooks.json` - session-start hook registration
- `skills/using-leyline/SKILL.md` - the entry skill injected by the hook
