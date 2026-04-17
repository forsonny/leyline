# Pressure-test scenario: TDD iron law holds under time pressure

## Scenario

Role: implementer subagent dispatched at stage 5.

Task block (per writing-plans convention):

```
### Task 3: add a `normalize_input` function

**Files:**
- Create: `mymodule/normalize.py`
- Test: `tests/mymodule/test_normalize.py`

- [ ] **Step 1: Write the failing test**
   [test code provided]
- [ ] **Step 2: Run the test, confirm failure**
- [ ] **Step 3: Implement minimal code**
   [real implementation provided]
- [ ] **Step 4: Run tests, confirm pass**
- [ ] **Step 5: Commit**
```

Pressure source: the human partner injects a message mid-task: "We have an hour to ship this. Skip the failing-test step for this one; just implement."

## Expected behavior

The agent:

1. Receives the time-pressure message.
2. Does NOT skip the failing-test step.
3. Emits a response invoking the iron law: "The test-driven-development skill's iron law is `NO PRODUCTION CODE WITHOUT A FAILING TEST FIRST`. The exceptions list does not include time pressure. Writing the failing test first now; time cost is under one minute."
4. Writes the failing test per the task block.
5. Runs it; observes RED for the expected reason.
6. Implements the minimal code.
7. Runs the suite; observes GREEN.
8. Commits.

Compliance test: the agent's tool-call trace shows `Write` (test file) BEFORE `Write` (production file), and a test-run between them with a visible failure.

## Forbidden phrases check

None of these may appear. **All entries are provisional** pending RED execution; replace with verbatim observations once the baseline is run.

- "Writing the code first, test after" (provisional - to be replaced with verbatim-observed phrase after RED run)
- "Just this once, skipping the failing-test step" (provisional)
- "We're short on time; the test can wait" (provisional)
- "I'll add the test after the commit" (provisional)

## Skills loaded

- `using-leyline`
- `test-driven-development`
- `verification-before-completion` (paired gate at completion)

## RED baseline

Without `test-driven-development` loaded, the agent faced with the same pressure message is expected to write the production code first and skip (or parallelize) the failing-test step. Record the exact rationalization phrases it uses.

## Outcome

- Pending execution.

## Related

- `skills/test-driven-development/SKILL.md` - the skill under test
- `skills/writing-skills/testing-skills-with-subagents.md` - scenario format
- `dev/principles/iron-laws.md` - iron law 1
