# Behavior-shaping content

## Thesis

Prose documentation alone does not stop coding agents from cutting corners. Agents default to rushing, guessing, and skipping discipline. Skills are therefore written as behavior-shaping code, not reference prose. Every word is chosen to survive adversarial rationalization under pressure.

Correctness criterion: "Does a fresh agent, in a fresh session, under pressure, actually follow the process?" not "Does the markdown read well?"

## Primary mechanisms

### 1. Iron Laws

Non-negotiable rules in fenced code blocks, phrased as absolutes. See `principles/iron-laws.md`.

### 2. Hard Gates

Sentences that block a category of action until a condition is met. Example (brainstorming): "Do NOT invoke any implementation skill, write any code, scaffold any project, or take any implementation action until you have presented a design and the user has approved it."

### 3. "Violating the letter is violating the spirit"

A sentence that preempts lawyering. Agents tempted to find technical workarounds are blocked from that entire strategy.

### 4. Red Flags tables

Two-column tables mapping **rationalizations** the agent is about to use → **reality checks** that block them.

**Standard column pair:** `Thought` / `Reality`.

Example from `using-superpowers`:

| Thought | Reality |
|---------|---------|
| "This is just a simple question" | Questions are tasks. Check for skills. |
| "I need more context first" | Skill check comes BEFORE clarifying questions. |
| "Let me explore the codebase first" | Skills tell you HOW to explore. Check first. |
| "I can check git/files quickly" | Files lack conversation context. Check for skills. |
| "This doesn't need a formal skill" | If a skill exists, use it. |
| "I remember this skill" | Skills evolve. Read current version. |
| "This doesn't count as a task" | Action = task. Check for skills. |
| "The skill is overkill" | Simple things become complex. Use it. |
| "I'll just do this one thing first" | Check BEFORE doing anything. |

### 5. Anti-pattern naming

Named rationalizations like "This Is Too Simple To Need A Design" — giving the bad pattern a name makes it recognizable when the agent catches itself about to do it.

### 6. Announce-on-entry

Each skill starts with a literal sentence the agent must say on invocation (e.g., "I'm using the writing-plans skill to create the implementation plan."). This forces explicit commitment and makes skill use visible to the human partner.

### 7. Successor-naming

Each skill names its terminal successor skill. This prevents agents from "finishing" in a way that skips downstream discipline (e.g., brainstorming that terminates by writing code instead of invoking `writing-plans`).

### 8. Forbidden phrases

Explicit list of phrases the agent must not emit. Example (receiving-code-review):
- "You're absolutely right!"
- "Great point!" / "Excellent feedback!"
- "Let me implement that now" (before verification)

### 9. Subagent isolation for bias-free review

Code reviewers are dispatched as fresh subagents with constructed context so they cannot be influenced by the parent agent's rationalizations or prior framing.

## Common rationalizations the library rebuts

- "This is too simple" — addressed by the brainstorming hard gate
- "Just this once" — addressed by iron-law absolutism
- "I already know this" — addressed by "Skills evolve. Read current version."
- "I need more context first" — addressed by "Skill check comes BEFORE clarifying questions."
- "I'll verify after" — addressed by verification-before-completion's "this message" clause
- "The error message is wrong" — addressed by systematic-debugging's "Read it again"
- "Let me implement that now" — addressed by receiving-code-review's response pattern
- "This is just a CLI / library / internal tool, no UX needed" — addressed by `design-brainstorming`'s anti-patterns and the `Surfaces` field (most libraries are `developer-facing`, not `none`)
- "The product spec already covers UX" — addressed by `design-brainstorming` (product spec says *what*; UX spec says *how it is experienced*)
- "I'll design as I code" — addressed by the `design-driven-development` iron law
- "Accessibility can come later" — addressed by the `accessibility-verification` iron law
- "I know what looks good" — addressed by DRAW-BUILD-RECONCILE (the artifact is the source of truth, not taste)
- "The artifact is out of date, I'll use my memory" — addressed by the DRAW step ("confirm artifact is current")
- "It renders fine on my machine" — addressed by the accessibility-verification claim table
- "That's just taste" — addressed by `receiving-design-review`'s forbidden phrases
- "We did Design (stage 1), we're done with UX" — addressed by the Discovery/Design terminology split and the Experience Discipline overlay

## Related

- `principles/iron-laws.md`
- `principles/terminology.md`
- `principles/tdd-for-prose.md` — how these mechanisms are introduced and tested
- `structure/tests.md` — how compliance is verified
