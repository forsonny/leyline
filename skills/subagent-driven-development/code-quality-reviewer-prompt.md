# Code-quality reviewer prompt template

Use this template as the full prompt for the code-quality reviewer dispatched at step 4 of the per-task loop. This prompt in turn dispatches the canonical `code-reviewer` agent (`agents/code-reviewer.md`) and consumes its output, triaging for this specific task.

## Prompt template

```
You are running a code-quality review on one task's implementation. You are not reviewing spec compliance - a separate reviewer handles that. You are not redesigning the feature. Your job is to run the canonical `code-reviewer` agent against the task's changes and present the findings back to the coordinating agent, triaged by severity.

You have access to:
- The plan at: <ABSOLUTE_PATH_TO_PLAN>
- The task block:

---
<TASK_BLOCK_VERBATIM>
---

- The commits on this task (base + head SHAs):

<BASE_SHA>..<HEAD_SHA>

- A short description of what was implemented:

<DESCRIPTION>

Procedure:

1. Dispatch the `code-reviewer` subagent defined at `agents/code-reviewer.md` with the following inputs:
   - {WHAT_WAS_IMPLEMENTED} = <DESCRIPTION>
   - {PLAN_OR_REQUIREMENTS} = the task block (copied above)
   - {BASE_SHA} = <BASE_SHA>
   - {HEAD_SHA} = <HEAD_SHA>
   - {DESCRIPTION} = <DESCRIPTION>

2. The `code-reviewer` returns findings categorized as Critical / Important / Suggestions.

3. Return your report back to the coordinating agent in this format:

## Code-quality review - task <N>

### Critical findings
<list verbatim from code-reviewer, or "None.">

### Important findings
<list verbatim, or "None.">

### Suggestions
<list verbatim, or "None.">

### Triage
- Blocks task completion: <yes/no>. "Yes" if any Critical or Important findings are present. "No" otherwise.
- Recommended next action: <re-dispatch implementer with fixes; OR advance to design review (if surfaces touched) or mark complete (if not)>.

Do not edit or soften the `code-reviewer`'s findings. Your job is triage, not editorial.
```

## Substitution

Replace the `<ABSOLUTE_PATH_TO_*>`, `<TASK_BLOCK_VERBATIM>`, `<BASE_SHA>`, `<HEAD_SHA>`, and `<DESCRIPTION>` tokens with concrete values.

## What the coordinating agent does with the quality reviewer's report

- **Triage says "Blocks: no":** advance to design review (if surfaces touched) or mark complete (if not).
- **Triage says "Blocks: yes":** re-dispatch the implementer with the Critical + Important findings spliced into the prompt. Re-run the quality review after the implementer's new output.
- Suggestions are recorded in the review log but do not block. Apply them opportunistically.

## Why this wrapper exists around `agents/code-reviewer.md`

The `code-reviewer` agent is the canonical review procedure; it is used at the per-task pass here AND at the final branch-level review in stage 7. This wrapper does two things: (1) constructs the inputs the agent expects, and (2) triages the findings specifically for "does this block task completion?" - which is a per-task decision the branch-level review does not make.

## Related

- `SKILL.md` step 4
- `implementer-prompt.md`, `spec-reviewer-prompt.md` - sibling prompts
- `../../agents/code-reviewer.md` - the canonical review procedure this prompt dispatches (planned Stage 7)
- `../requesting-code-review/SKILL.md` - stage 7 branch-level review (planned)
