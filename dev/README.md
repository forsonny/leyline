# Leyline Plugin — Developer Reference Corpus

This folder is a grep-friendly expansion of `../combined-workflow-prompt.md`. Each file is self-contained and keyword-dense so a future AI agent can locate relevant material by content search.

## Layout

```
dev/
├── README.md              (this file — folder map)
├── glossary.md            (terms used across the plugin)
├── stages/                (one file per pipeline stage, numbered)
├── structure/             (one file per top-level repository directory or artifact group)
├── principles/            (cross-cutting discipline: iron laws, behavior shaping, terminology, TDD-for-prose)
└── reference/             (format specs, hook wiring, harness matrix, diagram conventions)
```

## Stage files

| # | File | Skill(s) / co-skills / overlays |
|---|------|---------------------------------|
| 1 | [stages/01-discovery.md](stages/01-discovery.md) | brainstorming (1a), design-brainstorming (1b) |
| 2 | [stages/02-interrogate.md](stages/02-interrogate.md) | deep-discovery (2a), design-interrogation (2b, conditional) |
| 3 | [stages/03-isolate.md](stages/03-isolate.md) | using-git-worktrees |
| 4 | [stages/04-plan.md](stages/04-plan.md) | writing-plans |
| 5 | [stages/05-execute.md](stages/05-execute.md) | subagent-driven-development, executing-plans, dispatching-parallel-agents |
| 6 | [stages/06-discipline.md](stages/06-discipline.md) | Code Discipline (TDD, systematic-debugging, verification-before-completion); Experience Discipline (design-driven-development, accessibility-verification) |
| 7 | [stages/07-review.md](stages/07-review.md) | requesting-code-review, receiving-code-review, code-reviewer agent; requesting-design-review, receiving-design-review, design-reviewer agent |
| 8 | [stages/08-finish.md](stages/08-finish.md) | finishing-a-development-branch |

## Structure files

- [structure/skills.md](structure/skills.md)
- [structure/agents.md](structure/agents.md)
- [structure/hooks.md](structure/hooks.md)
- [structure/scripts.md](structure/scripts.md)
- [structure/commands.md](structure/commands.md)
- [structure/manifests.md](structure/manifests.md)
- [structure/docs.md](structure/docs.md)
- [structure/tests.md](structure/tests.md)
- [structure/metadata.md](structure/metadata.md)

## Principles files

- [principles/iron-laws.md](principles/iron-laws.md)
- [principles/behavior-shaping.md](principles/behavior-shaping.md)
- [principles/terminology.md](principles/terminology.md)
- [principles/tdd-for-prose.md](principles/tdd-for-prose.md)
- [principles/experience-discipline.md](principles/experience-discipline.md)

## Reference files

- [reference/skill-file-format.md](reference/skill-file-format.md)
- [reference/session-start-hook.md](reference/session-start-hook.md)
- [reference/harness-matrix.md](reference/harness-matrix.md)
- [reference/diagrams.md](reference/diagrams.md)
- [reference/surface-types.md](reference/surface-types.md)
- [reference/recommended-optional-tools.md](reference/recommended-optional-tools.md)

## How to search this corpus

- **Looking for a discipline or rule:** start in `principles/` and `stages/06-discipline.md`.
- **Looking for a file-format or wiring question:** start in `reference/`.
- **Looking for what a directory contains:** start in `structure/`.
- **Looking for "what happens when the session starts":** `stages/01-discovery.md`, `structure/hooks.md`, `reference/session-start-hook.md`.
- **Looking for a term:** `glossary.md`.
