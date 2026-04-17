# Spec-document reviewer prompt template

Use this template when dispatching a fresh subagent to review the product spec at step 9 of the `brainstorming` skill. The reviewer's job is mechanical: catch placeholders, contradictions, and ambiguity that the author missed.

## When to dispatch

- After you finish writing the spec to `docs/leyline/specs/YYYY-MM-DD-<topic>-design.md`.
- Before presenting it to the human partner for the final approval (step 10).
- The reviewer is a fresh subagent with no inherited context; the constructed prompt below is the entire context the reviewer sees.

## Prompt template

```
You are reviewing a product spec for placeholders, contradictions, and ambiguity. You are not reviewing the soundness of the proposal - the author and the human partner own that decision. Your job is mechanical hygiene.

The spec is at: <ABSOLUTE_PATH_TO_SPEC>

Read the file. Then return a structured response with three sections:

1. PLACEHOLDERS - any literal "TODO", "TBD", "XXX", "<...>", or empty bullet points. List each by section name and line number.

2. CONTRADICTIONS - any place where two statements in the spec disagree (one section says the system supports X; another says it does not). List each pair by section name and line number with the conflicting text.

3. AMBIGUITY - any sentence whose meaning depends on a definition that does not appear in the spec, or any pronoun without a clear referent, or any unquantified claim ("fast", "small", "easy") where a specific value would be more useful. List each by section name and line number with the ambiguous text and a one-line suggestion.

If a section has no findings, write "None." Do not editorialize or rewrite the spec. Do not comment on the proposal's merits. Findings only.

Required field check: confirm the spec contains a `Surfaces:` field with one of {none, developer-facing, cli-only, single-screen-ui, multi-screen-ui, cross-platform}. Flag if missing.
```

## Substitution

Replace `<ABSOLUTE_PATH_TO_SPEC>` with the absolute path to the spec file.

## What to do with the reviewer's findings

- Apply each finding directly. Do not present them to the human partner; this is hygiene, not review.
- After applying, re-run the reviewer if the spec changed materially.
- Move on to step 10 (human partner review) only when the reviewer returns "None." across all three sections.

## Why a fresh subagent and not a re-read

The author of the spec has anchored on the proposal and is blind to its placeholders and contradictions. A fresh subagent with no context catches them. The cost of the dispatch is small; the cost of taking a flawed spec to the human partner is high.

## Related

- `SKILL.md` step 9 - where this prompt is dispatched
- `dev/principles/behavior-shaping.md` - why subagent isolation matters for review
