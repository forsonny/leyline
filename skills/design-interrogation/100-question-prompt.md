# Design-interrogation 100-question prompt template

Use this template as the full prompt for a fresh subagent dispatched at step 1 of `design-interrogation`. The subagent has no inherited context; the constructed prompt below is everything it sees.

If the current harness does not support subagent dispatch, the agent runs the same process inline.

> **Sync:** the dimension list in this prompt must stay synchronized with the "Focus areas" section of `SKILL.md`. Any change here requires a matching change there.

## Prompt template

```
You are running a 100-question design-interrogation on a UX spec. Your job is adversarial pressure-testing of the experience design, not proposal rewriting. Read the UX spec carefully once, and skim the product spec for context. Then ask yourself 100 questions in sequence. Each question builds on the answer to the previous question.

Across the 100 questions, cover (at minimum) these UX-specific dimensions. Do not visit them in order; let the chain of answers decide which dimension the next question probes.

- State completeness - every row in the state matrix is reachable from some flow; every cell is either a concrete description or a justified "N/A - <reason>"; every surface listed in the Surfaces enumeration appears in the matrix.
- Flow failure paths - every flow names at least one failure path; error recovery is designed, not just signalled; permission-denied and offline are treated as first-class; partial-success (retry, resume) is handled.
- Accessibility target realism - can the declared WCAG level be met on the stack the product spec names? Is the keyboard flow implementable with the component library? Is screen-reader narration specified at the right granularity? Is the contrast / color-independence / reduced-motion strategy concrete?
- Voice consistency - the three reference strings set the tone. Take sample copy across surfaces and test whether the tone holds. Surprising shifts are findings.
- Platform conventions - does the spec honor platform idioms where users will expect them (iOS HIG, Material, Fluent, native-terminal conventions, browser affordances)? Unexamined deviations are findings.
- Accessibility tree correctness (predicted) - given the spec, what roles, labels, and relationships will the implementation expose? Flag structures the spec implies that would be inaccessible.
- Cross-surface state leakage - is state scoped correctly between surfaces? Filters, selections, errors, loading - do they persist when they should, reset when they should?
- Motion and color independence - does information survive reduced-motion? Color-blindness? Text-only rendering?
- Copy density and scannability - is there too much text per state? Too little in the empty state? Is error copy blame-free? Are CTAs verbed?
- Information architecture coherence (multi-screen / cross-platform) - does navigation match user mental models? Are routes / screen transitions predictable? Does deep-linking survive reload?
- Per-platform divergence discipline (cross-platform) - where the spec says the experience diverges, is the divergence justified? Where it says the experience must stay consistent, can that constraint actually be met?
- Internationalization and text expansion - does the design survive RTL layouts, pluralization rules, and string expansion beyond the English baseline (German/Finnish can be 30%+ longer; CJK often shorter but with different wrap behavior)?
- Perceived latency and loading budgets - when is a skeleton warranted vs. a spinner vs. optimistic UI vs. confirm-then-proceed? Are the budgets realistic against the backend the product spec names?

Rules:

- Each question must build on the previous answer. Do not reset. If an answer opens a larger problem, the next N questions follow that thread until exhausted.
- Do not propose a rewrite. Your output is the three-section report defined below. The UX spec's authors own the rewrite decision.
- Do not soften findings because the spec looks polished. A polished spec generates critical questions about states no one imagined.
- **Coherence anchors.** Every 25 questions (Q25, Q50, Q75), write a one-sentence summary of where the chain currently is. These are not findings; they are coherence anchors that prevent drift at 100 questions.
- **Q50 pivot.** If you reach question 50 and have not pressured a state-matrix cell or a failure path, stop and pressure one. A chain that stayed on the happy path rationalized.
- **Q75 pivot.** If you reach question 75 and have not pressured voice, platform conventions, or accessibility realism, pivot now. A chain that stayed on states and flows rationalized the softer dimensions.

The UX spec is at: <ABSOLUTE_PATH_TO_UX_SPEC>
The product spec is at: <ABSOLUTE_PATH_TO_PRODUCT_SPEC>

Read the UX spec fully before beginning. Confirm Surfaces is not `none`; if it is, the UX spec should not exist and you should stop and surface the error.

When the 100 questions are complete, produce the report in exactly this format:

Questions asked: <N - must be 100 unless you explicitly documented a Q50 or Q75 pivot outcome that terminates the chain; even then justify briefly under Pass audit>
Dimensions probed: <comma-separated list of the dimensions the chain actually visited>
Chain anchors:
  Q25: <one-sentence summary>
  Q50: <one-sentence summary>
  Q75: <one-sentence summary>

## Critical UX Issues
- <finding>: <surface / section / line reference> - <why it matters, one or two sentences>

## UX Strengths
- <what the UX spec got right>: <reference> - <one sentence>

## Revised UX Proposal
<A short proposal - NOT a rewrite - naming the changes the UX spec should adopt to address the Critical UX Issues. Group by surface and section. Keep under 500 words.>

If a section has no entries, write "None." Do not skip.

Optional: a "Relevant paths audited:" list of absolute paths you read during the pass.
```

## Substitution

Replace `<ABSOLUTE_PATH_TO_UX_SPEC>` and `<ABSOLUTE_PATH_TO_PRODUCT_SPEC>` with the absolute paths.

## What the invoking agent does with the report

- Presents the full report to the human partner.
- Decides materiality (step 4 of `SKILL.md`): material findings loop back to `design-brainstorming`; non-material findings are appended or referenced.
- Advances to `using-git-worktrees` on a clean pass or documented skip.

## Related

- `SKILL.md` - the invoking skill
- `../deep-discovery/100-question-prompt.md` - sibling template for the product-spec pass
- `../../dev/principles/behavior-shaping.md` - subagent isolation rationale
