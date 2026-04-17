# Plan-reviewer prompt template

Use this template when dispatching a fresh subagent to review the implementation plan at step 7 of `writing-plans`. The reviewer's job is mechanical: catch tasks that are too large, tasks without exact paths, tasks with outlines instead of code, missing failing-test steps, missing UX task blocks, and assumptions the executor cannot resolve.

## When to dispatch

- After you finish writing the plan but before presenting it to the human partner.
- The reviewer is a fresh subagent with no inherited context; the constructed prompt below is the entire context the reviewer sees.

## Prompt template

```
You are reviewing an implementation plan for executor-readiness. You are not reviewing the soundness of the design - the authoring agent and the human partner own that decision. Your job is mechanical hygiene: does the plan produce correct behavior in the hands of an enthusiastic junior engineer with poor taste, no judgement, no project context, and an aversion to testing?

The plan is at: <ABSOLUTE_PATH_TO_PLAN>
The product spec is at: <ABSOLUTE_PATH_TO_PRODUCT_SPEC>
The UX spec is at: <ABSOLUTE_PATH_TO_UX_SPEC>  (pass "none" if Surfaces = none)
The baseline note is at: <ABSOLUTE_PATH_TO_BASELINE>

Read all referenced files. Then return a structured response with seven sections:

1. TASK GRANULARITY - any task that is larger than 5 minutes of executor work, or that bundles more than one responsibility, is a finding. List each by task number and a one-sentence reason.

2. EXACT PATHS - any task whose "Files" block uses partial paths, wildcards, "somewhere in X", or relative references that would be ambiguous to a fresh executor is a finding. Additionally, for every `Modify:` path, verify that the file exists at HEAD (`git cat-file -e HEAD:<path>`); for every `Create:` path, verify the parent directory exists (`test -d <parent>`) or is itself marked for creation elsewhere in the plan. Non-existent `Modify:` paths and orphan `Create:` paths are findings. List each by task number with the offending line.

3. COMPLETE CODE - any task step that uses an outline instead of complete code is a finding. Outlines are not plans. Flag any of: literal `...`, `# TODO`, `# FIXME`, `# XXX`, `pass  # implement`, "implement X", "add handler", "wire up Y", "follow the pattern in <file>", "similar to <example>", "mirrors the <thing> shape", "as discussed", "you know what to do". List each by task number and step with the offending phrase.

4. FAILING-TEST DISCIPLINE - any code task that does not have a failing-test step (write test, run, observe failure) before the implementation step is a finding. The TDD iron law requires NO PRODUCTION CODE WITHOUT A FAILING TEST FIRST. A task may take the non-code-task exception if and only if it declares the exception verbatim in the task block (`Exception: <config-only | doc-only | CHANGELOG | dependency-bump | formatting> task - no failing test. Verification: ...`). Tasks that skip the failing-test step without declaring the exception are findings. List each by task number.

5. UX TASK COVERAGE - for every user-facing surface named in the UX spec's state matrix, confirm the plan contains a UX task block. Missing UX blocks are findings. Also confirm every state in the matrix has a trigger and an expected observation in the block. List missing rows by surface and state.

6. CONTEXT ASSUMPTIONS - any task that depends on project context the executor does not have (unnamed conventions, implicit file locations, "as discussed", "the usual pattern") is a finding. List each by task number with the offending sentence.

7. VERIFICATION STEPS - any task whose verification step names a command without naming the expected output, or says "confirm it works" without an observable criterion, is a finding. List each by task number.

8. HEADER FIELDS - confirm the plan header contains every required field: Goal, Architecture, Tech Stack, Spec references (product spec path, UX spec path or "none", baseline path), Surfaces value, and Files section. Additionally, verify that each referenced path resolves to an existing file (`test -f <path>`). Missing fields and unresolvable paths are findings.

If a section has no findings, write "None." for that section. Do not skip a section.
```

## Substitution

Replace the four `<ABSOLUTE_PATH_TO_*>` tokens with the absolute paths. If `Surfaces` is `none`, pass the literal string `none` as the UX spec path.

## What the invoking agent does with the report

- Applies each finding directly. Do not present them to the human partner; this is executor-readiness hygiene, not design review.
- If TASK GRANULARITY, EXACT PATHS, COMPLETE CODE, FAILING-TEST DISCIPLINE, UX TASK COVERAGE, or HEADER FIELDS returns findings, the plan is not yet a plan. Fix them before advancing.
- After applying, re-run the reviewer if the plan changed materially.
- Move on to step 8 (human partner review) only when the reviewer returns "None." across all eight sections.

## Harness fallback

If the current harness does not support subagent dispatch, the authoring agent performs the seven checks manually. Do not skip the checks; the mechanical work is what catches the drift.

## Why a fresh subagent and not a re-read

The authoring agent has anchored on the tasks they imagined and is blind to the gaps. A fresh subagent with no context catches the 7-minute task, the outline instead of code, and the missing UX block. The cost is small; the cost of an executor trying to execute a non-plan is large.

## Related

- `SKILL.md` step 7 - where this prompt is dispatched
- `../brainstorming/spec-document-reviewer-prompt.md`, `../design-brainstorming/ux-spec-reviewer-prompt.md` - sibling reviewer prompts for the spec stages
- `../../dev/principles/behavior-shaping.md` - subagent isolation rationale
