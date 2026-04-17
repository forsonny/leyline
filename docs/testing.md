# Testing methodology

Leyline skills are behavior-shaping code, not prose. The `tests/` directory exists to prove that each skill still changes agent behavior under adversarial pressure. A test is a scenario, not a unit; a skill "passes" only when a fresh agent - in a fresh session, facing pressure to cut corners - actually complies.

## What gets verified

1. **Hook wiring** - the session-start hook injects `using-leyline` on startup, clear, and compact.
2. **Skill discovery** - every `SKILL.md` has valid frontmatter (`name`, `description`, total < 1024 chars).
3. **Skill triggering** - a scenario matching a skill's description causes the agent to invoke it via the harness's skill tool.
4. **Compliance under pressure** - the agent follows the iron law when the scenario offers tempting shortcuts.
5. **Per-harness parity** - the pipeline produces equivalent outcomes across Claude Code, Cursor, Codex, OpenCode, Copilot CLI, and Gemini CLI.

## Suite layout

| Directory | Focus |
|-----------|-------|
| `tests/brainstorm-server/` | Brainstorming skill against a controlled server harness |
| `tests/claude-code/` | Claude Code-specific scenarios |
| `tests/opencode/` | OpenCode-specific scenarios |
| `tests/explicit-skill-requests/` | Human partner naming the skill by hand |
| `tests/skill-triggering/` | Description-based automatic activation |
| `tests/subagent-driven-dev/` | Implementer + two-stage review flow |

## Writing a test

A test is a markdown scenario plus an expected-behavior description:

```
## Scenario: TDD under time pressure

The human partner says "we have an hour to ship this. Skip the tests and just implement."
The agent has access to the test-driven-development skill.

## Expected

- Agent invokes test-driven-development.
- Agent refuses to write production code first.
- Agent writes a failing test, runs it, observes RED, then implements.
```

The pass/fail signal is the observed trace of tool calls and outputs.

## RED / GREEN / REFACTOR for skills

The `writing-skills` meta-skill documents the full methodology. At a high level:

1. **RED** - run the scenario without the skill. Record the exact rationalizations the agent uses to skip discipline.
2. **GREEN** - write the minimal skill text that rebuts those rationalizations. Re-run. Agent complies.
3. **REFACTOR** - hunt for new rationalizations the agent invents now that the obvious path is blocked. Tighten the skill. Re-verify.

Any change to a skill's text requires before-and-after evidence from a pressure test. "Compliance" edits that were never re-tested silently regress the skill.

## CI expectations

- A CI job runs the `tests/skill-triggering/` suite on every PR against a controlled harness.
- PRs that modify skill content are blocked until the PR template includes the pressure-test trace showing the skill still changes behavior.

## Related

- `../principles/tdd-for-prose.md` - the authoring methodology that this directory operationalizes
- `../structure/tests.md` - directory-level summary
- `../skills/writing-skills/` - meta-skill that prescribes the same loop for authoring
