# Deep-discovery report template

Use this blank template when running the 100-question pass inline (no subagent dispatch available) or when recording the pass for the record. The authoring agent fills each section as the chain produces findings.

## Template

```
# Deep-discovery report

Spec: <path to product spec, including the date prefix>
Date: YYYY-MM-DD
Mode: <subagent | inline>
Questions asked: <N - must be 100 unless a Q50 or Q75 pivot outcome justified earlier termination>
Dimensions probed: <comma-separated list>
Chain anchors:
  Q25: <one-sentence summary>
  Q50: <one-sentence summary>
  Q75: <one-sentence summary>

## Critical Issues
- <finding 1>: <section / line reference> - <why it matters>
- <finding 2>: <reference> - <why it matters>
- ...

## Strengths
- <what the spec got right>: <reference> - <one sentence>
- ...

## Revised Proposal

<A short proposal that names the changes the spec should adopt to address the Critical Issues. Group by file and section. Keep under 500 words. Do not include findings that are cosmetic.>

## Pass audit (required for inline runs)

- Chain high points: <brief notes on the threads the chain pursued; useful for later reviewers>
- Deviations from the prompt (if any): <explain early termination, skipped dimensions, etc.>
- Transcript path: <path to the saved Q&A transcript; required for inline runs>
```

## Rules for filling the template

- If a section has no entries, write "None." Do not skip the section.
- Keep the "Revised Proposal" section under 500 words. It is a pointer set, not a rewrite; the rewrite belongs in `brainstorming` after the loop-back.
- The "Pass audit" block is optional and only relevant to inline runs; dispatched subagents do not need to fill it.

## Where to save

- If the findings are material and loop back to `brainstorming`, save the report under `docs/leyline/specs/YYYY-MM-DD-<topic>-deep-discovery-round-<N>.md` and reference it from the updated spec.
- If the findings are non-material, append a short "Deep-discovery notes" section to the spec itself with the report inline or a path reference.
- **For inline runs, also save the full question-and-answer transcript alongside the report at `docs/leyline/specs/YYYY-MM-DD-<topic>-deep-discovery-round-<N>-transcript.md`.** Inline runs have no other audit trail; without the transcript, a reviewer cannot verify that 100 chained questions actually occurred. Write each question and answer to the transcript in order as the chain progresses; do not reconstruct after the fact.

## Related

- `SKILL.md` - the invoking skill
- `100-question-prompt.md` - the prompt the subagent uses, or the inline runner follows
