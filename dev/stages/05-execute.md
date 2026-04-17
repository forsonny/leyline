# Stage 5 — Execute

**Skills:**
- `subagent-driven-development` (preferred, in-session, subagents required)
- `executing-plans` (batched, human checkpoints, fallback when subagents unavailable)
- `dispatching-parallel-agents` (when multiple independent problems surface)

**Successor:** `requesting-code-review` (stage 7)
**Input:** Plan produced by stage 4.

## Why subagents

Each task is delegated to a fresh subagent with precisely constructed context. Subagents never inherit the parent session's history. This keeps their focus tight and preserves the parent's context for coordination.

> Core principle: Fresh subagent per task + two-stage review (spec then quality), plus a third design-review pass when surfaces are touched = high quality, fast iteration

## Experience gate (pre-dispatch)

Before dispatching the implementer subagent for any task whose "Files:" block touches a user-facing surface, verify that `docs/leyline/design/<file>` exists, is current, and covers the surface. If not, stop. Do not dispatch. Return to `design-brainstorming` (stage 1b).

This gate is the operational enforcement of the `design-driven-development` iron law: `NO USER-FACING SURFACE WITHOUT AN APPROVED DESIGN ARTIFACT FIRST`.

## subagent-driven-development — per-task loop

1. **Experience gate check.** If the task touches a surface and no current artifact exists, stop and loop to `design-brainstorming`.
2. **Dispatch implementer subagent** using `./implementer-prompt.md`
   - If the subagent asks questions, answer them and re-dispatch
   - Otherwise the subagent implements, tests, commits, self-reviews
3. **Dispatch spec-compliance reviewer** using `./spec-reviewer-prompt.md`
   - If it confirms the code matches the spec, proceed
   - Otherwise implementer fixes spec gaps and the reviewer re-runs
4. **Dispatch code-quality reviewer** using `./code-quality-reviewer-prompt.md`
   - If it approves, proceed (continue to step 5 if surfaces touched; otherwise mark complete)
   - Otherwise implementer fixes quality issues and the reviewer re-runs
5. **Dispatch design-reviewer subagent** (only when the task touched a user-facing surface) using the `agents/design-reviewer.md` definition
   - Subagent inspects available harness tools (browser automation, design-tool MCPs, a11y scanners, snapshot tools) and uses them when present; structural review otherwise
   - If it approves, mark the task complete in TodoWrite
   - Otherwise implementer fixes UX / a11y issues and the reviewer re-runs

After all tasks are complete, hand off to Stage 7 (`requesting-code-review`, plus `requesting-design-review` when surfaces were touched). Stage 7 owns the branch-level reviewer pass; Stage 5 ends once the per-task loops complete and the review log is committed.

## Supporting files in the skill folder

- `SKILL.md`
- `implementer-prompt.md` — template for the implementer subagent
- `spec-reviewer-prompt.md` — template for the spec-compliance reviewer
- `code-quality-reviewer-prompt.md` — template for the code-quality reviewer (dispatches the `code-reviewer` agent from `agents/code-reviewer.md`)

## executing-plans — fallback mode

Use when subagents are not available (the skill itself recommends telling the human partner that the plugin works significantly better with subagent support).

Process:
1. Load plan, review critically, raise concerns before starting
2. Create TodoWrite and execute each task
3. Follow steps exactly, run verifications as specified, mark completed
4. After all tasks verified, announce transition: "I'm using the finishing-a-development-branch skill to complete this work."

**Stop conditions (required sub-skill: finishing-a-development-branch after completion):**
- Blocker hit (missing dependency, failing test, unclear instruction)
- Plan has critical gaps
- Don't understand an instruction
- Verification fails repeatedly

Ask rather than guess.

## dispatching-parallel-agents — when to reach for it

Use when 2+ independent problems surface during execution:
- 3+ test files failing with different root causes
- Multiple subsystems broken independently
- Each problem understandable without context from the others
- No shared state between investigations

Don't use when failures might be related, when you need full system state, or when parallel agents would interfere.

Pattern: one agent per independent problem domain, dispatched concurrently with precisely crafted context each.

## Anti-patterns

- Reusing a subagent across tasks (context pollution)
- Inheriting parent-session context into a subagent
- Skipping either review pass
- Marking a task complete before both reviews pass
- Running parallel agents on related failures

## Related

- `stages/04-plan.md` — source of the tasks
- `stages/06-discipline.md` — overlays that govern every code change and failure during execution
- `stages/07-review.md` — the final reviewer pass that follows task completion
- `structure/agents.md` — `code-reviewer` agent definition
