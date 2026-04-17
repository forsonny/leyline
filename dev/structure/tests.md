# `tests/` — behavior verification

**Location:** `tests/` at the repo root.

## Test suite groups

- `tests/brainstorm-server/` — verifies brainstorming skill behavior, likely using a controlled server harness
- `tests/claude-code/` — harness-specific scenarios for Claude Code
- `tests/explicit-skill-requests/` — verifies that skills activate when explicitly requested by the human partner
- `tests/opencode/` — harness-specific scenarios for OpenCode
- `tests/skill-triggering/` — verifies automatic skill activation via descriptions (the core hook/frontmatter contract)
- `tests/subagent-driven-dev/` — verifies the subagent-driven-development workflow (implementer + two-stage review)

## What gets verified

Because skills are behavior-shaping code, correctness means "did the agent actually comply under pressure," not "did the markdown parse." Tests are adversarial pressure scenarios run against real agents, and the pass/fail signal is observed behavior.

Typical test concerns:
- **Hook wiring** — does the session-start hook inject the entry skill on startup/clear/compact
- **Skill discovery** — does each SKILL.md have valid frontmatter and pass description-length limits
- **Skill triggering** — does a scenario matching a skill's description actually cause the agent to invoke it
- **Compliance under pressure** — does the agent follow the iron law or rationalize around it
- **Per-harness parity** — does the workflow produce equivalent outcomes across supported harnesses

## Relationship to `writing-skills` methodology

The meta-skill `writing-skills` prescribes the same test style for authoring new skills: baseline pressure scenario → skill text → re-run → refactor. Tests in this directory are the CI-level version of that discipline.

## Related

- `principles/tdd-for-prose.md` — the authoring methodology that this directory operationalizes
- `docs/testing.md` (source) — methodology note; summarized here
- `structure/hooks.md` — the wiring that `tests/skill-triggering/` exercises
- `structure/skills.md` — the library whose behavior is verified here
