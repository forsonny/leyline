# 100-question interrogation prompt template

Use this template as the full prompt for a fresh subagent dispatched at step 1 of `deep-discovery`. The subagent has no inherited context; the constructed prompt below is everything it sees.

If the current harness does not support subagent dispatch, the agent runs the same process inline in the current session, following the same rules.

> **Sync:** the dimension list in this prompt must stay synchronized with the "The 100-question pass (invariants)" section of `SKILL.md`. Any change here requires a matching change there.

## Prompt template

```
You are running a 100-question deep-discovery interrogation on a product spec. Your job is adversarial pressure-testing, not proposal rewriting. Read the spec carefully once. Then ask yourself 100 questions in sequence. Each question must build on the answer to the previous question; you are following chains of reasoning, not iterating a static checklist.

Across the 100 questions, cover (at minimum) these dimensions. Do not visit them in order; let the chain of answers decide which dimension the next question probes.

- Assumptions - what is taken for granted? what would break the proposal if it were wrong?
- Failure modes - what breaks, and with what blast radius? what is the worst plausible outcome?
- Missing requirements - what is implied but not stated? what would a reader misinterpret?
- Dependencies - internal and external; what are the version, availability, and ownership risks?
- Constraints - technical, organizational, regulatory, timeline; are any unnamed?
- Alternatives rejected - are the rejections sound? would the rejected approach survive a fresh look?
- Edge cases - input extremes, empty states, concurrency, partial success, retries
- Scale boundaries - at what volume of users / data / requests does the design break?
- Rollback paths - how do we undo this if it ships and hurts?
- Testing strategy - how do we know it works before shipping?
- Observability - how do we know it works in production? what alerts would fire on failure?
- Security - threat model, secrets, authn/authz, data exposure, compliance
- Operational concerns - runbooks, on-call, deploys, feature flags, migrations
- Team / ownership - who maintains this? who is paged when it breaks?
- Timelines - is the schedule realistic given dependencies and unknowns?
- Cost and unit economics at target scale - does the design break the budget as it scales?
- Migration / backfill path for stateful features - how does existing data move onto the new model? what does rollback of a partially-migrated state look like?
- Success criteria - observable, measurable, tied to an outcome the human partner can verify
- Known-unknowns - what do we know we do not know? what investigation is required before decisions are defensible?

Rules:

- Each question must build on the previous answer. Do not reset. If an answer opens a larger problem, the next N questions follow that thread until exhausted.
- Soft questions are on the table. "Is this worth doing?" is a valid question.
- Do not propose a rewrite. Your output is the three-section report defined below. The spec's authors own the rewrite decision.
- Do not soften findings because the spec looks solid. A solid spec still generates critical questions; if it genuinely has none, your report will say "None." for Critical Issues.
- **Coherence anchors.** Every 25 questions (Q25, Q50, Q75), write a one-sentence summary of where the chain currently is. These are not findings; they are coherence anchors that prevent drift at 100 questions.
- **Q50 pivot.** If you reach question 50 and have not challenged a stated assumption yet, stop and challenge one. A chain that never pushes back is a chain that rationalized.
- **Q75 pivot.** If you reach question 75 and have not probed rollback, operational concerns, or security, pivot now. Chains that stayed on product strategy rationalized.

The spec is at: <ABSOLUTE_PATH_TO_SPEC>

Companion paths worth auditing for context (optional): `README.md`, `CHANGELOG.md`, and any existing code referenced by the spec. Record paths you actually read in the "Relevant paths audited" tail of your report.

Read the spec fully before beginning. Confirm the `Surfaces:` field is declared and record its value. `Surfaces` affects which dimensions carry weight:
- `none`: security, observability, and operational dimensions probe internal integrity, not user-facing exposure.
- `developer-facing`: API surface, error-shape stability, versioning, and deprecation become first-class.
- `cli-only`: exit-code semantics, output-parseability, and error visibility on terminals carry extra weight.
- `single-screen-ui` / `multi-screen-ui` / `cross-platform`: full breadth; UI-bearing surfaces amplify observability (client-side errors), security (XSS/CSRF), and operational (client rollout) dimensions.

For exact per-tier implications, see `../../dev/reference/surface-types.md`.

When the 100 questions are complete, produce the report in exactly this format:

Questions asked: <N - must be 100 unless you explicitly documented a Q50 or Q75 pivot outcome that terminates the chain; even then justify briefly under Pass audit>
Dimensions probed: <comma-separated list of the dimensions the chain actually visited>
Chain anchors:
  Q25: <one-sentence summary>
  Q50: <one-sentence summary>
  Q75: <one-sentence summary>

## Critical Issues
- <finding>: <section-and-line reference in the spec> - <why it matters, one or two sentences>

## Strengths
- <what the spec got right, worth preserving>: <reference> - <one sentence>

## Revised Proposal
<A short proposal - NOT a rewrite - naming the changes the spec should adopt to address the Critical Issues. Group by file and section. Keep under 500 words. Do not include findings that are cosmetic.>

If a section has no entries, write "None." Do not skip a section.

Optional: a "Relevant paths audited:" list of absolute paths you read during the pass. This is audit-trail data; the human partner does not need to read it, but it helps later reviewers.
```

## Substitution

Replace `<ABSOLUTE_PATH_TO_SPEC>` with the absolute path to the approved product spec (`docs/leyline/specs/YYYY-MM-DD-<topic>-design.md`).

## What the invoking agent does with the report

- Presents the full report to the human partner (step 3 of `deep-discovery`).
- Decides materiality (step 4): material findings loop back to `brainstorming`; non-material findings are appended to or referenced by the spec.
- Advances to `design-interrogation` (2b) or `using-git-worktrees` (3) per the transition rules in `SKILL.md`.

## Related

- `SKILL.md` - the invoking skill
- `report-template.md` - blank report for inline runs
- `../design-interrogation/100-question-prompt.md` - sibling template for UX-spec pressure testing
- `../../dev/principles/behavior-shaping.md` - why subagent isolation matters for interrogation
