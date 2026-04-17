# Glossary

Alphabetical. Each entry includes cross-references to files where the term is expanded.

## Anti-pattern
A named behavior that skills actively rebut. Skills use a **Red Flags** table to enumerate the rationalizations an agent reaches for when tempted to shortcut the process. See `principles/behavior-shaping.md`.

## Behavior-shaping content
Prose written not as reference but as levers to change how an LLM agent acts under pressure. The core thesis of the plugin: documentation alone won't stop shortcut-taking; instructions must be tested against real agents and tuned until compliance holds. See `principles/behavior-shaping.md`.

## Brainstorming
The first pipeline stage. Skill that hard-gates any implementation action until a written spec exists and the human partner has approved it. See `stages/01-discovery.md`.

## Code-reviewer
A specialized subagent definition in `agents/code-reviewer.md`. Dispatched by `requesting-code-review` and by `subagent-driven-development`'s two-stage review. Categorizes findings as Critical / Important / Suggestions. See `stages/07-review.md`, `structure/agents.md`.

## Deep-discovery
Pipeline stage 2. Subjects the approved spec to a 100-question self-interrogation where each question builds on the previous answer. Returns critical issues, strengths, and a revised proposal. Material revisions loop back to brainstorming. See `stages/02-interrogate.md`.

## Discipline overlay
Shorthand for the three skills (test-driven-development, systematic-debugging, verification-before-completion) that govern every action during the Execute stage rather than being sequential stages themselves. See `stages/06-discipline.md`.

## Human partner
The deliberate term for the user who is collaborating with the agent. Load-bearing terminology — never "user," "human," or "client" inside skill text. See `principles/terminology.md`.

## Iron Law
A non-negotiable rule stated in skill text, usually in a code block for emphasis. Multiple skills have one. Examples: "NO PRODUCTION CODE WITHOUT A FAILING TEST FIRST," "NO FIXES WITHOUT ROOT CAUSE INVESTIGATION FIRST," "NO COMPLETION CLAIMS WITHOUT FRESH VERIFICATION EVIDENCE." See `principles/iron-laws.md`.

## Leyline
The plugin name used in generated docs in this folder. Replaces "Superpowers" branding.

## Meta-skill
A skill about how to write other skills. The one meta-skill is `writing-skills`, which maps RED-GREEN-REFACTOR onto prose and requires pressure testing new skills against subagents. See `principles/tdd-for-prose.md`.

## Pipeline
The fixed-order sequence of stages from the human partner's first message through a merged branch. Every skill names its successor so the flow is deterministic. See `../combined-workflow-prompt.md` section 4.

## Plan
Output of the `writing-plans` skill. A markdown document with tasks decomposed to 2–5 minute bite-sized steps, each with exact file paths, complete code, and verification. Saved to `docs/leyline/plans/YYYY-MM-DD-<feature-name>.md`. See `stages/04-plan.md`.

## Pressure test
A scenario run against a subagent to observe whether the agent complies with a skill's discipline or rationalizes away from it. The baseline is run without the skill (RED), then with the skill (GREEN). See `principles/tdd-for-prose.md`.

## Rationalization
A specific sentence pattern an agent uses to justify skipping a discipline. Skills document them in Red Flags tables and rebut them inline. Examples: "this is too simple," "just this once," "I already know this." See `principles/behavior-shaping.md`.

## Red Flags table
A two-column table ("Thought" / "Reality") listing rationalizations an agent would use and the reality check that blocks them. Standard section in most skills. See `principles/behavior-shaping.md`.

## Session-start hook
A hook registered in `hooks/hooks.json` that fires on session startup, clear, and compact. It prints the entry skill content so the harness injects it as system context. This is what makes skill-checking automatic. See `reference/session-start-hook.md`.

## Skill
A markdown file (`SKILL.md`) with YAML frontmatter (`name`, `description`) describing a technique, pattern, or reference the agent should apply automatically when the description matches the situation. See `reference/skill-file-format.md`.

## Spec
The output of brainstorming. A markdown design document saved to `docs/leyline/specs/YYYY-MM-DD-<topic>-design.md` and committed. Must be user-approved before any implementation skill runs. See `stages/01-discovery.md`.

## Subagent
A fresh agent instance dispatched by the main agent, given constructed context rather than inheriting the parent session. Central to `subagent-driven-development` and `dispatching-parallel-agents`. See `stages/05-execute.md`.

## Two-stage review
The review pattern inside `subagent-driven-development`: after each implementation task, a spec-compliance reviewer subagent runs first, then a code-quality reviewer subagent runs. Both must pass before the task is marked complete. See `stages/05-execute.md`, `stages/07-review.md`.

