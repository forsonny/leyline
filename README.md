# Leyline

**An opinionated developer-session workflow plugin for Claude Code, Cursor, Codex, OpenCode, GitHub Copilot CLI, and Gemini CLI.**

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](./LICENSE)
[![Version: 1.0.0](https://img.shields.io/badge/Version-1.0.0-green.svg)](./CHANGELOG.md)
[![Harnesses: 6](https://img.shields.io/badge/Harnesses-6-informational)](./dev/reference/harness-matrix.md)

Leyline encodes one coherent developer session from first message to merged branch as a deterministic pipeline of skills that hand off to each other in a fixed order. Every stage has an entry gate, a verifiable output, and an explicit successor. No stage silently skips. No completion claim ships without evidence. The iron laws are enforced at every handoff.

---

## What Leyline gives you

- **A full development pipeline.** Eight stages covering Discovery, Interrogate, Isolate, Plan, Execute, Discipline, Review, and Finish. Each stage's skill names its successor; nothing improvises.
- **Five iron laws enforced as code.** TDD, systematic debugging, verification-before-completion, design-driven-development, and accessibility-verification are not suggestions — they are hard gates that block downstream work when violated.
- **Fresh-subagent review per task.** Stage 5 dispatches a new subagent per task with up to four review passes (spec, quality, design when surfaces are touched), then hands off to Stage 7 for branch-level review with bias-free reviewer agents. Each subagent receives constructed context only.
- **Verifiable markers at every stage boundary.** Specs carry approval markers, plans reference spec rounds, baselines record worktree state, review logs carry completion markers. Downstream stages grep for markers; session-state promises do not pass.
- **Tool-agnostic accessibility and design review.** Harness-aware subagents use browser automation, a11y scanners, design-tool MCPs when present; fall back to structural review when absent. Zero runtime dependencies.
- **A meta-skill for contributors.** `writing-skills` enforces TDD-for-prose: baseline pressure test, write minimal rebuttal, verify, refactor. Every skill change requires traces.

---

## Pipeline at a glance

```
Human partner: "let's build X"
        |
        v
  [1] Discovery ........... brainstorming + design-brainstorming
        |                   approved product + UX specs
        v
  [2] Interrogate ......... deep-discovery + design-interrogation
        |                   100-question pressure tests; loop back on material revisions
        v
  [3] Isolate ............. using-git-worktrees
        |                   isolated branch workspace, green baseline
        v
  [4] Plan ................ writing-plans
        |                   2-to-5-minute tasks with exact paths, code, verification
        v
  [5] Execute ............. subagent-driven-development OR executing-plans
        |                   fresh subagent per task + up to 4 review passes
        v   <-- governed by [6] Discipline overlays:
        |       Code: TDD, systematic-debugging, verification-before-completion
        |       Experience: design-driven-development, accessibility-verification
        v
  [7] Review .............. requesting/receiving-code-review (+ design when surfaces)
        |                   code-reviewer and design-reviewer subagents
        v
  [8] Finish .............. finishing-a-development-branch
        |                   merge / PR / keep / discard
        v
  Pipeline terminates with evidence trail in docs/leyline/
```

---

## Install

Install commands for each supported harness. All paths resolve against `github.com/forsonny/leyline`.

### Claude Code

```
/plugin marketplace add forsonny/leyline
/plugin install leyline@leyline-marketplace
```

The first command registers this repo as a marketplace via `.claude-plugin/marketplace.json`. The second installs the plugin it lists.

### Cursor

Cursor consumes Claude Code-compatible plugins. Use the same marketplace add-and-install flow in Cursor's plugin interface, pointing at `https://github.com/forsonny/leyline`.

### GitHub Copilot CLI

```
copilot plugin marketplace add https://github.com/forsonny/leyline
copilot plugin install leyline
```

### Gemini CLI

```
gemini extensions install https://github.com/forsonny/leyline
```

### Codex (manual fetch)

```
git clone https://github.com/forsonny/leyline.git ~/.codex/plugins/leyline
```

Then follow [`docs/README.codex.md`](./docs/README.codex.md) for the config wiring.

### OpenCode (manual fetch)

```
git clone https://github.com/forsonny/leyline.git ~/.opencode/plugins/leyline
```

Then follow [`docs/README.opencode.md`](./docs/README.opencode.md) for the plugin shim and hook configuration.

### After install

Start a new session in your harness and ask for something that should trigger a skill:

> "help me plan a dashboard filters feature"

The agent should announce it is using Leyline and invoke `brainstorming`. If the session-start hook fired correctly, the agent's first response cites `using-leyline`. If not, see [Windows launcher notes](./docs/windows/launcher-notes.md) or the per-harness install doc.

---

## The five iron laws

Violating the letter of the rules is violating the spirit of the rules.

### Code Discipline (applies to every code change)

- `NO PRODUCTION CODE WITHOUT A FAILING TEST FIRST`
- `NO FIXES WITHOUT ROOT CAUSE INVESTIGATION FIRST`
- `NO COMPLETION CLAIMS WITHOUT FRESH VERIFICATION EVIDENCE`

### Experience Discipline (applies additionally to user-facing surface changes)

- `NO USER-FACING SURFACE WITHOUT AN APPROVED DESIGN ARTIFACT FIRST`
- `NO COMPLETION CLAIMS ON A USER-FACING SURFACE WITHOUT FRESH ACCESSIBILITY EVIDENCE`

Each iron law has a home skill that enforces it procedurally (`test-driven-development`, `systematic-debugging`, `verification-before-completion`, `design-driven-development`, `accessibility-verification`).

---

## What's inside

| Directory | Contents | Count |
|-----------|----------|-------|
| `skills/` | Behavior-shaping skill library (flat namespace) | 21 skills |
| `agents/` | `code-reviewer.md` and `design-reviewer.md` subagent definitions | 2 agents |
| `hooks/` | Session-start wiring for Claude Code and Cursor (POSIX + Windows launchers) | 4 files |
| `scripts/` | Release and maintenance helpers (bump-version, stage-0 self-test, manifest-sync lint, test-runner) | 4 scripts |
| `commands/` | Slash-command redirectors to skills | 3 commands |
| `docs/` | Install guides, spec archive, plan archive, design archive | Per-harness guides |
| `tests/` | Pressure-test scenarios verifying skill compliance | 4 scenarios |

Per-harness manifest files (`CLAUDE.md`, `AGENTS.md`, `GEMINI.md`, `gemini-extension.json`, `.claude-plugin/`, `.github/plugin/`) live at the repo root.

### Full skill inventory

| Stage | Skills |
|-------|--------|
| Entry | `using-leyline` |
| 1 - Discovery | `brainstorming`, `design-brainstorming` |
| 2 - Interrogate | `deep-discovery`, `design-interrogation` |
| 3 - Isolate | `using-git-worktrees` |
| 4 - Plan | `writing-plans` |
| 5 - Execute | `subagent-driven-development`, `executing-plans`, `dispatching-parallel-agents` |
| 6 - Discipline | `test-driven-development`, `systematic-debugging`, `verification-before-completion`, `design-driven-development`, `accessibility-verification` |
| 7 - Review | `requesting-code-review`, `receiving-code-review`, `requesting-design-review`, `receiving-design-review` |
| 8 - Finish | `finishing-a-development-branch` |
| Meta | `writing-skills` |

---

## Verification evidence

Every shipped stage went through a dedicated deep-discovery review (100-question adversarial interrogation) and a follow-up hardening pass before the next stage was built. Nine deep-discovery reviews total, nine hardening passes, nine CHANGELOG entries documenting the findings and fixes. The review/fix cycle produced:

- 40+ critical issues identified and resolved across the stages.
- 120+ important issues identified and resolved.
- Verbatim completion markers (`Deep-discovery pass complete - round N - YYYY-MM-DD`, `Product spec approved - round N - YYYY-MM-DD`, `Code review complete - round N - YYYY-MM-DD`, etc.) replacing session-state promises at every handoff.
- Mechanical grep-based preconditions at every stage entry, replacing judgment-only gates.

The four sample pressure-test scenarios under `tests/skill-triggering/` demonstrate the format for contributor-added tests.

---

## Contributing

Read [`CLAUDE.md`](./CLAUDE.md) before opening a PR. Skills are behavior-shaping code, not prose; modifications require before-and-after pressure-test evidence per the [`writing-skills`](./skills/writing-skills/SKILL.md) meta-skill's TDD-for-prose methodology. The full rules, including the 15-section mandatory skill structure, live in `writing-skills/SKILL.md`.

PRs without the required skill-change-evidence section completed are closed unreviewed per [`.github/PULL_REQUEST_TEMPLATE.md`](./.github/PULL_REQUEST_TEMPLATE.md).

---

## Learn more

- [`RELEASE-NOTES.md`](./RELEASE-NOTES.md) - narrative release notes for significant versions
- [`CHANGELOG.md`](./CHANGELOG.md) - complete change history
- [`combined-workflow-prompt.md`](./combined-workflow-prompt.md) - the top-level specification the plugin was built from
- [`dev/`](./dev/) - reference corpus expanding every stage, structure, principle, and convention
- [`docs/testing.md`](./docs/testing.md) - testing methodology
- [`dev/reference/harness-matrix.md`](./dev/reference/harness-matrix.md) - per-harness feature availability

---

## License

MIT. See [`LICENSE`](./LICENSE).
