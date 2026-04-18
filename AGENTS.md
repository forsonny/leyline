# Leyline - AGENTS.md manifest (Codex, OpenCode, Copilot CLI)

Leyline is an opinionated developer-session workflow plugin that ships a behavior-shaping skill library, two specialized reviewer subagents, and a session-start hook that injects the entry skill on every new or reset conversation.

This file is the entry manifest read by agent harnesses that consume `AGENTS.md`: Codex, OpenCode, and GitHub Copilot CLI.

## First-response rule

```
Before any response or action - including clarifying questions - check whether any Leyline skill applies. If one does (probability >= 1%), invoke it before narrating. If none does, name the skills you considered and why you rejected each.
```

This rule is the single highest-leverage instruction in this manifest. It appears verbatim in `CLAUDE.md`, `GEMINI.md`, `README.md`, and `skills/using-leyline/SKILL.md` so every load path delivers it to the agent. Drift between files is caught by `scripts/check-manifests.sh`.

## Iron laws

**Code Discipline:**
- `NO PRODUCTION CODE WITHOUT A FAILING TEST FIRST`
- `NO FIXES WITHOUT ROOT CAUSE INVESTIGATION FIRST`
- `NO COMPLETION CLAIMS WITHOUT FRESH VERIFICATION EVIDENCE`

**Experience Discipline:**
- `NO USER-FACING SURFACE WITHOUT AN APPROVED DESIGN ARTIFACT FIRST`
- `NO COMPLETION CLAIMS ON A USER-FACING SURFACE WITHOUT FRESH ACCESSIBILITY EVIDENCE`

> Violating the letter of the rules is violating the spirit of the rules.

## Hook-failure detection

The session-start hook injects `skills/using-leyline/SKILL.md` into your context on every new / cleared / compacted conversation. If you do NOT see `using-leyline` content as system context at the start of this session, the hook silently failed. Surface this to the human partner immediately and proceed using only the manifest's first-response rule. Do NOT continue silently - sessions that proceed past a hook failure produce inconsistent discipline across messages.

## Routing - where to enter

Map the human partner's opening message to the right entry skill:

| Human partner says | Entry skill |
|--------------------|-------------|
| "let's build X", "I want to add Y", "we should make Z" | `brainstorming` (stage 1a) |
| "debug this", "fix this bug", "something is broken" | `systematic-debugging` (6a.2) |
| "review this code" | `requesting-code-review` (stage 7) |
| "start implementing the plan", "execute the plan" | `subagent-driven-development` or `executing-plans` (stage 5) |

Full routing table including kept-branch resume, planning, and finishing entry points lives in `skills/using-leyline/SKILL.md`.

## Pipeline (stages in order)

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

## Terminology

- The person collaborating with the agent is the **human partner**.
- Stage 1 is **Discovery**. "Design" is reserved for UI/UX.
- **Experience** names the 6b overlay.
- **UX artifact**, not "mockup".

## How the agent should use this plugin

1. On each new or reset session, the harness should load `skills/using-leyline/SKILL.md` via the session-start hook. If absent, see Hook-failure detection above.
2. Apply the First-response rule to every message.
3. When a skill applies, invoke it via the harness's skill mechanism.
4. Announce invocation: "Using [skill] to [purpose]."
5. Follow skill checklists; create per-item task entries using the harness's task-tracking tool.
6. Respect user instructions first. Skills override default system prompt behavior where they conflict; user instructions override skills.

## Tool-name mapping

Skills are authored against Claude Code tool names. Per-harness mapping:

- **Codex** - see `docs/README.codex.md` for the Codex tool-name table and install steps.
- **OpenCode** - see `docs/README.opencode.md` for the OpenCode tool-name table and install steps.
- **Copilot CLI** - see `docs/README.copilot-cli.md` for the Copilot CLI tool-name table, install steps, and the parallel-dispatch primitive availability note.

When a skill references a Claude Code tool (for example `TodoWrite`), substitute the equivalent from the harness's table before acting.

Optional MCPs and tools (browser automation, a11y scanners, design-tool MCPs, snapshot tools) are detected at dispatch time by the relevant subagent. Catalogue: `dev/reference/recommended-optional-tools.md`. Zero-dependency; nothing in the catalogue is required.

## Related

- `README.md`
- `CLAUDE.md` - Claude Code entry manifest and contributor guidelines
- `GEMINI.md` - Gemini CLI entry manifest
- `docs/README.codex.md`, `docs/README.opencode.md`, `docs/README.copilot-cli.md` - per-harness install notes
- `skills/using-leyline/SKILL.md` - entry skill
- `dev/reference/recommended-optional-tools.md` - optional tool catalogue
