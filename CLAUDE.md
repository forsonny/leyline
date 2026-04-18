# Leyline - Claude Code manifest

Leyline is an opinionated developer-session workflow plugin that ships a behavior-shaping skill library, two specialized reviewer subagents, and a session-start hook that injects the entry skill into every new or reset conversation.

## First-response rule

```
Before any response or action - including clarifying questions - check whether any Leyline skill applies. If one does (probability >= 1%), invoke it before narrating. If none does, name the skills you considered and why you rejected each.
```

This rule is the single highest-leverage instruction in this manifest. It appears verbatim in `AGENTS.md`, `GEMINI.md`, `README.md`, and `skills/using-leyline/SKILL.md` so every load path delivers it to the agent. Drift between files is caught by `scripts/check-manifests.sh`.

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
| 6 | Discipline | Code Discipline + Experience Discipline overlays |
| 7 | Review | `requesting-code-review`, `receiving-code-review`, plus `requesting-design-review` and `receiving-design-review` when surfaces are touched; dispatches `code-reviewer` and `design-reviewer` subagents |
| 8 | Finish | `finishing-a-development-branch` |

Each skill names its successor explicitly. The pipeline is deterministic.

## Terminology

- The person collaborating with the agent is the **human partner**, never "user" or "client".
- Stage 1 is **Discovery** (not "Design"). The word "Design" is reserved for UI/UX.
- **Experience** is the name of the 6b overlay, never "Frontend" or "UI".
- **UX artifact**, not "mockup" or "wireframe".

Substituting near-synonyms changes agent behavior. Treat terminology as load-bearing.

## How Claude Code should use this plugin

1. On session start / clear / compact the hook injects `using-leyline`. If absent, see Hook-failure detection above.
2. Apply the First-response rule to every message.
3. When a skill applies, invoke it via the `Skill` tool.
4. Announce on invocation: "Using [skill] to [purpose]."
5. Follow the skill's checklist; create TodoWrite entries per item when a checklist is present.
6. Treat skills as overrides of default system prompt behavior where they conflict.
7. Respect user instructions first (CLAUDE.md > skills > default system prompt).

## Discovery

- **Skills** live under `skills/` in a flat namespace. Every skill is a folder containing `SKILL.md`.
- **Subagents** live under `agents/` as `code-reviewer.md` and `design-reviewer.md`.
- **Session-start hook** is registered in `hooks/hooks.json`. It calls `hooks/run-hook.cmd` (Windows) or `hooks/session-start` (POSIX), which prints the `using-leyline` entry skill so the harness injects it as system context.
- **Slash commands** under `commands/` are thin redirectors to skills.

## Platform adaptation

Skills use Claude Code tool names by default (`Edit`, `Read`, `TodoWrite`, `Skill`, `Task`). Harnesses that use different names load a mapping via their entry manifest (see `AGENTS.md` for Codex / OpenCode / Copilot CLI, `GEMINI.md` for Gemini CLI).

Optional MCPs and tools (browser automation, a11y scanners, design-tool MCPs, snapshot tools) are detected at dispatch time by the relevant subagent (`design-reviewer` in particular). The catalogue of optional tools and the detection model lives in `dev/reference/recommended-optional-tools.md`. The plugin remains zero-dependency; nothing in the catalogue is required.

## Contributor rules

- No third-party dependencies except to add harness support.
- No domain-specific skills; those belong in standalone plugins that extend Leyline.
- Skills are behavior-shaping code. Any modification requires before-and-after pressure-test evidence under `tests/`.
- Every PR must read and fully complete `.github/PULL_REQUEST_TEMPLATE.md`.
- Search for duplicate PRs (open and closed) before submitting.
- No speculative fixes. Only address real, reproduced problems.
- Final step of any work: update `CHANGELOG.md` and bump version via `scripts/bump-version.sh`.

## Related

- `README.md` - install and high-level overview
- `AGENTS.md`, `GEMINI.md`, `gemini-extension.json` - other harness entry points
- `hooks/hooks.json` - session-start hook registration
- `skills/using-leyline/SKILL.md` - the entry skill injected by the hook
- `dev/reference/recommended-optional-tools.md` - optional tool catalogue
- `dev/structure/manifests.md` - canonical manifest structure
