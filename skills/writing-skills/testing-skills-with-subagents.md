# Testing skills with subagents

Pressure-testing methodology for Leyline skills. The bar is not "the skill reads well"; the bar is "a fresh subagent under pressure actually complies with the discipline."

## Scenario structure

Every pressure-test scenario is a markdown file under `tests/<group>/` with seven sections, in this order:

```
# Pressure-test scenario: <short name>

## Scenario

<Role the subagent plays; the task; the tool set; the pressure source; the rationalization you expect.>

## Expected behavior

<Tool calls / outputs demonstrating compliance. Name the sequence; name the pass criterion.>

## Forbidden phrases check

<Bulleted list. Record verbatim from RED baseline observations; do not paraphrase. If the scenario is new (no RED captured yet), mark each entry `(provisional - to be replaced with verbatim-observed phrase after RED run)`.>

## Skills loaded

<Skill paths available for GREEN. "None" or a minimal baseline set for RED.>

## RED baseline

<Instructions for running without the skill under test. Rationalizations you expect; instructions for capturing them into the Forbidden phrases check.>

## Outcome

<Pending | Passed | Failed | Partial>
<Date run, harness used, notes. Paste the actual tool-call trace for both RED and GREEN runs here once captured.>

## Related

<Cross-references: the skill under test, the methodology file, related scenarios.>
```

This format is authoritative across `tests/README.md` and the sample scenarios under `tests/skill-triggering/`. Drift between the three is a finding.

## The RED-GREEN-REFACTOR cycle in practice

### RED

Dispatch a fresh subagent into the scenario with NO skills loaded (or only baseline skills - `using-leyline` is always loaded via the hook, but the specific skill under test is absent). Record:

- The subagent's full tool-call trace.
- The exact phrases the subagent uses to rationalize around the discipline.
- Whether the subagent complies with the target behavior or not.

If the subagent complies without the skill, either the scenario is not pressure-inducing enough, or the skill is not needed. Iterate the scenario until the subagent reliably rationalizes away from the discipline.

### GREEN

Load the skill under test into the subagent's context. Dispatch the same scenario. Record:

- The tool-call trace.
- Whether the agent emitted the announce-on-entry sentence.
- Whether the agent followed the checklist steps in order.
- Whether any of the forbidden phrases appeared.
- Whether the iron law / hard gate blocked the rationalization from RED.

Pass criterion: the agent complies AND does not emit any forbidden phrase.

### REFACTOR

With the skill passing the original scenario, construct variations:

- **Pressure shift** - same goal, different pressure source (time → authority; authority → scarcity).
- **Rationalization invention** - the agent is blocked from the RED rationalization; what does it reach for instead?
- **Adjacent scenario** - the skill's description should match this scenario; does the agent invoke it? Does it mis-apply the skill?
- **Tool-set shift** - same goal, different tools available (subagent primitive absent; testing primitive absent; gh unavailable).

For each variation, record the rationalization; add the rebuttal to the skill; re-verify. The refactor loop ends when variations stop producing new rationalizations - typically 3-5 iterations for a strong skill.

## Test groups

Under `tests/`:

| Directory | Focus |
|-----------|-------|
| `brainstorm-server/` | Brainstorming hard gate against a controlled server harness |
| `claude-code/` | Claude Code-specific scenarios |
| `opencode/` | OpenCode-specific scenarios |
| `explicit-skill-requests/` | Human partner naming the skill by hand |
| `skill-triggering/` | Description-based automatic activation |
| `subagent-driven-dev/` | Implementer + two-stage review flow |

New skills get new scenarios in the appropriate group.

## Recording traces

RED and GREEN traces are required for PR submission per `.github/PULL_REQUEST_TEMPLATE.md`. Format:

````
## RED trace (baseline; skill absent)

Harness: <Claude Code / Codex / etc.>
Date: YYYY-MM-DD
Skill(s) loaded: <list or "none">
Scenario: <path to scenario file>

```
<paste the subagent's full trace - tool calls and outputs>
```

### Rationalization observed
<verbatim phrases the subagent used to skip the discipline>

## GREEN trace (skill loaded)

Harness: <same>
Date: YYYY-MM-DD
Skill(s) loaded: <list including the skill under test>
Scenario: <same path>

```
<paste the subagent's full trace>
```

### Compliance observed
<which checklist steps the agent followed; which forbidden phrases did not appear>
````

## Anti-patterns in testing

- **"One-Shot Test"** - a single scenario does not cover a skill. Variations are where real rationalizations surface.
- **"Test The Happy Path"** - the happy path is where agents comply without the skill. Test the failure pressure.
- **"Paraphrase The Rationalization"** - record verbatim. The surface the skill rebuts is the specific phrase the agent uses.
- **"Stop At GREEN"** - GREEN is the midpoint, not the end. REFACTOR is where loopholes close.
- **"Manual Scenario Only"** - tests should be reproducible. Commit the scenario file; record the harness / date / skills loaded.

## When to run the tests

- **On every skill change** - required by contributor rules.
- **On every dependency version bump** that affects the harness or the subagent dispatch primitive.
- **On every new harness added to the support matrix** - re-run the tests in the new harness to confirm skill behavior is portable.
- **In CI** - when the plugin's CI system gains the ability to run subagent dispatches, the test suite becomes a gate on merge.

## Harness portability

A skill that passes in Claude Code but fails in Codex is not yet a shipped skill. Either:

- The skill's tool-name references need harness-specific mapping (see `../using-leyline/references/codex-tools.md`, `copilot-tools.md`).
- The skill's discipline depends on a primitive the other harness lacks (subagent dispatch, specific tool), in which case document the limitation in the per-harness install docs.

Passing in one harness and stopping is acceptable for an alpha release; shipping without the per-harness verification is not.

## Related

- `SKILL.md` - the invoking skill
- `../../dev/principles/tdd-for-prose.md` - canonical methodology
- `../../dev/principles/behavior-shaping.md` - why testing is load-bearing
- `../../tests/README.md` - test directory structure
- `examples/` - worked examples with traces
