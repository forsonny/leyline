# Release notes

Narrative companion to `CHANGELOG.md`. Significant releases get expanded notes here; minor and patch releases typically have only CHANGELOG entries.

## 1.0.0 - The full pipeline, end-to-end

**2026-04-17**

Leyline 1.0.0 ships the complete eight-stage developer-session pipeline across six harnesses: Claude Code, Cursor, Codex, OpenCode, GitHub Copilot CLI, and Gemini CLI. The scaffold is structurally complete; every stage has been built, deep-discovery reviewed, and hardened; every harness has an install path; the marketplace manifests are wired to self-host from `github.com/forsonny/leyline`.

### What ships

- **21 skills** covering every pipeline stage plus the meta-skill for contributors.
- **2 subagent definitions** (code-reviewer, design-reviewer) with harness-aware capability detection.
- **Session-start hook** wired for Claude Code and Cursor (POSIX + Windows launchers).
- **Marketplace manifests** for Claude Code / Cursor (`.claude-plugin/`), GitHub Copilot CLI (`.github/plugin/`), and Gemini CLI (`gemini-extension.json`).
- **4 sample pressure-test scenarios** demonstrating the contribution format.
- **Meta-skill `writing-skills`** with four supporting references (`testing-skills-with-subagents.md`, `anthropic-best-practices.md`, `persuasion-principles.md`, `graphviz-conventions.dot`) plus `render-graphs.js` tooling.

### Discipline enforced

- **Five iron laws** rendered as fenced code blocks with "Violating the letter..." preemption at every home skill.
- **Hard gates** at every pipeline stage with mechanical (grep-based) preconditions.
- **Verbatim completion markers** at every handoff (`Deep-discovery pass complete`, `Product spec approved`, `UX spec approved`, `Design-interrogation pass complete / skipped`, `Code review complete`, `Design review complete`, `Merged / Kept / Discarded`).
- **Forbidden-phrase lists** in every skill that blocks the specific rationalization tells a motivated agent reaches for under pressure.
- **Constructed-context rule** for every subagent dispatch; subagents never inherit parent-session history.

### Review cycle

Every stage went through a dedicated 100-question deep-discovery pass and a follow-up hardening release before the next stage was built. The result is ten hardening passes (0.0.5 through 0.9.5) and one meta-skill hardening pass (0.10.1) on top of the nine feature stages - all documented in `CHANGELOG.md` with counts of critical and important findings per stage. Representative examples:

- **Stage 2 hardening**: added verbatim `Deep-discovery pass complete - round <N> - YYYY-MM-DD` markers because session-state approval could not be grep'd by downstream stages.
- **Stage 5 hardening**: added approval markers to `brainstorming` and `design-brainstorming` upstream because Stage 5's Experience gate was unrunnable after a session boundary.
- **Stage 7 hardening**: shrunk agent frontmatter descriptions to fit Anthropic's 1024-character limit; moved multi-example exposition into agent bodies.
- **Stage 8 hardening**: moved the baseline note to the main repo so Option 4 (discard) could legitimately preserve it; added marker-invalidation rules so completion markers could not be written while findings were still open.
- **Stage 9 hardening**: added the meta-skill's own iron law and hard gate; added a self-reflexive scenario that tests the meta-skill against contributor-pressure.

### Known limitations

- **Trace-capture pending.** The four sample pressure-test scenarios ship with `Outcome: Pending` in each file. Actual RED/GREEN traces are captured by the first wave of users who install and exercise the plugin; contributor PRs that modify skills must carry their own captured traces per `.github/PULL_REQUEST_TEMPLATE.md`.
- **Worked examples directory empty.** `skills/writing-skills/examples/` has a placeholder README; concrete examples land incrementally as contributors save their captured traces in publishable form.
- **Non-Claude-Code harnesses unverified.** Install paths are wired for Cursor, Codex, OpenCode, Copilot CLI, and Gemini CLI. End-to-end behavioral verification in each harness is a post-1.0 activity; the per-harness install docs flag the primitive-availability caveats (notably `dispatching-parallel-agents` requiring concurrent subagent dispatch, which varies by harness).

### Upgrade from 0.10.x

Straight-line version bump. No breaking changes to skill names, descriptions, or successor chains; the 1.0.0 release marks structural completeness, not a rewrite. Users on 0.10.2 can bump to 1.0.0 with no action beyond reinstalling through the marketplace; the version numbers in the manifests are the only functional change.

### What's next

- **1.1.x**: Trace-capture releases — each minor version ships new Outcome sections in the sample scenarios as real harness sessions verify them.
- **1.x.x**: Harness-specific install verification - Cursor, Codex, OpenCode, Copilot CLI, Gemini CLI end-to-end confirmations.
- **2.0.0**: When the next-major Anthropic Agent SDK change requires breaking manifest or skill changes. Until then, 1.x is backward-compatible.

### Credits

Leyline is authored by [`forsonny`](https://github.com/forsonny) with contributions from the Leyline contributors community. Built on top of Anthropic's Claude Agent SDK skill-authoring conventions with opinionated extensions documented in `skills/writing-skills/anthropic-best-practices.md`.

---

## 0.1.0 - initial scaffold

The first committed state of the Leyline plugin. Directory layout, per-harness manifests, session-start hook wiring, and the `using-leyline` entry skill are in place. Pipeline-stage skills and subagent definitions were added in subsequent releases.
