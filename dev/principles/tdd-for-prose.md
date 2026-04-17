# TDD for prose — the `writing-skills` methodology

The meta-skill `writing-skills` applies Test-Driven Development to documentation. A skill is not prose; it is code that shapes agent behavior, and it must be tested against real agents.

> Core principle: If you didn't watch an agent fail without the skill, you don't know if the skill teaches the right thing.

## TDD → prose mapping

| TDD concept | Skill creation |
|-------------|----------------|
| Test case | Pressure scenario with a subagent |
| Production code | `SKILL.md` content |
| Test fails (RED) | Agent violates the rule without the skill (baseline) |
| Test passes (GREEN) | Agent complies with the skill present |
| Refactor | Close loopholes while maintaining compliance |
| Write test first | Run baseline scenario BEFORE writing skill text |
| Watch it fail | Document exact rationalizations the agent uses |
| Minimal code | Write skill text addressing those specific rationalizations |
| Watch it pass | Verify agent now complies |
| Refactor cycle | Find new rationalizations → plug → re-verify |

## Required background

You must understand `test-driven-development` before using `writing-skills`. RED-GREEN-REFACTOR defines the cycle; this skill adapts it to prose.

## When to create a skill

Create when:
- The technique wasn't intuitively obvious to you
- You'll reference it again across projects
- The pattern applies broadly (not project-specific)
- Others would benefit

Don't create for:
- One-off solutions
- Standard practices documented elsewhere
- Project-specific conventions (put those in `CLAUDE.md`)
- Mechanical constraints (if a regex or validator can enforce it, automate it)

## Skill types

- **Technique** — concrete method with steps (e.g., condition-based-waiting)
- **Pattern** — way of thinking about a problem (e.g., flatten-with-flags)
- **Reference** — API docs, syntax guides, tool documentation

## Process (for the author)

1. **RED — run the baseline.** Dispatch a subagent into the scenario without the skill. Observe. Record the exact rationalizations it uses to avoid the discipline.
2. **GREEN — write the minimal skill.** Produce `SKILL.md` content that specifically rebuts those rationalizations. Keep it as small as possible.
3. **Verify GREEN.** Re-run the scenario with the skill loaded. Agent must comply.
4. **REFACTOR.** Hunt for new rationalizations the agent invents now that the obvious paths are blocked. Tighten the skill. Re-verify.

## Supporting files in `writing-skills/`

- `SKILL.md`
- `anthropic-best-practices.md` — official best-practices reference
- `persuasion-principles.md` — notes on how skill language influences agent behavior
- `graphviz-conventions.dot` — conventions for DOT diagrams embedded in skills
- `render-graphs.js` — utility to render DOT to images
- `testing-skills-with-subagents.md` — the pressure-testing methodology in detail
- `examples/` — worked examples of skills produced by this process

## Why this matters

If a skill is modified "to comply" with external style guidance but no one re-ran the pressure tests, the skill's behavior-shaping function can silently regress. Contributor guidelines require before/after eval evidence for any change to skill content precisely because the prose and the behavior are coupled.

## Related

- `principles/behavior-shaping.md` — the mechanisms that get tested here
- `structure/skills.md` — the library this methodology produces
- `structure/tests.md` — the CI-level version of this methodology
- `reference/skill-file-format.md` — file-format rules the methodology respects
- `reference/diagrams.md` — DOT conventions used in process diagrams
