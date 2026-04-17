# Anthropic skill-authoring best practices

Cross-reference guide mapping Anthropic's official Claude Agent SDK and skill-authoring guidance to Leyline's opinionated extensions. Where the two diverge, Leyline's extensions are the standard for contributions to this plugin.

> **Review status.** Last reviewed against Anthropic docs: 2026-04-17. Anthropic's official guidance evolves; the specific claims below (frontmatter limits, skill activation mechanics, subagent description rules) are accurate as of that date. When the underlying docs change, update this file AND bump the review date in the same commit. Stale drift is a finding at the next deep-discovery pass.
>
> Source references (retrieved 2026-04-17):
> - Claude Code subagents documentation
> - Claude Agent SDK skill-authoring best practices
> - Anthropic engineering blog posts on skill and agent design

## Frontmatter

**Anthropic's guidance:**

- `name`: lowercase, hyphen-separated.
- `description`: third-person, describes when to use, under 1024 characters.
- Optional: `model: inherit` for subagents.

**Leyline's extensions:**

- `description` must start with "Use when..." per `dev/reference/skill-file-format.md`.
- Total frontmatter (including `---` delimiters) under 1024 bytes. Enforced by `scripts/check-stage-0.sh`.
- For subagents (`agents/*.md`), the description also has a 1024-character ceiling per Anthropic docs; exceeding it causes harness truncation. Move multi-example exposition into the body.

## Body structure

**Anthropic's guidance:**

- Clear structure with headings.
- Decision-oriented content.
- Examples where helpful.

**Leyline's extensions:**

Every pipeline-stage skill has 15 mandatory body sections in a fixed order. See `SKILL.md` "Mandatory body sections". The structure is itself a behavior-shaping contract: missing sections are missing defenses.

Overlay skills and reference files have reduced section requirements.

## Tool naming

**Anthropic's guidance:**

- Skills use the harness's tool names.
- Claude Code, Codex, OpenCode, Copilot CLI, Gemini CLI have different tool names.

**Leyline's extensions:**

- Skills are authored against Claude Code tool names (`Read`, `Edit`, `Skill`, `TodoWrite`, `Task`).
- Non-CC harnesses substitute via the mapping tables at `skills/using-leyline/references/{codex,copilot}-tools.md` and the `GEMINI.md` manifest.
- Skills do not hand-convert tool names; the harness's entry manifest provides the mapping context.

## Skill activation

**Anthropic's guidance:**

- Skills activate when the agent's description matches the situation.
- Activation is probabilistic; descriptions should be specific enough to avoid false matches.

**Leyline's extensions:**

- The 1%-threshold rule: if there is even a 1% chance a skill applies, invoke it. Blocks "let me check first" deferrals.
- Announce-on-entry: every skill requires the agent to emit a literal sentence on invocation, committing to STOP behavior on precondition failure.
- Hard gates with "Violating the letter..." preemption block rationalizations that would pass under softer framings.

## Anti-pattern discipline

**Anthropic's guidance:**

- Examples and anti-examples help the model learn the intended behavior.

**Leyline's extensions:**

- Anti-patterns are named in Title Case with quoted rationalization phrases. The name itself is behavior-shaping; agents who catch themselves thinking an anti-pattern's rationalization recognize the name.
- Forbidden phrases block specific performative-agreement and rationalization tells. They are the cheapest, most specific form of behavior shaping.
- Red-flags tables pair the agent's rationalization with a reality check; the table's job is to produce a double-take when the agent reaches for the rationalization.

## Testing

**Anthropic's guidance:**

- Test skills by running scenarios and observing behavior.

**Leyline's extensions:**

- TDD-for-prose: baseline pressure test WITHOUT the skill, then write the minimal skill text that rebuts the observed rationalizations, then verify, then refactor against new rationalizations.
- Pressure-test traces (RED and GREEN) are mandatory for PR submission when the change is content-level.
- See `testing-skills-with-subagents.md` for scenario structure and trace format.

## Zero-dependency guarantee

**Anthropic's guidance:**

- Plugins may declare dependencies.

**Leyline's extensions:**

- No runtime dependencies except to add a new harness. Optional tools (axe-core, Lighthouse, Playwright) are detected by the relevant agent at dispatch and used when present; falls back to structural review when absent.
- No domain-specific skills. Those belong in separate plugins that extend Leyline.

## Skill-personality guidance

**Anthropic's guidance:**

- Skills can adopt personas to match their expertise area.

**Leyline's extensions:**

- Skills have no persona. They are procedural discipline, not voice.
- Subagent definitions (agents/*.md) DO adopt a persona ("Senior Code Reviewer", "Senior Experience Reviewer") because the persona shapes the review's rigor.

## When Anthropic's guidance and Leyline's extensions diverge

Leyline's extensions are the standard for contributions to this plugin. Specifically:

- 15 mandatory sections vs Anthropic's flexible structure: use Leyline's.
- 1%-invoke threshold vs Anthropic's "when relevant": use Leyline's.
- Verbatim completion markers (in review logs, specs) vs Anthropic's session-state approval: use Leyline's.
- TDD-for-prose with RED/GREEN/REFACTOR vs Anthropic's "test the skill": use Leyline's.

Contributions that follow Anthropic's looser guidance but diverge from Leyline's are rejected per `CLAUDE.md`.

## Related

- `SKILL.md` - the invoking skill
- `../../dev/reference/skill-file-format.md` - canonical file-format rules
- `../../dev/principles/behavior-shaping.md` - why the extensions exist
- `testing-skills-with-subagents.md` - pressure-testing methodology
- `persuasion-principles.md` - how skill language shapes agent behavior
- `graphviz-conventions.dot` - DOT conventions for in-skill diagrams
