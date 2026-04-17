# Load-bearing terminology

Terms used with deliberate consistency across the plugin. Substituting a near-synonym changes the agent's behavior; these are not interchangeable.

## Core terms

### "human partner"

The person collaborating with the agent. Not "user." Not "human." Not "client."

**Why it matters:** "User" positions the human as an operator of a tool; "human partner" positions them as a collaborator. The plugin's workflow assumes collaboration (clarifying questions, approval gates, review). The term carries that frame into every skill.

### "iron law"

A non-negotiable rule. Not "guideline," not "best practice," not "strong recommendation."

**Why it matters:** An iron law signals that the agent should not look for exceptions. Softer framings invite "just this once."

### "violating the letter of the rules is violating the spirit of the rules"

Appears verbatim near most iron laws and several hard gates.

**Why it matters:** Blocks a specific class of rationalization where an agent satisfies the textual rule while bypassing its intent.

### "your enthusiastic junior engineer"

The audience assumption for implementation plans: an enthusiastic junior engineer with poor taste, no judgement, no project context, and an aversion to testing.

**Why it matters:** This assumption forces plans to include exact paths, complete code, and verification steps. A plan that assumes context won't survive execution by a fresh subagent.

### "Discovery" (stage 1)

The name of stage 1. Replaces an earlier "Design" label to disambiguate from UI/UX design.

**Why it matters:** "Design" is reserved for UI/UX/IA/visual/interaction design across the plugin. Stage 1 is about *product discovery* — what to build and why. Conflating the two is the source of the "we did Design, we're done with UX" rationalization.

### "Experience" (overlay)

The name of the 6b overlay. Covers interaction, state completeness, accessibility, voice, and platform appropriateness. Mirrors "Code" for implementation concerns.

**Why it matters:** "Experience" includes flows, states, a11y, and voice — not just pixels. Framing as "frontend" or "UI" would lose the flows/states/voice dimensions.

### "UX artifact"

Any markdown artifact produced by `design-brainstorming` — UX spec, state matrix, accessibility audit. Not a mockup. Not a wireframe.

**Why it matters:** "Mockup" and "wireframe" are visual-centric; "UX artifact" includes flows, state matrices, voice examples, accessibility targets — things markdown captures well and images don't.

### "design did not lie"

The DRAW-BUILD-RECONCILE claim that the implementation matches the artifact. Analog of "tests pass" for UX.

**Why it matters:** "Matches the mockup" doesn't capture state completeness or flow correctness. "Design did not lie" names the full set of claims the artifact makes — all of them must hold.

## Structural terms

- **skill** — a markdown file with YAML frontmatter that shapes agent behavior, activated by description match
- **subagent** — a fresh agent dispatched with constructed context; never inherits parent session
- **worktree** — isolated git workspace on a new branch
- **spec** — design document written by `brainstorming`
- **plan** — task-level implementation document written by `writing-plans`
- **pressure test** — a scenario used to verify a skill changes agent behavior (see `principles/tdd-for-prose.md`)

## Pipeline terms

- **stage** — one ordered step of the developer-session pipeline
- **co-skill** — two skills running at the same stage (1a/1b Discovery, 2a/2b Interrogate), each with its own approval gate; successor is always the next stage, not the sibling
- **handoff** — the transition between stages, named explicitly by the outgoing skill
- **overlay** — a discipline that applies throughout a stage rather than being its own stage (Code Discipline and Experience Discipline both applying during Execute)
- **successor** — the next skill explicitly named by the outgoing one

## Banned substitutions

| Correct | Wrong | Reason |
|---------|-------|--------|
| human partner | user | loses collaborative framing |
| iron law | guideline / rule | invites exceptions |
| skill | command / policy | loses the trigger-by-description contract |
| subagent | agent (when distinct from self) | loses the isolation-by-construction meaning |
| pressure test | unit test / integration test | loses the adversarial framing |
| Discovery (stage 1) | Design (stage 1) | "Design" now means UI/UX exclusively |
| Experience (overlay) | Frontend / UI | includes flows, states, a11y, voice — not just pixels |
| UX artifact | mockup / wireframe | includes flows, states, matrices — not just visuals |
| design did not lie | mockup matches | matches the "evidence over claims" frame |

## Related

- `principles/behavior-shaping.md` — why terminology is treated as load-bearing
- `principles/iron-laws.md` — where "iron law" lives
- `CLAUDE.md` (repo root) — the contributor guidelines explicitly name "human partner" as deliberate and not interchangeable with "the user"
