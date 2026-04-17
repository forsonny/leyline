# UX-spec reviewer prompt template

Use this template when dispatching a fresh subagent to review the UX spec at step 12 of the `design-brainstorming` skill. The reviewer's job is mechanical: catch placeholders, contradictions, ambiguity, AND the UX-specific completeness gaps that the product-spec reviewer does not look for.

## When to dispatch

- After you finish writing the UX spec to `docs/leyline/design/YYYY-MM-DD-<topic>-ux.md`.
- Before presenting it to the human partner for approval (step 13).
- The reviewer is a fresh subagent with no inherited context; the constructed prompt below is the entire context the reviewer sees.

## Prompt template

```
You are reviewing a UX spec for placeholders, contradictions, ambiguity, and three UX-specific completeness gaps. You are not reviewing the soundness of the proposed experience - the author and the human partner own that decision. Your job is mechanical hygiene plus three structured checks.

The UX spec is at: <ABSOLUTE_PATH_TO_UX_SPEC>
The product spec it is based on is at: <ABSOLUTE_PATH_TO_PRODUCT_SPEC>

Read both files. Then return a structured response with six sections:

1. PLACEHOLDERS - any literal "TODO", "TBD", "XXX", "<...>", or empty bullet points in the UX spec. List each by section name and line number.

2. CONTRADICTIONS - any place where two statements in the UX spec disagree, OR any place where the UX spec contradicts the product spec (different surface counts, different error handling, different state assumptions). List each pair by section name and line number with the conflicting text.

3. AMBIGUITY - any sentence whose meaning depends on a definition not given in the spec, or any pronoun without a clear referent, or any unquantified claim ("fast", "small", "subtle") where a specific value would be more useful. List each by section name and line number with the ambiguous text and a one-line suggestion.

4. STATE MATRIX COMPLETENESS - for every row in the state matrix, confirm all six columns (Empty, Loading, Error, Success, Permission-denied, Offline) are filled with either a concrete description or "N/A - <reason>". Any blank cell, any cell reading just "N/A" without a reason, and any surface missing from the matrix that appears in the Surfaces enumeration are findings. List by surface name and column.

5. VOICE EXAMPLES PRESENT - confirm three reference strings appear verbatim in the Voice and tone section: one error string, one success string, one empty-state string. Any missing category is a finding. If the strings are present but generic ("An error occurred." / "Success!"), flag them as insufficient.

6. FLOWS INCLUDE FAILURE PATHS - for every user flow in the User flows section, confirm the flow names at least one failure path (network error, invalid input, permission missing, timeout, or equivalent). Flows without a documented failure path are a finding.

If a section has no findings, write "None." Do not editorialize or rewrite the spec. Do not comment on the proposal's merits. Findings only.

Required field check: confirm the UX spec contains a `Surfaces:` field matching the value in the product spec, and a `Product spec:` cross-reference pointing to the product-spec path. Flag if either is missing.
```

## Substitution

Replace `<ABSOLUTE_PATH_TO_UX_SPEC>` and `<ABSOLUTE_PATH_TO_PRODUCT_SPEC>` with the absolute paths.

## What to do with the reviewer's findings

- Apply each finding directly. Do not present them to the human partner; this is hygiene, not review.
- If the state-matrix, voice-examples, or failure-paths check returns findings, those gaps are the spec being incomplete, not just messy. Fix them before advancing.
- After applying, re-run the reviewer if the spec changed materially.
- Move on to step 13 (human partner review) only when the reviewer returns "None." across all six sections.

## Harness fallback

If the current harness does not support subagent dispatch, the author performs the six checks manually by re-reading the UX spec section by section. Do not skip the checks on that basis; the mechanical work is what catches the drift.

## Why a fresh subagent and not a re-read

The author has anchored on the experience they imagined and is blind to the gaps. A fresh subagent with no context catches the blank matrix cell, the missing failure path, and the empty state that was never written. The cost of the dispatch is small; the cost of shipping an incomplete UX spec is large.

## Related

- `SKILL.md` step 12 - where this prompt is dispatched
- `../brainstorming/spec-document-reviewer-prompt.md` - sibling reviewer for the product spec
- `../../dev/principles/behavior-shaping.md` - why subagent isolation matters for review
