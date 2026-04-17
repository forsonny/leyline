# Experience Discipline

The Experience Discipline is the 6b overlay, parallel to Code Discipline (6a), that governs every user-facing surface touched during stage 5.

## Two skills, two iron laws

### `design-driven-development`

**Iron law:**
```
NO USER-FACING SURFACE WITHOUT AN APPROVED DESIGN ARTIFACT FIRST
```

**Cycle — DRAW-BUILD-RECONCILE** (UX analog of RED-GREEN-REFACTOR):
- **DRAW:** artifact exists and is current
- **BUILD:** implement minimal code instantiating the artifact (TDD runs in parallel under 6a.1)
- **RECONCILE:** side-by-side comparison; fix the divergence in whichever direction is correct, never silently drift

### `accessibility-verification`

**Iron law:**
```
NO COMPLETION CLAIMS ON A USER-FACING SURFACE WITHOUT FRESH ACCESSIBILITY EVIDENCE
```

**Gate:** IDENTIFY check → RUN fresh → READ output → VERIFY zero critical violations → claim.

## Why an overlay, not a stage

Experience quality is not a single event at the end of design. It governs every implementation step that touches a surface, the same way TDD governs every code step. Sequencing it as a stage would let "we finished the Experience stage" become a shortcut. As an overlay, it is never done; it is continuously applied.

## Relationship to Code Discipline

- Both run during Execute (stage 5)
- **Code Discipline** governs tests, debugging, and completion claims for *all* work
- **Experience Discipline** additionally governs surface-touching work
- Neither overrides the other; a UX task must satisfy both (tests AND artifact alignment AND a11y evidence)

## What triggers Experience Discipline

A task triggers the overlay if and only if its "Files:" block touches a user-facing surface:

- Frontend component files (`.tsx`, `.vue`, `.svelte`, native UI files)
- CLI command implementations that emit human-readable text
- Error-message constants and i18n strings
- Log-format functions when humans read logs
- API error-shape definitions (when `Surfaces: developer-facing`)
- Email / notification / push-notification templates
- Voice/tone strings
- Accessibility affordances (aria attributes, focus management, keyboard handlers)

If none of the files in the task touch such a surface, only Code Discipline applies.

See `reference/surface-types.md` for per-surface-type triggering rules.

## Rationalizations the overlay rebuts

| Thought | Reality |
|---------|---------|
| "We did Design (stage 1), we're done with UX" | Design produced the artifact. Implementation must honor it. |
| "The artifact is out of date, I'll use my memory" | Then update the artifact, don't use memory. |
| "I'll match the artifact later" | You won't. |
| "The artifact didn't say" | If it didn't say, it isn't designed; stop and design it. |
| "I followed accessibility best practices" | Evidence or it didn't happen. |
| "This surface is tiny, skip the gate" | Small surfaces fail worst because defaults leak through. |
| "The framework handles accessibility" | No framework handles all of it. Run the check. |
| "This is internal, doesn't need a11y" | Internal users also have disabilities. |

## The two anti-patterns the overlay specifically exists to prevent

### Silent artifact drift

Implementation diverges from the design artifact without updating the artifact. Over time, the artifact becomes fiction and the code becomes the only truth. `design-driven-development`'s RECONCILE step forces the divergence to be surfaced and resolved either by fixing code or by updating the artifact with re-approval.

### Design theater

Artifacts produced, checklists ticked, reviews rubber-stamped — but no observable behavior change in the shipped experience. `accessibility-verification`'s "fresh evidence in this message" clause prevents this: no artifact or claim without in-message proof.

## Related

- `stages/06-discipline.md` — full overlay writeup with both skills
- `stages/05-execute.md` — the stage the overlay governs
- `principles/iron-laws.md` — five iron laws (three code, two experience)
- `reference/surface-types.md` — what counts as a surface
- `reference/recommended-optional-tools.md`
