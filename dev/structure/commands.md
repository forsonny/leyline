# `commands/` — slash commands

**Location:** `commands/` at the repo root.

## Current commands

- `brainstorm.md`
- `execute-plan.md`
- `write-plan.md`

## Role

Slash commands are intentionally minimal. They are thin redirectors that point users at the appropriate skill. The skill is the source of truth; the command is a convenience entry point.

## Example: `brainstorm.md`

```markdown
---
description: "Deprecated - use the leyline:brainstorming skill instead"
---

Tell your human partner that this command is deprecated and will be removed in the next major release. They should ask you to use the "leyline brainstorming" skill instead.
```

All three commands follow this pattern: a frontmatter `description` flagging the redirect, and a body telling the agent to steer the human partner toward the skill.

## Design rationale

- Skills activate automatically via their descriptions. Commands only matter when a user has a keyboard-muscle-memory habit of typing `/brainstorm` or `/execute-plan`.
- Keeping the command body minimal prevents drift from the canonical skill content.
- Deprecation copy in each command is a signal that the command surface is not where future behavior should be added.

## Related

- `structure/skills.md` — the source of truth for each command's redirect target
- `stages/01-discovery.md`, `stages/04-plan.md`, `stages/05-execute.md` — the skills the three commands redirect to
