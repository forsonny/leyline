# Stage 3 — Isolate

**Skill:** `using-git-worktrees`
**Description line:** "Use when starting feature work that needs isolation from current workspace or before executing implementation plans - creates isolated git worktrees with smart directory selection and safety verification"
**Successor:** `writing-plans` (stage 4)
**Core principle:** Systematic directory selection + safety verification = reliable isolation.

## Announce on entry

> I'm using the using-git-worktrees skill to set up an isolated workspace.

## Directory selection — priority order

Explicit human-partner configuration beats incidental folder presence.

1. **`CLAUDE.md` preference**
   - `grep -iE 'worktree.*(director|folder|location|path|dir)' CLAUDE.md`
   - Also scan for a `## Worktrees` or `## Worktree directory` heading and read its body.
   - If specified, use it without asking.
2. **Existing directories**
   - Check for `.worktrees/` (preferred, hidden).
   - Fallback to `worktrees/` (non-hidden alternative).
   - If both exist, `.worktrees/` wins.
3. **Ask the human partner**
   - Present two default options: local `.worktrees/` (project-local, hidden) vs. a platform-aware global location (`~/.config/leyline/worktrees/<project-name>/` on Linux/POSIX, `~/Library/Application Support/leyline/worktrees/<project-name>/` on macOS, `%LOCALAPPDATA%\leyline\worktrees\<project-name>\` on Windows).

## Safety verification

For project-local directories (`.worktrees` or `worktrees`), the directory MUST be gitignored before creating a worktree. Verify with `git check-ignore -q .worktrees` (or `worktrees`). If not ignored, fix the gitignore before proceeding.

## Exit conditions

- Worktree exists on a new branch, cleanly checked out
- Project setup (install, bootstrap) has run
- Test suite is green — this is the clean baseline

The clean baseline is non-negotiable. Later failures must belong to the work in the branch, not to pre-existing breakage carried in.

## Anti-patterns

- Creating a worktree in a directory that isn't gitignored — leaks the worktree into the parent repo
- Skipping the test baseline and discovering later that something was broken before the work started
- Running implementation tasks in the original workspace instead of the worktree

## Related

- `stages/02-interrogate.md` — the stage that must clear before worktree creation
- `stages/04-plan.md` — runs inside the worktree, not outside
- `stages/08-finish.md` — cleans up the worktree at the end of the pipeline
- `structure/manifests.md` — `CLAUDE.md` is checked for a worktree-directory preference
