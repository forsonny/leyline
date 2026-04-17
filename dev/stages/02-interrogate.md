# Stage 2 — Interrogate

Stage 2 runs two co-skills. 2a always runs; 2b runs conditionally per agent scope judgment.

**Co-skills:**
- **2a.** `deep-discovery` — pressure-test the product spec (always)
- **2b.** `design-interrogation` — pressure-test the UX spec (conditional)

**Successor:** `using-git-worktrees` (stage 3) on clean interrogation; loop back to the relevant Discovery co-skill if material revisions surface.

---

## 2a. `deep-discovery` — product spec pressure test

**Description line:** "Use this agent to run the 100-question deep discovery process on any topic, architecture, strategy, or problem space. Dispatched as a subagent to perform an exhaustive self-interrogation — 100 questions where each builds on the previous answer. Returns critical issues, strengths, and a revised proposal."

**Input artifact:** User-approved product spec from 1a.
**Output artifact:** Structured report (critical issues, strengths, revised proposal).

### The 100-question pass

- Exhaustive self-interrogation
- Each question builds on the previous answer
- Covers: assumptions, failure modes, missing requirements, dependencies, constraints, alternatives, edge cases, scale boundaries, rollback paths, testing strategy, observability, security, operational concerns, team/ownership, timelines, success criteria, known-unknowns
- Output sections: **Critical Issues**, **Strengths**, **Revised Proposal**

### Exit conditions (2a)

- Pass complete
- Critical issues documented
- Either:
  - (a) No material revisions → continue to 2b (if applicable) or to stage 3
  - (b) Material revisions → loop back to 1a (brainstorming) for spec update and re-approval

---

## 2b. `design-interrogation` — UX spec pressure test

**Description line:** "Use at stage 2 after the UX spec has been approved, when the project scope warrants dedicated pressure-testing of the experience. Mirrors deep-discovery's 100-question pass, targeted at interaction flows, state completeness, accessibility targets, voice coherence, and platform appropriateness."

**Input artifact:** User-approved UX spec from 1b.
**Output artifact:** Structured report (critical UX issues, UX strengths, revised UX proposal).

### When to invoke (agent judgment)

- **Required:** `Surfaces: multi-screen-ui` or `cross-platform`; any UX spec with a state matrix covering more than one surface
- **Optional:** complex `cli-only` or `developer-facing` with non-trivial error paths or multi-stage interactions
- **Skipped:** simple `cli-only` with straightforward output; simple `developer-facing` with a narrow API; `Surfaces: none`

### Skip discipline

If the agent judges 2b unnecessary, the agent must document that judgment explicitly in the spec: `design-interrogation skipped — scope: <reason>`. No silent skipping.

### Interrogation focus areas

- State completeness (every row in the matrix reachable and exhaustively designed)
- Flow failure paths (error recovery, permission-denied, offline, partial-success)
- Accessibility target realism (can the spec actually be met on the chosen stack?)
- Voice consistency across surfaces
- Platform conventions (does the spec honor platform idioms where the user expects them?)
- Accessibility tree correctness predicted at the spec level
- Cross-surface state leakage (is state scoped correctly between surfaces?)

### Exit conditions (2b)

- Pass complete (or documented skip)
- Critical UX issues documented
- Either:
  - (a) No material revisions → continue to stage 3
  - (b) Material UX revisions → loop back to 1b (design-brainstorming) for UX spec update and re-approval

---

## Related

- `stages/01-discovery.md` — input specs come from here
- `stages/03-isolate.md` — successor when both passes clear
- `reference/surface-types.md` — determines whether 2b is required, optional, or skipped
- `principles/iron-laws.md` — interrogation is the gate at the design/implementation boundary
- `principles/experience-discipline.md`
