# Stage 4 — Plan

**Skill:** `writing-plans`
**Description line:** "Use when you have a spec or requirements for a multi-step task, before touching code"
**Successor:** `subagent-driven-development` (preferred) or `executing-plans` (if subagents unavailable)
**Output artifact:** Plan saved to `docs/leyline/plans/YYYY-MM-DD-<feature-name>.md`
**Audience assumption:** An enthusiastic junior engineer with poor taste, no judgement, no project context, and an aversion to testing.

## Announce on entry

> I'm using the writing-plans skill to create the implementation plan.

## Context

- Runs inside the worktree created by stage 3
- Principles the plan enforces on the executor: DRY, YAGNI, TDD, frequent commits

## Scope check

If the spec covers multiple independent subsystems, it should already have been broken into sub-project specs during brainstorming. If not, stop and suggest splitting into separate plans — one per subsystem. Each plan should produce working, testable software on its own.

## File structure pass

Before defining tasks, map out which files will be created or modified and what each is responsible for.

- Units with clear boundaries and well-defined interfaces
- One clear responsibility per file
- Files that change together live together (split by responsibility, not by technical layer)
- In existing codebases, follow established patterns. Don't unilaterally restructure, but a split is reasonable if a modified file has grown unwieldy.

## Task granularity

Each task is 2–5 minutes of work. One action per step:

- "Write the failing test"
- "Run it to make sure it fails"
- "Implement the minimal code to make the test pass"
- "Run the tests and make sure they pass"
- "Commit"

## Required plan header

```markdown
# [Feature Name] Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use leyline:subagent-driven-development (recommended) or leyline:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** [One sentence describing what this builds]

**Architecture:** [2-3 sentences about approach]

**Tech Stack:** [Key technologies/libraries]

---
```

## Task block template

````markdown
### Task N: [Component Name]

**Files:**
- Create: `exact/path/to/file.py`
- Modify: `exact/path/to/existing.py:123-145`
- Test: `tests/exact/path/to/test.py`

- [ ] **Step 1: Write the failing test**

```python
def test_specific_behavior():
    result = function(input)
    assert result == expected
```

- [ ] **Step 2: Run it, confirm failure**
- [ ] **Step 3: Implement minimal code**

```python
def function(input):
    ...
```

- [ ] **Step 4: Run tests, confirm pass**
- [ ] **Step 5: Commit**
````

## UX task block template

When a task touches a user-facing surface (see `reference/surface-types.md`), add a UX task block alongside the code task block(s). Every surface touched gets one, even if only to confirm no states changed.

````markdown
### Task N: [Surface Name] — UX Task

**Surface:** <name from state matrix>
**Artifact reference:** docs/leyline/design/<file>#<section>

- [ ] **Step 1:** Confirm the artifact section is current
- [ ] **Step 2:** Implement the surface per the artifact
- [ ] **Step 3:** Trigger each state from the matrix and observe
- [ ] **Step 4:** Run the accessibility verification procedure
- [ ] **Step 5:** Side-by-side reconciliation against the artifact
- [ ] **Step 6:** Commit
````

This block is governed by the Experience Discipline overlay (`stages/06-discipline.md`) — specifically `design-driven-development` and `accessibility-verification`.

## Anti-patterns

- Writing tasks bigger than 5 minutes
- Omitting the exact file paths, leaving the executor to guess
- Skipping the failing-test step — direct violation of TDD
- Bundling multiple responsibilities into one task
- Writing plans that assume project context the executor doesn't have
- Omitting UX tasks when surfaces are touched — every surface touched gets a UX task block, even if only to confirm no states changed

## Related

- `stages/05-execute.md` — the successor stages that consume the plan
- `stages/06-discipline.md` — TDD is embedded in every task; systematic-debugging governs every failure during execution
- `principles/iron-laws.md` — the plan enforces TDD's iron law by construction
