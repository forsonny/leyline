# Persuasion principles

How skill language actually influences agent behavior. This is not prose-style advice; it is the patterns that produce compliance vs the patterns that produce rationalization.

## Thesis

Prose quality and behavior compliance are not correlated. A skill can read beautifully and fail under pressure; a skill can read terse and succeed. The patterns below are the shapes of text that produce compliance when an agent is under pressure to cut corners.

## The seven levers

### 1. Iron laws

Non-negotiable rules in fenced code blocks, phrased as absolutes. "NO PRODUCTION CODE WITHOUT A FAILING TEST FIRST" is an iron law. "Generally, prefer failing tests first" is not.

Mechanism: the absolute framing gives the agent no surface to negotiate. "Generally" invites "but this time"; "NO" does not.

### 2. Hard gates

Sentences that block a category of action until a condition is met. "Do NOT invoke any implementation skill... until the human partner has approved" is a hard gate.

Mechanism: the gate is syntactic. Until the condition resolves, the set of allowed actions is empty. The agent cannot talk itself past an empty set; it can only STOP or violate.

### 3. "Violating the letter..." preemption

A sentence that blocks the lawyering strategy: "Violating the letter of the rules is violating the spirit of the rules."

Mechanism: agents under pressure reach for technical workarounds that satisfy the iron law's text while bypassing its intent ("I satisfied 'failing test first' by writing a test that passes with one assertion, then wrote the real code"). The preemption blocks the entire strategy class, not each specific workaround.

### 4. Red-flags tables

Two-column tables mapping rationalizations → reality checks.

```
| Thought | Reality |
|---------|---------|
| "I already know what the answer is" | Then writing it down takes 90 seconds. Do it. |
```

Mechanism: the agent reaching for the rationalization in the left column encounters the exact phrase in the table. The table is a double-take device; the agent catches itself.

### 5. Named anti-patterns

Title Case in quotes with explanatory bodies. "This Is Too Simple To Need A Spec" is a named anti-pattern. "We shouldn't skip the spec on simple tasks" is not.

Mechanism: the name makes the rationalization recognizable. "I'm about to say 'this is too simple'" is the thought that triggers the agent's memory of the named anti-pattern. Without the name, the rationalization is fluid; with it, it has a label.

### 6. Announce-on-entry

A literal sentence the agent must emit on skill invocation, committing to a STOP behavior. "I'm using the brainstorming skill. I will not write code until you approve the spec."

Mechanism: the announce makes the commitment public. The agent who emits the sentence and then writes code without approval has contradicted themselves in-session; the contradiction is visible to the human partner.

### 7. Forbidden phrases

Explicit sentence fragments the agent must not emit. "You're absolutely right!" / "Let me implement that now" (before verification).

Mechanism: specific match surfaces. The agent reaching for the phrase hits the block. Broader prose prohibitions ("do not agree performatively") are less effective because the agent rationalizes by using a nearby phrase ("you make a great point" instead of "you're absolutely right").

## The weak shapes

These patterns do NOT produce compliance under pressure; do not rely on them.

### Soft-recommendation prose

"It's generally a good idea to write tests first." The agent reads this, agrees, and proceeds to write code first because "generally" ≠ "always."

### Abstract principles

"Verify before implementing." No concrete action; no specific match surface. The agent verifies what, how, when? Too open; rationalization fills the gap.

### Long example walkthroughs

"Here's how this should go: [12-paragraph example]." The agent reads the example, thinks "that's not my situation," and proceeds as if the example did not apply.

### Shame or negative appeals

"Bad agents skip this step." The agent reasons: "I'm not a bad agent, so I don't need to worry." Or: "I'm not bad, I just have a good reason to skip."

### Reliance on agent good-faith

"Be honest about what you verified." Agents under pressure rationalize honesty into "I reasoned about it, which is a form of verifying."

## Why Red Flags work (mechanism detail)

The Red Flags table's power comes from three simultaneous features:

1. **The rationalization is quoted**, so the agent reaching for the phrase encounters a text match (either explicit recognition: "that's the phrase from the skill" — or implicit: the phrase's appearance in the table triggers memory of the table's existence).
2. **The reality check is specific**, not abstract. "Then writing it down takes 90 seconds. Do it." is an action; "be rigorous" is not.
3. **The table is a list**, so the agent reading the skill skims past unfamiliar entries but notices familiar ones. The entries that match current rationalization get read more carefully.

This is why paraphrasing rationalizations weakens the table. The agent's reach for a specific phrase does not trigger on a paraphrase; the text match is literal.

## Why Forbidden Phrases work

Forbidden phrases are an even more specific match surface. They are the final-word block:

- Broad prose: "do not agree without verifying" → agent agrees in a way that avoids the specific word "agree."
- Red Flag: "Thought: The reviewer is probably right" → agent thinks this, reads the reality check, pauses.
- Forbidden phrase: "Do not say 'you're absolutely right!'" → agent literally cannot emit the phrase; must rephrase, which forces rethinking.

Use forbidden phrases for the highest-stakes rationalization tells. Use Red Flags for the rationalizations that are broader but still frequent. Use named anti-patterns for the rationalization categories that need names.

## Placement matters

The most load-bearing text is read first. Frontmatter description > announce-on-entry > iron law > hard gate > core principle > process > anti-patterns > red flags > forbidden phrases. Place the hardest blocks at the top; the tail sections catch the exceptions.

Corollary: never bury the iron law under a "context" section. The iron law is the first load-bearing text after the announce.

## The three failure modes of skill text

1. **Too abstract to bind** - soft recommendation, no specific action.
2. **Too narrow to generalize** - example that doesn't match this agent's situation.
3. **Too long to be read under pressure** - the agent skims, misses the load-bearing section.

Fixing (1) and (2) is writing; fixing (3) is editing. The best skills are short, specific, and front-loaded.

## Related

- `SKILL.md` - the invoking skill
- `../../dev/principles/behavior-shaping.md` - the thesis behind these patterns
- `testing-skills-with-subagents.md` - how to verify patterns actually work
- `anthropic-best-practices.md` - where Anthropic's guidance sits relative to these extensions
