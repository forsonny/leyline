# Skill file format

Every skill is a folder under `skills/` containing a `SKILL.md` file plus optional supporting material.

## Required structure

```
skills/
  <skill-name>/
    SKILL.md               # required
    <supporting-files>     # optional
    scripts/               # optional (skill-local helpers)
    examples/              # optional
```

**Flat namespace.** All skills live directly under `skills/` — no nested categories.

## `SKILL.md` frontmatter (YAML)

Two required fields:

- `name`
- `description`

Full frontmatter block example:

```yaml
---
name: brainstorming
description: "You MUST use this before any creative work - creating features, building components, adding functionality, or modifying behavior. Explores user intent, requirements and design before implementation."
---
```

## Field rules

### `name`

- Letters, numbers, and hyphens only
- No parentheses, no special characters
- Lowercase by convention
- Matches the folder name

### `description`

- Third-person
- Describes ONLY **when to use** — not what it does
- Start with "Use when..." to focus on triggering conditions
- This field drives automatic activation; the agent picks the skill whose description matches the situation

### Total frontmatter limit

- **1024 characters maximum** total frontmatter (including the `---` delimiters)
- Anything longer is truncated by the harness before the skill even loads

## Body structure (convention, not required)

Most skills follow this shape:

1. **Overview / core principle** — one sentence thesis
2. **Iron law** (if applicable) — fenced code block
3. **"Violating the letter..."** preemption (if applicable)
4. **When to use** — decision diagram in DOT
5. **Process flow** — DOT diagram or numbered steps
6. **Checklist** — numbered, actionable
7. **Anti-patterns** — named bad behaviors
8. **Red Flags table** — rationalizations → reality checks
9. **Announce-on-entry sentence** — literal phrase the agent emits
10. **Successor skill** — named explicitly

## Supporting-file policy

Separate files for:
1. Heavy reference content (100+ lines) — API docs, comprehensive syntax
2. Reusable tools — scripts, utilities, templates
3. Subagent prompt templates — e.g., `implementer-prompt.md`, `spec-reviewer-prompt.md`

Keep inline:
- Principles and concepts
- Short code patterns (<50 lines)
- Everything else

## Personal skills

Personal (user-specific) skills live outside the plugin:
- Claude Code: `~/.claude/skills`
- Codex: `~/.agents/skills/`

These are not shipped by the plugin; they are local to each installation.

## Related

- `principles/tdd-for-prose.md` — authoring methodology
- `principles/behavior-shaping.md` — why the body structure is standardized
- `structure/skills.md` — library inventory
- `reference/diagrams.md` — DOT conventions for the diagram sections
