# Stage 8 — Finish

**Skill:** `finishing-a-development-branch`
**Description line:** "Use when implementation is complete, all tests pass, and you need to decide how to integrate the work - guides completion of development work by presenting structured options for merge, PR, or cleanup"
**Successor:** none — pipeline terminates here.
**Core principle:** Verify tests → Present options → Execute choice → Clean up.

## Announce on entry

> I'm using the finishing-a-development-branch skill to complete this work.

## Step 1 — Verify tests

Run the project's test suite (`npm test`, `cargo test`, `pytest`, `go test ./...`, etc.).

If tests fail:
```
Tests failing (<N> failures). Must fix before completing:

[Show failures]

Cannot proceed with merge/PR until tests pass.
```
Stop. Do not proceed to Step 2.

If tests pass, continue.

## Step 2 — Determine base branch

```bash
git merge-base HEAD main 2>/dev/null || git merge-base HEAD master 2>/dev/null
```

Or ask: "This branch split from main — is that correct?"

## Step 3 — Present the four options

Present exactly these to the human partner:

```
Implementation complete. What would you like to do?

1. Merge back to <base-branch> locally
2. Push and create a Pull Request
3. Keep the branch as-is (I'll handle it later)
4. Discard this work
```

## Step 4 — Execute the chosen path

Depending on choice:
- **Merge locally** — switch to base, merge, clean up worktree
- **Push + PR** — push the branch, open a PR via the appropriate tooling, leave the worktree in place until the PR is merged
- **Keep** — no further action, leave worktree and branch
- **Discard** — delete the worktree and branch (destructive; confirm before acting)

## Destructive-action rules

Option 4 (discard) deletes work. Confirm explicitly before executing. Never discard without confirmation.

## Anti-patterns

- Skipping the test verification and "just opening the PR"
- Offering options beyond the four
- Executing a destructive option without confirmation
- Leaving stale worktrees after a local merge

## Related

- `stages/05-execute.md` — the stage that precedes finishing
- `stages/07-review.md` — the final reviewer pass must have cleared before entering finish
- `stages/03-isolate.md` — the worktree created here gets cleaned up (or preserved) as part of the chosen option
