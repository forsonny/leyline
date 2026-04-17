# Testing anti-patterns

A catalogue of bad-test shapes `test-driven-development` rebuts. Named anti-patterns are easier to recognize at the moment you are about to commit one.

## Structural anti-patterns

### "Test Photocopy"

The test reads like the implementation: same branches, same internal function calls, same helper imports. Often the test was written after the code. Sign: the test's failures depend on the implementation's internal structure, not on the behavior the caller sees.

Fix: rewrite the test against the specification, not the implementation. Black-box test first; only add internal-structure tests when the task block specifically requires it.

### "Tautological test"

Asserts the implementation agrees with itself. `assert foo() == foo()`. Or uses the same helper to produce both the actual and expected value. Passes vacuously; catches nothing.

Fix: the expected value must be a literal (or computed by code with different provenance from the implementation).

### "Snapshot-only"

The only assertion is "output matches this recorded blob." Useful for catching unintended changes, useless for catching intended-bad changes. A human updating the snapshot makes the test pass.

Fix: complement snapshot tests with behavioral assertions.

### "One Big Test"

A single test case exercises five features. When it fails, the reason is ambiguous and the debug session is long.

Fix: one test per named behavior. Tests are cheap.

### "Fragile to Order"

Tests depend on execution order because of shared state. `test_b` only passes when `test_a` ran first. Flakes when the runner parallelizes or reorders.

Fix: each test sets up its own state from scratch; tears down in a finalizer.

### "Magic-Sleep"

`time.sleep(0.1)` or equivalent to "let things settle." Flakes on slow CI runners; slow on fast machines. Proxy for "I don't understand the timing."

Fix: wait on a specific condition, not a duration (`wait_until(lambda: status == "ready", timeout=5)`). If the condition is hard to name, the code under test is probably wrong.

## Timing anti-patterns

### "Mocked Everything"

Every external call mocked, every dependency stubbed. The test passes only because the mocks agree with themselves.

Fix: mock boundaries (network, clock, filesystem), not internals. Integration-testable code is often better-factored code.

### "Integration Test Mislabeled As Unit"

Actually hits the database, the network, the filesystem. Slow; flaky; fails on laptop-without-docker.

Fix: rename to integration; put in an `integration/` directory; gate in CI. If the team ships only unit tests, factor out the integration path from the implementation.

## Meaning anti-patterns

### "Test Of The Wrong Thing"

Asserts on incidental behavior (the log line said X) while the primary behavior (the return value) goes unchecked. Catches log-format changes; misses function-behavior regressions.

Fix: assert on what callers observe. Log-line assertions only when the log line IS the contract (structured logs consumed by another service).

### "Test That Can't Fail"

The assertion is structurally incapable of failing. `assert True`. `assert result is not None` when the function always returns something. Looks like coverage; provides none.

Fix: every test must have at least one mutation of the implementation that would make it fail. If no such mutation exists, delete the test.

### "Coverage-Driven Test"

Written to cover a line, not to specify a behavior. Calls the code with any argument that reaches the branch; asserts nothing meaningful.

Fix: cover behaviors, not lines. Lines with no behavior worth asserting are candidates for removal, not for tautological tests.

## RED-phase anti-patterns

### "RED Was Never Observed"

Wrote the test, wrote the code, ran the test, it passed. Author claims RED-GREEN-REFACTOR. Did not verify the test could fail.

Fix: run the test before writing the code. A test that never failed is a test that cannot fail.

### "RED For The Wrong Reason"

Test failed with NameError because the function under test does not exist yet, but the task block predicted an assertion failure.

Fix: after importing or stubbing the function, re-run. The failure must be the behavior mismatch the task block names.

## REFACTOR-phase anti-patterns

### "Refactor Under Red"

Refactored code while tests were failing; now they are still failing but "in a different way." Cannot tell which failure is the refactor and which was pre-existing.

Fix: only refactor under green. If tests are red, fix them first.

### "Refactor That Changes Behavior"

Renamed extracted helper, but also changed an edge case it handles. Tests pass because the edge case was never tested.

Fix: pure refactor never changes behavior. If you discover an untested edge case, add a test, make sure it is green, then refactor.

## Related

- `SKILL.md` - the invoking skill
- `../systematic-debugging/SKILL.md` - the process for "RED for the wrong reason" and similar investigation needs
- `../../dev/principles/iron-laws.md` - the iron law catalogue
