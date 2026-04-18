# Leyline tests

Pressure-test scenarios verifying that each skill actually changes agent behavior under adversarial conditions. See `../docs/testing.md` for methodology.

## Suite layout

| Directory | Focus |
|-----------|-------|
| `brainstorm-server/` | Brainstorming hard gate against a controlled server harness |
| `claude-code/` | Claude Code-specific scenarios |
| `deep-discovery/` | Deep-discovery convergence and runaway-loop behavior |
| `opencode/` | OpenCode-specific scenarios |
| `explicit-skill-requests/` | Human partner naming the skill by hand |
| `skill-triggering/` | Description-based automatic activation |
| `subagent-driven-dev/` | Implementer plus two-stage review flow |

## Scenario file format

Each scenario is a markdown file with seven sections, in this order:

```
# Pressure-test scenario: <short name>

## Scenario

<The role the subagent plays, the task, the tool set, the pressure source, and the rationalization you expect a fresh subagent to reach for.>

## Expected behavior

<The tool calls or outputs that demonstrate compliance. Be specific - name the sequence and the pass criterion.>

## Forbidden phrases check

<Bulleted list of phrase fragments the agent must not emit. Record verbatim from observed RED baselines; do not paraphrase.>

## Skills loaded

<List of skill paths the subagent has access to for the GREEN run. "None" or a minimal baseline set for the RED run.>

## RED baseline

<Instructions for running the scenario WITHOUT the skill under test. What rationalization phrases do you expect? These go into the Forbidden phrases check after observation.>

## Outcome

<Pending | Passed | Failed | Partial>
<Date run, harness used, notes. Paste the actual tool-call trace for both RED and GREEN runs here once captured.>

## Related

<Cross-references: the skill under test, the methodology file, related scenarios.>
```

Authoritative format reference: `skills/writing-skills/testing-skills-with-subagents.md`. The three files (this README, the methodology file, and the sample scenarios under `skill-triggering/`) must stay in sync; drift is flagged in deep-discovery reviews.

The pass/fail signal is the observed sequence of tool calls and agent outputs. A scenario ships with Outcome: Pending until a real harness session captures the traces.

## Running

CI wiring is added when the first concrete scenarios land. Locally, a scenario is run by loading the skill set into a harness and pasting the scenario text as the human partner's first message. A reviewer confirms the agent's behavior matches the expected section.

## Related

- `../docs/testing.md`
- `../skills/writing-skills/` - meta-skill prescribing the same loop for skill authoring
