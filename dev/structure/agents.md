# `agents/` — specialized subagent definitions

**Location:** `agents/` at the repo root.
**Canonical files:** `agents/code-reviewer.md`, `agents/design-reviewer.md`.

## Role

Subagents receive precisely crafted context rather than inheriting the parent session. This keeps them focused on their job (reviewing, implementing, investigating) and preserves the parent agent's context for coordination work.

## `code-reviewer.md`

**Frontmatter:**
- `name: code-reviewer`
- `description:` multi-line, includes usage examples with `<example>` blocks showing when to trigger (after a major project step)
- `model: inherit`

**Role:** Senior Code Reviewer. Expertise in software architecture, design patterns, best practices.

**Review procedure (six blocks):**

1. **Plan alignment analysis** — compare implementation to plan, identify deviations, assess whether justified
2. **Code quality assessment** — adherence to patterns/conventions, error handling, type safety, defensive programming, organization, naming, maintainability, test coverage, security, performance
3. **Architecture and design review** — SOLID principles, separation of concerns, loose coupling, integration, scalability, extensibility
4. **Documentation and standards** — comments, file headers, function docs, project-specific conventions
5. **Issue identification and recommendations** — categorize as **Critical** (must fix), **Important** (should fix), or **Suggestions** (nice to have); each with specific examples and actionable recommendations; note plan deviations (problematic vs. beneficial); offer code examples when useful
6. **Communication protocol** — ask the coding agent to review significant plan deviations; recommend plan updates if the plan itself has issues; acknowledge what was done well before flagging issues

**Output:** Structured, actionable, focused on both code quality and goal alignment.

## Dispatched by

- `requesting-code-review` — the canonical caller (mandatory after each subagent-driven task, after major features, before merge)
- `subagent-driven-development` — second of its two review passes (code quality), via `code-quality-reviewer-prompt.md`

## Inputs the reviewer expects

- `{WHAT_WAS_IMPLEMENTED}` — brief of what was built
- `{PLAN_OR_REQUIREMENTS}` — the plan or spec to align against
- `{BASE_SHA}` — starting commit
- `{HEAD_SHA}` — ending commit
- `{DESCRIPTION}` — short summary

## `design-reviewer.md`

**Frontmatter:**
- `name: design-reviewer`
- `description:` multi-line with `<example>` blocks showing dispatch triggers (after tasks touching a user-facing surface, before merge, when a UX regression is suspected)
- `model: inherit`

**Role:** Senior Experience Reviewer. Expertise in interaction design, information architecture, accessibility (WCAG 2.2), visual hierarchy, cross-platform UX conventions.

**Review procedure (six blocks, mirrors code-reviewer):**

1. **Artifact alignment** — compare implemented surface to UX spec; every state in the matrix implemented and reachable; identify deviations and assess whether justified
2. **Flow correctness** — walk every documented flow end-to-end; confirm error paths and recovery
3. **State completeness** — empty, loading, error, success, permission-denied, offline: each exists or is explicitly omitted per spec
4. **Accessibility assessment** — keyboard operability, focus management, screen-reader narration, contrast, text scaling, motion preference
5. **Voice and tone coherence** — against spec's example strings and platform conventions
6. **Issue identification** — Critical / Important / Suggestions with specific, actionable recommendations and artifact references

**Harness-aware capability detection.** The subagent inspects the session's available tools at dispatch (browser automation, design-tool MCPs, a11y scanners, snapshot tools) and uses them when present. Falls back to structural review based on code reading and spec comparison when none are available. See `reference/recommended-optional-tools.md`.

**Dispatched by:**
- `requesting-design-review` — canonical caller (mandatory when surfaces touched, before merge)
- `subagent-driven-development` — third review pass when a task touches a user-facing surface

**Inputs the reviewer expects:**
- `{UX_SPEC}` — path to the UX artifact
- `{SURFACES_IMPLEMENTED}` — list of surfaces touched
- `{ACCESSIBILITY_EVIDENCE}` — output of the a11y check run
- `{BASE_SHA}` / `{HEAD_SHA}` / `{DESCRIPTION}`

## Related

- `stages/07-review.md` — full stage writeup
- `stages/05-execute.md` — two-stage review during execution
- `principles/behavior-shaping.md` — why a subagent is used instead of the main agent
