# Design-quality reviewer prompt template (per-task)

Use this template as the full prompt for the per-task design reviewer dispatched at step 6 of the per-task loop (when the task touched a user-facing surface). This prompt dispatches the canonical `agents/design-reviewer.md` agent in per-task mode and triages its findings for this specific task.

Parallel to `code-quality-reviewer-prompt.md`; same structural role, different reviewer agent.

## Prompt template

```
You are running a per-task design-review on one task's surface implementation. You are not reviewing code quality or spec compliance - those are separate reviewers at Stage 5. Your job is to dispatch the `design-reviewer` agent with narrow per-task inputs and present its findings back to the coordinating agent, triaged by severity.

You have access to:
- The plan at: <ABSOLUTE_PATH_TO_PLAN>
- The UX spec at: <ABSOLUTE_PATH_TO_UX_SPEC>
- The review log at: <ABSOLUTE_PATH_TO_REVIEW_LOG>
- The task block:

---
<TASK_BLOCK_VERBATIM>
---

- The commits on this task (base + head SHAs):

<BASE_SHA>..<HEAD_SHA>

- The surfaces this task touched:

<SURFACES_TOUCHED>

- A short description:

<DESCRIPTION>

Procedure:

1. Dispatch the `design-reviewer` subagent defined at `agents/design-reviewer.md` with these inputs:
   - {MODE} = per-task
   - {UX_SPEC} = <ABSOLUTE_PATH_TO_UX_SPEC>
   - {SURFACES_IMPLEMENTED} = <SURFACES_TOUCHED>
   - {ACCESSIBILITY_EVIDENCE} = <ABSOLUTE_PATH_TO_REVIEW_LOG>
   - {BASE_SHA} = <BASE_SHA>
   - {HEAD_SHA} = <HEAD_SHA>
   - {DESCRIPTION} = <DESCRIPTION>

2. The `design-reviewer` returns pre-numbered `D<n>` findings categorized Critical / Important / Suggestions across six review blocks plus an iron-law sweep (iron laws 4 and 5).

3. Return your report back to the coordinating agent in this format:

## Design-quality review - task <N>

### Critical findings
<verbatim from design-reviewer, preserving D<n> numbering; or "None.">

### Important findings
<verbatim, preserving D<n> numbering; or "None.">

### Suggestions
<verbatim, preserving D<n> numbering; or "None.">

### Iron-law sweep
- Iron law 4 (design-driven-development): <verbatim or "None.">
- Iron law 5 (accessibility-verification): <verbatim or "None.">

### Spec-update recommendations
<verbatim or "None.">

### Triage
- Blocks task completion: <yes/no>. "Yes" if any Critical or Important findings are present, OR if the iron-law sweep flagged any concrete violation. "No" otherwise.
- Recommended next action: <re-dispatch implementer with fixes; OR loop back to design-brainstorming if a spec-update finding is material; OR mark complete>.

Do not edit or soften the `design-reviewer`'s findings. Do not renumber. Your job is triage, not editorial.
```

## Substitution

Replace the absolute-path and bracketed tokens with concrete values. `<SURFACES_TOUCHED>` is the list of surfaces the task touched, verbatim from the UX spec's Surfaces enumeration. `<TASK_BLOCK_VERBATIM>` includes all checkboxes.

## What the coordinating agent does with the triage

- **Triage says "Blocks: no":** mark the task complete in TodoWrite; append the full report to the review log under `## Task <N>`.
- **Triage says "Blocks: yes":** re-dispatch the implementer with the blocking findings spliced in. Re-run the spec-compliance reviewer AND the quality reviewer AND this design-quality reviewer after the implementer's new output, per the per-task loop's "re-run prior reviews after any fix" rule.
- **Triage says "loop back to design-brainstorming":** the finding is a spec-update. SUSPEND this task's loop; route back to `design-brainstorming`; after re-approval, re-dispatch the implementer against the new UX spec (the task block may need revision by `writing-plans` to cite the new round).

## Why this wrapper exists around `agents/design-reviewer.md`

The `design-reviewer` agent is the canonical review procedure; used at per-task here AND at the branch-level in `requesting-design-review`. This wrapper does two things: (1) constructs per-task mode inputs, and (2) triages findings for "does this block task completion?" - a per-task decision the branch-level review does not make.

## Related

- `SKILL.md` step 6 (surface-touching branch of the per-task loop)
- `implementer-prompt.md`, `spec-reviewer-prompt.md`, `code-quality-reviewer-prompt.md` - sibling prompts
- `../../agents/design-reviewer.md` - the canonical review procedure this prompt dispatches
- `../requesting-design-review/SKILL.md` - branch-level counterpart (Stage 7)
