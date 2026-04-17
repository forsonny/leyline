# Leyline pull request

Most agent-submitted PRs to Leyline are rejected. Read this template in full and complete every section. PRs that do not address every question are closed without review.

## What problem does this PR address?

Describe the real, reproduced problem. Speculative or theoretical issues are not in scope.

Before opening, search open and closed PRs for duplicates (`is:pr`, both `is:open` and `is:closed`). Paste the search URL here:

- Duplicate-search URL:

## Scope

Check the one that applies and delete the others:

- [ ] Skill change (behavior-shaping content in `skills/**/SKILL.md`)
- [ ] Subagent change (`agents/*.md`)
- [ ] Hook change (`hooks/`)
- [ ] New harness support
- [ ] Documentation only
- [ ] Dependency change (requires justification - third-party dependencies are disallowed except to add harness support)
- [ ] Other

## Skill-change evidence (required for skill changes)

If this PR modifies any `SKILL.md` content, attach pressure-test evidence. "Compliance" edits without before-and-after evidence silently regress skill behavior. Format and procedure: see `docs/testing.md`.

- Scenario path in `tests/`:
- RED trace (agent behavior before the change - paste the relevant tool calls and outputs that show the agent rationalizing around the discipline):
- GREEN trace (agent behavior after the change - paste the corresponding tool calls and outputs showing compliance):
- Rationalization plugged (one or two sentences naming the specific shortcut the new text blocks):
- [ ] If this PR changes a load-bearing convention (terminology, iron law, hook wiring, manifest field), the matching `dev/` corpus file is updated.

## Iron-law compliance

- [ ] No production code without a failing test first
- [ ] No fixes without root-cause investigation first
- [ ] No completion claims without fresh verification evidence
- [ ] For surface-touching changes: no user-facing surface without an approved design artifact
- [ ] For surface-touching changes: no completion claims without fresh accessibility evidence

## Version and changelog

- [ ] `package.json` version bumped (see `scripts/bump-version.sh`)
- [ ] `CHANGELOG.md` entry added
- [ ] `RELEASE-NOTES.md` extended if this is a significant release

## Terminology check

- [ ] "Human partner" used throughout (not "user" or "client")
- [ ] "Discovery" (stage 1), not "Design"
- [ ] "Experience" (6b overlay), not "Frontend" / "UI"
- [ ] "UX artifact", not "mockup" / "wireframe"

## Additional notes

Anything a reviewer should know.