## Worktree
An isolated git workspace created on a new branch by `using-git-worktrees`. Directory selection order: `.worktrees/` → `worktrees/` → `CLAUDE.md` preference → ask user. See `stages/03-isolate.md`.

## Accessibility Verification
The second Experience Discipline iron law (#5): `NO COMPLETION CLAIMS ON A USER-FACING SURFACE WITHOUT FRESH ACCESSIBILITY EVIDENCE`. Home skill: `accessibility-verification`. Tool-agnostic; requires in-message evidence. See `principles/iron-laws.md`, `stages/06-discipline.md`.

## Co-skill
Two skills running at the same stage, each with its own approval gate, sharing the same successor. 1a/1b in Discovery (`brainstorming` + `design-brainstorming`); 2a/2b in Interrogate (`deep-discovery` + `design-interrogation`). See `principles/terminology.md`.

## Design (UX sense)
UI/UX/IA/visual/interaction design. The word "Design" is reserved for this across the plugin; stage 1 is called "Discovery," not "Design." See `principles/terminology.md`.

## Design-brainstorming
Stage 1b co-skill. Produces the UX spec after the product spec has been approved. Hard-gated: no surface implementation until the UX spec is approved. See `stages/01-discovery.md`.

## Design-Driven Development
The first Experience Discipline iron law (#4): `NO USER-FACING SURFACE WITHOUT AN APPROVED DESIGN ARTIFACT FIRST`. Home skill: `design-driven-development`. Cycle: DRAW-BUILD-RECONCILE. See `principles/iron-laws.md`, `stages/06-discipline.md`.

## Design-interrogation
Stage 2b co-skill. 100-question pressure test of the UX spec, invoked conditionally by agent scope judgment. Required for `multi-screen-ui` / `cross-platform` / complex state matrices. Skip must be documented in the spec. See `stages/02-interrogate.md`.

## design-reviewer
Specialized subagent defined in `agents/design-reviewer.md`. Reviews artifact alignment, flow correctness, state completeness, accessibility, voice/tone. Harness-aware: uses available MCPs and tools when present, falls back to structural review otherwise. See `structure/agents.md`, `stages/07-review.md`.

## Discovery (stage 1)
The renamed stage 1. Runs two sequential co-skills: `brainstorming` (product spec) and `design-brainstorming` (UX spec). Both must be approved before stage 2. See `stages/01-discovery.md`.

## DRAW-BUILD-RECONCILE
The UX analog of RED-GREEN-REFACTOR used by `design-driven-development`. DRAW: artifact exists and is current. BUILD: implement minimal code instantiating the artifact. RECONCILE: side-by-side check; fix implementation or update artifact and re-get approval. No silent drift. See `principles/experience-discipline.md`.

## Experience (overlay)
The 6b overlay governing every surface-touching task during Execute. Parallel to Code Discipline (6a). Contains `design-driven-development` and `accessibility-verification`. See `principles/experience-discipline.md`.

## Experience Discipline
The 6b overlay applied during Execute, holding the two new iron laws. See `Experience (overlay)`.

## Experience gate
Implementation-time enforcement of Iron Law #4. Before dispatching the implementer for any task touching a user-facing surface, verify the design artifact exists and is current. If not, stop; return to `design-brainstorming`. See `stages/05-execute.md`, `principles/iron-laws.md`.

## Surface / user-facing surface
Any output a human perceives: screens, views, modals, toasts, error messages, empty/loading/error/success states, CLI text, command output formatting, log formatting when humans read logs, email templates, accessibility affordances. What triggers Experience Discipline. See `reference/surface-types.md`.

## Surfaces (spec field)
Required field in the product spec. Values: `none | developer-facing | cli-only | single-screen-ui | multi-screen-ui | cross-platform`. Default `multi-screen-ui`. Declared by the human partner, never inferred. Drives whether `design-brainstorming` runs and which template it uses. See `reference/surface-types.md`.

## UX artifact
Any markdown artifact produced by `design-brainstorming` — UX spec, state matrix, a11y audit. Not a mockup or wireframe. See `principles/terminology.md`.

## UX spec
The output of `design-brainstorming`. A markdown document at `docs/leyline/design/YYYY-MM-DD-<topic>-ux.md`. Mandatory sections: surfaces, flows, state matrix, IA (multi-screen only), voice & tone, a11y targets, platform constraints, non-goals. See `stages/01-discovery.md`.
