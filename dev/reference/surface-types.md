# Surface types reference

The `Surfaces` field in the product spec determines the shape of `design-brainstorming` (stage 1b) and whether `design-interrogation` (stage 2b) runs.

## The field

Declared in the product spec (output of stage 1a):

```
Surfaces: [none | developer-facing | cli-only | single-screen-ui | multi-screen-ui | cross-platform]
```

## Declaration rules

- **Explicit, human-declared, committed to the spec.** Never inferred by the agent.
- **Default:** `multi-screen-ui`. Any lower tier requires active justification in the spec.
- Any choice other than the default must explain why.

## Per-type templates for `design-brainstorming`

### `none`

Rare escape hatch. Truly no output of any kind — pure internal functions, unpublished libraries with zero public API, migrations that emit nothing.

- **Template:** design-brainstorming skipped.
- **Justification required:** human partner must actively justify.
- **Most libraries are NOT `none`** — they are `developer-facing`.
- **design-interrogation (2b):** skipped.

### `developer-facing`

Library API, SDK, error shapes, log structure, CLI exit codes, telemetry labels — UX for developers.

- **Reduced template:**
  1. Public API surface enumeration
  2. Error shapes and failure-mode contracts
  3. Log/output schema
  4. Exit-code semantics
  5. Telemetry-label conventions
  6. Documented failure modes
  7. Voice & tone in error messages (three example strings)
  8. Non-goals
- **design-interrogation (2b):** optional if the API is complex with non-trivial error paths; otherwise skipped.

### `cli-only`

Human-facing CLI text (commands, help output, error messages, progress indicators).

- **Reduced template:**
  1. Commands enumerated
  2. Help/usage text (voice, completeness)
  3. Error and progress output formatting
  4. Voice & tone (three example strings)
  5. Output accessibility (color independence, screen-reader-friendly, terminal width)
  6. Exit codes and their meanings
  7. Non-goals
- **design-interrogation (2b):** optional if multi-stage interactions or complex error paths; otherwise skipped.

### `single-screen-ui`

A single view, modal, or embedded widget.

- **Full template:**
  1. Surface enumerated
  2. User flows (including failure paths)
  3. State matrix (empty, loading, error, success, permission-denied, offline)
  4. Voice & tone (three example strings)
  5. Accessibility targets (WCAG level, keyboard flow, screen-reader narration)
  6. Platform/harness constraints
  7. Non-goals
- **design-interrogation (2b):** required if the state matrix is non-trivial; otherwise optional.

### `multi-screen-ui`

Multiple views with navigation between them.

- **Full template (adds to single-screen):**
  - All single-screen sections
  - Information architecture (sitemap, navigation hierarchy)
  - Cross-screen state handling
  - Route/URL conventions (web) or screen-transition conventions (native)
- **design-interrogation (2b):** **required.**

### `cross-platform`

Same experience across multiple platforms (web + mobile, desktop + web, etc.).

- **Full template (adds to multi-screen):**
  - All multi-screen sections
  - Per-platform adaptation (where the experience diverges intentionally; where it must stay consistent)
  - Platform-conventions compliance targets (iOS HIG, Material, Fluent, native terminal, etc.)
- **design-interrogation (2b):** **required.**

## Trigger summary

| Surface type | design-brainstorming (1b) | design-interrogation (2b) | Experience Discipline (6b) |
|--------------|---------------------------|---------------------------|----------------------------|
| `none` | skipped | skipped | N/A |
| `developer-facing` | reduced template | optional | when touching surfaces |
| `cli-only` | reduced template | optional | when touching surfaces |
| `single-screen-ui` | full template | optional (matrix complexity) | when touching surfaces |
| `multi-screen-ui` | full template | **required** | when touching surfaces |
| `cross-platform` | full template | **required** | when touching surfaces |

## Related

- `stages/01-discovery.md` — where `Surfaces` is declared
- `stages/02-interrogate.md` — where 2b invocation depends on this field
- `stages/06-discipline.md` — Experience Discipline overlay
- `principles/experience-discipline.md`
