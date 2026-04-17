# `skills/` — the behavior-shaping library

**Location:** `skills/` at the repo root.
**Namespace:** Flat — no nested categories. Every skill is a top-level folder inside `skills/`.

## Per-skill folder contents

- `SKILL.md` — required, the main reference. YAML frontmatter (`name`, `description`) plus body.
- Optional supporting files:
  - Heavy reference material (100+ lines) that would clutter `SKILL.md`
  - Reusable prompt templates (e.g., `implementer-prompt.md`, `spec-reviewer-prompt.md`)
  - Scripts or rendering tools
  - Subject-specific anti-pattern catalogues (e.g., `testing-anti-patterns.md`)

Keep inline in `SKILL.md`: principles, code patterns under ~50 lines, all process content.

## Full inventory

| Skill | Purpose (one line) | Iron law? |
|-------|--------------------|-----------|
| `brainstorming` | Hard-gated design refinement before any implementation skill runs | Hard gate |
| `dispatching-parallel-agents` | Concurrent subagents across independent problem domains | No |
| `executing-plans` | Batched plan execution with human checkpoints (fallback when subagents unavailable) | No |
| `finishing-a-development-branch` | Verify tests, present merge/PR/keep/discard, clean up | No |
| `receiving-code-review` | Technical handling of review feedback, forbidden phrases | No |
| `requesting-code-review` | Dispatch `code-reviewer` subagent with constructed context | No |
| `subagent-driven-development` | Fresh subagent per task + two- or three-stage review (spec, then quality, then design when surfaces touched) | No |
| `systematic-debugging` | Four-phase root-cause process | "NO FIXES WITHOUT ROOT CAUSE INVESTIGATION FIRST" |
| `test-driven-development` | RED-GREEN-REFACTOR | "NO PRODUCTION CODE WITHOUT A FAILING TEST FIRST" |
| `using-git-worktrees` | Isolated branch workspace with directory selection + safety verification | No |
| `using-leyline` | Session-start entry skill injected by the hook; forces skill-checking before any response | No |
| `verification-before-completion` | Evidence before claims of success | "NO COMPLETION CLAIMS WITHOUT FRESH VERIFICATION EVIDENCE" |
| `writing-plans` | Spec → plan with 2–5 minute tasks, exact file paths, complete code, verification | No |
| `writing-skills` | Meta-skill: TDD applied to skill authoring via subagent pressure testing | No |
| `design-brainstorming` | Stage 1b UX spec authoring with hard gate | Hard gate |
| `design-driven-development` | Experience Discipline 6b.1: artifact-as-source-of-truth via DRAW-BUILD-RECONCILE | "NO USER-FACING SURFACE WITHOUT AN APPROVED DESIGN ARTIFACT FIRST" |
| `accessibility-verification` | Experience Discipline 6b.2: evidence before a11y claims | "NO COMPLETION CLAIMS ON A USER-FACING SURFACE WITHOUT FRESH ACCESSIBILITY EVIDENCE" |
| `design-interrogation` | Stage 2b 100-question pressure test of the UX spec (conditional) | No |
| `requesting-design-review` | Dispatch `design-reviewer` subagent (parallel with code review) | No |
| `receiving-design-review` | Technical handling of design-review feedback | No |
| `ux-heuristic-evaluation` | Checklist skill: Nielsen + state completeness + a11y heuristics | No |
| `design-system-integration` | Map UX spec surfaces to existing design system primitives | No |

## Standard skill body shape

- Overview / core principle
- Iron law (if applicable) in a code block for emphasis
- When to use (decision diagram in DOT)
- Process flow (DOT diagram)
- Checklist / numbered steps
- Anti-patterns
- Red Flags table (rationalizations → reality checks)
- Cross-references to successor skills

See `reference/skill-file-format.md` for the frontmatter and file rules.
See `principles/iron-laws.md` for the consolidated iron laws across the library.
See `principles/behavior-shaping.md` for the Red Flags pattern.
