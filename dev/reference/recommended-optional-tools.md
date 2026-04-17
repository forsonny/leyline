# Recommended optional tools

The plugin is zero-dependency. **Nothing in this list is required.** These are tools a user may install to deepen the fidelity of design review, accessibility verification, or visual-regression checking. The `design-reviewer` subagent inspects its harness at dispatch time and uses whichever of these are available; when none are present, it falls back to structural review based on code reading and spec comparison.

## Browser automation

- **Claude-in-Chrome** (MCP) — direct browser control from Claude Code
- **Playwright MCP** — scripted browser automation across harnesses

**Used by `design-reviewer` for:** flow walkthroughs, state triggering, keyboard-navigation testing, screenshot capture, focus-order verification.

## Design-tool MCPs

- **Figma MCP** — read design files, extract component specs, diff against implementations
- **Pencil MCP** — read `.pen` design files
- **Penpot MCP** (when available) — read Penpot files

**Used by `design-reviewer` for:** artifact-vs-implementation comparison when the UX artifact lives in a tool rather than markdown. Not required; markdown artifacts (ASCII wireframes, state matrices, flow descriptions) are sufficient for the `design-driven-development` iron law.

## Accessibility

- **axe-core** (CLI, npm, or MCP) — automated a11y scanning
- **Lighthouse** (CLI) — performance + a11y audits
- **WAVE** (browser extension) — visual a11y reporting
- **pa11y** — command-line a11y testing

**Used by `accessibility-verification` for:** fresh a11y evidence. Any of these satisfies the iron law's "readable output" requirement. A manual keyboard/screen-reader walkthrough documented in-message also satisfies the iron law; automated tools just make it faster.

## Visual regression

- **Percy** — visual snapshot CI
- **Chromatic** — Storybook-integrated visual testing
- **BackstopJS** — self-hosted visual regression
- **Playwright snapshot assertions** — lightweight visual diffs

**Used by `design-reviewer` for:** visual-fidelity review when budget allows. Structural review remains the default.

## Component documentation

- **Storybook** — component catalog and states
- **Ladle** — lightweight Storybook alternative

**Used by `design-brainstorming` and `design-reviewer` for:** per-component state enumeration, cross-checking the state matrix.

## Harness-native capabilities

Some harnesses ship tools that subsume parts of the above:
- **Claude Code** — Claude-in-Chrome MCP, Pencil MCP, Mermaid Chart MCP available by default if enabled
- **Cursor** — browser + design tool integrations via MCP
- **Gemini CLI, Copilot CLI, Codex, OpenCode** — varying native tool support

The `design-reviewer` subagent enumerates available tools at dispatch and adapts. No pre-declaration needed.

## Detection flow

```
design-reviewer invoked
  ↓
list available tools in the current harness
  ↓
map tools to review capabilities:
  • browser automation → flow walkthrough
  • a11y scanner → accessibility assessment
  • design-tool MCP → artifact diff
  • snapshot tool → visual fidelity
  ↓
if a capability has no tool, fall back to structural review for that block
  ↓
run review and return structured findings
```

## Zero-dependency guarantee

- The plugin ships no dependencies on any of these tools.
- Skills reference them as *may* / *if available*, never as requirements.
- A pipeline run with none of these tools present is still valid; the Experience Discipline iron laws are still enforceable via markdown artifacts and manual in-message walkthroughs.

## Related

- `stages/07-review.md` — where these tools are consumed
- `stages/06-discipline.md` — `accessibility-verification` uses them when present
- `principles/experience-discipline.md`
- `reference/harness-matrix.md`
