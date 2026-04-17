# Leyline subagent definitions

This directory holds specialized subagent definitions dispatched by stage-7 review skills.

## Planned files (Stage 7)

- `code-reviewer.md` - Senior Code Reviewer. Dispatched by `requesting-code-review` and by `subagent-driven-development`'s code-quality review pass. Categorizes findings as Critical / Important / Suggestions.
- `design-reviewer.md` - Senior Experience Reviewer. Dispatched by `requesting-design-review` and by `subagent-driven-development`'s third review pass when a task touches a user-facing surface. Harness-aware: uses available browser-automation, design-tool, and a11y-scanner MCPs when present; falls back to structural review otherwise.

## Why subagents

Subagents receive constructed context rather than inheriting the parent session, which keeps reviewers free of the parent agent's rationalizations and prior framing. See `dev/principles/behavior-shaping.md` and `dev/structure/agents.md`.

## Status

Empty until Stage 7 lands. Manifests at the repo root reference this directory; that is intentional - the directory is structurally part of the skeleton even before any subagent files exist.
