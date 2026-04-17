# Worked examples

This directory holds worked examples of skills produced via the `writing-skills` TDD-for-prose process. Each example has:

- The final skill text.
- The RED baseline trace (scenario run without the skill).
- The GREEN trace (same scenario with the skill loaded).
- A short narrative explaining what rationalization the skill plugs.

## Planned examples

- `named-anti-patterns/` - how the naming convention ("This Is Too Simple To Need A Spec") blocks a rationalization that a soft prose prohibition does not.
- `announce-on-entry/` - why forcing the agent to commit verbally changes downstream behavior.
- `forbidden-phrases/` - the most specific match surface for blocking performative agreement.

## Status

The directory is a placeholder at v0.10.0 (initial Stage 9 release). Worked examples land incrementally as each skill's pressure-test evidence is captured in a format suitable for publication.

Contributors who author a new skill should save their RED/GREEN traces under `examples/<skill-name>/` as a natural byproduct of following the `writing-skills` process.

## Related

- `../SKILL.md` - the meta-skill
- `../testing-skills-with-subagents.md` - scenario and trace format
- `../../../tests/` - pressure-test scenarios tied to specific skills
