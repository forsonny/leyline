# Design-interrogation report template

Use this blank template when running the 100-question pass inline (no subagent dispatch available) or when recording the pass for the record. The authoring agent fills each section as the chain produces findings.

## Template

```
# Design-interrogation report

UX spec: <path to UX spec, including the date prefix>
Product spec: <path to product spec>
Date: YYYY-MM-DD
Mode: <subagent | inline>
Questions asked: <N - must be 100 unless a Q50 or Q75 pivot outcome justified earlier termination>
Dimensions probed: <comma-separated list>
Chain anchors:
  Q25: <one-sentence summary>
  Q50: <one-sentence summary>
  Q75: <one-sentence summary>

## Critical UX Issues
- <finding 1>: <surface / section / line reference> - <why it matters>
- <finding 2>: <reference> - <why it matters>
- ...

## UX Strengths
- <what the UX spec got right>: <reference> - <one sentence>
- ...

## Revised UX Proposal

<A short proposal that names the changes the UX spec should adopt to address the Critical UX Issues. Group by surface and section. Keep under 500 words. Do not include findings that are cosmetic.>

## Pass audit (required for inline runs)

- Chain high points: <brief notes on the threads the chain pursued>
- Deviations from the prompt (if any): <explain early termination, skipped dimensions, etc.>
- Transcript path: <path to the saved Q&A transcript; required for inline runs>
```

## Rules for filling the template

- If a section has no entries, write "None." Do not skip the section.
- Keep the "Revised UX Proposal" section under 500 words. It is a pointer set, not a rewrite; the rewrite belongs in `design-brainstorming` after the loop-back.
- The "Pass audit" block is required for inline runs. Dispatched subagents need only fill the top-matter (Questions asked, Dimensions probed, Chain anchors).

## Where to save

- Round files: `docs/leyline/design/YYYY-MM-DD-<topic>-design-interrogation-round-<N>.md`. Reference them from the UX spec.
- Non-material findings can be summarized inline in a "Design-interrogation notes" section of the UX spec, but the full report still gets its own file for audit.
- **For inline runs, also save the full question-and-answer transcript alongside the report at `docs/leyline/design/YYYY-MM-DD-<topic>-design-interrogation-round-<N>-transcript.md`.** Inline runs have no other audit trail; without the transcript, a reviewer cannot verify that 100 chained questions actually occurred. Write each question and answer as the chain progresses; do not reconstruct after the fact.

## Related

- `SKILL.md` - the invoking skill
- `100-question-prompt.md` - the prompt template the subagent uses, or the inline runner follows
- `../deep-discovery/report-template.md` - sibling template for the product-spec pass
