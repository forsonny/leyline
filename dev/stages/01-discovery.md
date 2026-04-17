# Stage 1 — Discovery

Stage 1 runs two sequential co-skills. Both must be approved by the human partner before the pipeline advances to stage 2.

**Co-skills:**
- **1a.** `brainstorming` — product/feature spec
- **1b.** `design-brainstorming` — UX spec (when surfaces present)

**Successor:** `deep-discovery` (stage 2a) always; `design-interrogation` (stage 2b) conditionally

**Output artifacts:**
- Product spec: `docs/leyline/specs/YYYY-MM-DD-<topic>-design.md`
- UX spec: `docs/leyline/design/YYYY-MM-DD-<topic>-ux.md` (when applicable)

---

## 1a. `brainstorming` — product spec

**Description line:** "You MUST use this before any creative work - creating features, building components, adding functionality, or modifying behavior. Explores user intent, requirements and design before implementation."

### Hard gate

> Do NOT invoke any implementation skill, write any code, scaffold any project, or take any implementation action until you have presented a design and the user has approved it. This applies to EVERY project regardless of perceived simplicity.

### Core process (checklist)

1. Explore project context — files, docs, recent commits
2. Offer visual companion (if visual questions expected) — own message, not combined with a clarifying question
3. Ask clarifying questions — one at a time, focused on purpose/constraints/success criteria
4. Scope check — decompose if multiple independent subsystems
5. Propose 2–3 approaches with trade-offs and a recommendation
6. **Surface scan** (new checkpoint)
7. Present design in sections scaled to complexity, get explicit approval per section
8. Write design doc and commit
9. Spec self-review — fix placeholders, contradictions, ambiguity inline
10. Human partner reviews the written spec
11. Transition — if surfaces present, invoke `design-brainstorming` (1b); otherwise proceed to stage 2

### 6. Surface scan

Before writing the design doc, the agent asks: does any proposed approach involve a user-facing surface?

- **If yes:** `design-brainstorming` is a mandatory co-skill for this session. Announce and invoke it before writing the combined spec.
- **If no:** Document `Surfaces: none` explicitly in the spec. `none` requires active justification — most "no UI" projects are actually `developer-facing` (library APIs, error shapes, log structure, exit codes).

### Required spec field: `Surfaces`

```
Surfaces: [none | developer-facing | cli-only | single-screen-ui | multi-screen-ui | cross-platform]
```

Default: `multi-screen-ui`. See `reference/surface-types.md` for full definitions.

### Exit condition (1a)

Human partner approves the product spec. This approval is a precondition for 1b.

---

## 1b. `design-brainstorming` — UX spec

**Description line:** "Use when the spec touches any user-facing surface, before committing the spec. Explores interaction flows, information architecture, states (empty/loading/error/success), accessibility targets, and voice — alongside the product spec."

**Precondition:** Product spec from 1a approved. `design-brainstorming` takes that approved spec as input.

### Hard gate

> Do NOT invoke any implementation skill on any user-facing surface until the UX spec has been presented and the human partner has approved it. This applies to EVERY project that has a user-facing surface, regardless of perceived simplicity. A CLI has user-facing surfaces. A library has user-facing surfaces if it produces human-readable output.

### Output artifact

UX spec saved to `docs/leyline/design/YYYY-MM-DD-<topic>-ux.md`, committed.

### Mandatory sections (full template — single-screen/multi-screen/cross-platform)

1. Surfaces enumerated (every screen/view/output)
2. User flows (one per goal, including failure paths)
3. State matrix (row per surface; columns: empty, loading, error, success, permission-denied, offline)
4. Information architecture (multi-screen only)
5. Voice & tone (three example strings)
6. Accessibility targets (WCAG level, keyboard flow, screen-reader narration)
7. Platform/harness constraints
8. Non-goals

### Reduced templates

- `developer-facing` — API surface, error shapes, log schema, exit-code semantics, telemetry labels, error voice
- `cli-only` — commands, help/usage, error/progress formatting, voice, output accessibility

Full per-type definitions in `reference/surface-types.md`.

### Anti-patterns

- **"This Is Just A CLI, No UX Needed"** — CLI output is UX. Voice, error clarity, output formatting, non-zero exit handling are UX decisions.
- **"The Product Spec Already Covers UX"** — Product spec says *what*; UX spec says *how it is experienced*. Different artifact.
- **"I'll Design As I Code"** — You won't. You'll ship the first thing that works.
- **"This Surface Is Too Small To Design"** — Small surfaces fail worst because defaults leak through.

### Red flags

| Thought | Reality |
|---------|---------|
| "It's obvious what the UI should be" | Then writing it down takes 90 seconds. Do it. |
| "We'll iterate once we see it" | You won't iterate on the empty state. |
| "Accessibility can come later" | Accessibility is how it is built, not a polish pass. |
| "Mobile/CLI/embedded doesn't need UX" | Every surface with a human on the other end is UX. |
| "The user didn't ask about states" | Users don't know to ask. You do. |

### Exit condition (1b)

Human partner approves the UX spec. Both specs are now the source of truth for stages 2+.

---

## Supporting files in `skills/brainstorming/`

- `SKILL.md`
- `spec-document-reviewer-prompt.md`
- `visual-companion.md`
- `scripts/`

## Related

- `stages/02-interrogate.md` — 2a (`deep-discovery`) and 2b (`design-interrogation`)
- `stages/04-plan.md` — writing-plans consumes both specs
- `reference/surface-types.md`
- `principles/iron-laws.md` — hard gates for Discovery
- `principles/behavior-shaping.md`
- `principles/experience-discipline.md`
