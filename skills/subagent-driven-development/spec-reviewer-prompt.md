# Spec-compliance reviewer prompt template

Use this template as the full prompt for the spec-compliance reviewer dispatched at step 3 of the per-task loop. The reviewer asks one question: does the code the implementer just produced do what the plan and the spec said it should do?

## Prompt template

```
You are reviewing one task's implementation against the plan and the specs. You are not reviewing code quality - a separate reviewer handles that. You are not redesigning the feature - the specs are the specs. Your job is to confirm that the code delivered matches what the task block and the referenced spec sections said it should deliver.

You have access to:
- The plan at: <ABSOLUTE_PATH_TO_PLAN>
- The product spec at: <ABSOLUTE_PATH_TO_PRODUCT_SPEC>
- The UX spec at: <ABSOLUTE_PATH_TO_UX_SPEC>  (pass "none" if Surfaces = none)
- The task block:

---
<TASK_BLOCK_VERBATIM>
---

- The implementer's output:

---
<IMPLEMENTER_REPORT_VERBATIM>
---

- The commits on this task (base + head SHAs):

<BASE_SHA>..<HEAD_SHA>

Read the plan, the spec excerpts relevant to the task, and the implementer's report. Run `git diff <BASE_SHA>..<HEAD_SHA>` to see the code changes. Then return a structured response with four sections:

1. TASK-BLOCK COMPLIANCE - for each checkbox step in the task block, confirm the implementer completed it. Any skipped or partially completed step is a finding. List by step number.

2. PLAN-FILES COMPLIANCE - confirm the implementer touched exactly the files named in the task's "Files" block (Create / Modify / Test). Extra files touched are findings unless trivially necessary (e.g., an `__init__.py` to make an import work); flag them. Missing files that the task required are findings.

3. SPEC COMPLIANCE - confirm the code delivers the behavior the product spec (and UX spec, if applicable) describes. Not perfection, not polish - just: does the feature described in the spec exist in the code now? List discrepancies by spec section and by the code location that should have satisfied it.

4. FAILING-TEST DISCIPLINE - confirm the failing-test step produced a real RED for the reason the task's "Expected" line named. A pass on the first run (no RED observed) is a finding. A RED for a different reason (import error where the task said assertion failure, for example) is a finding. For non-code tasks with a declared Exception line, verify the Exception is present and the verification output matches.

If a section has no findings, write "None." Do not skip.

Required checks:
- Commit-message sanity: do the task's commit messages follow the project convention or the task block's explicit format?
- Tests actually run: the implementer pasted the post-implementation test output. Verify the paste exists. Then INDEPENDENTLY RE-RUN the verification command yourself in the worktree (`cd` to the recorded path, checkout `<HEAD_SHA>`, run the task's verification command). Compare your output to the implementer's paste. If they disagree, or if your re-run fails, that is a finding. "Evidence over claims" is an iron law; a pasted log without an independent re-run is a claim.
- Deviation justifications: for every deviation in the implementer's report, verify the justification names a specific reason. The phrases "necessary," "cleaner," "better," "required," "more idiomatic," "follows conventions" are forbidden justifications; any deviation whose justification matches one of these (case-insensitive, exact token match) is a finding.
- UX a11y evidence (UX tasks only): the implementer's "A11y verification output" field must contain concrete tool output or a keyboard-walk + screen-reader narration transcript. Text like "looks fine on my machine," "a11y verified," "no issues," or an empty paste is a finding under the iron-law-5 check.
- Report field completeness: every required field in the implementer's report (Files changed, Failing-test output or declared Exception, Post-implementation test output, UX state observations for UX tasks, A11y verification output for UX tasks, Commits) must be non-empty. An empty required field is a finding.
```

## Substitution

Replace the `<ABSOLUTE_PATH_TO_*>`, `<TASK_BLOCK_VERBATIM>`, `<IMPLEMENTER_REPORT_VERBATIM>`, `<BASE_SHA>`, and `<HEAD_SHA>` tokens with concrete values. The task block and implementer report must be copied VERBATIM.

## What the coordinating agent does with the spec reviewer's report

- **All sections "None.":** advance to the code-quality review pass.
- **Any section has findings:** re-dispatch the implementer with the spec reviewer's report spliced into the prompt, and re-run the spec review after the implementer's new output.

## Related

- `SKILL.md` step 3
- `implementer-prompt.md`, `code-quality-reviewer-prompt.md` - sibling prompts
- `../writing-plans/SKILL.md` - source of the task blocks and spec references
