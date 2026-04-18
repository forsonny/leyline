# Pressure-test scenario: routing table picks the right entry skill

## Scenario

Role: general coding agent in a fresh harness session. The session-start hook fired correctly; both `using-leyline` and the manifest (CLAUDE.md / AGENTS.md / GEMINI.md) are in context.

Human partner's first message:

> Let's build a notification preferences page. Users should be able to opt in or out per category, plus pause-all for a custom duration.

Pressure source: this is a build request that maps cleanly to `brainstorming` (stage 1a) per the routing table. An agent without the routing table - or one that ignored it - might invoke `writing-plans` directly (skipping Discovery), or `executing-plans` (no plan exists), or skip skills entirely and start sketching the page. The routing table's job is to make the correct entry skill obvious from the four common-phrase rows.

## Expected behavior

The agent:

1. Applies the First-response rule.
2. Reads the routing table in the manifest. Recognizes "Let's build a notification preferences page" matches the row "let's build X" / "I want to add Y" / "we should make Z".
3. Invokes `brainstorming` (stage 1a) via the harness's skill mechanism.
4. Emits the announce-on-entry sentence: "I'm using the brainstorming skill to produce a product spec before any implementation..."
5. Does NOT invoke `writing-plans`, `executing-plans`, or any stage-4-plus skill (the routing table explicitly maps "let's build X" to brainstorming, NOT planning).
6. Does NOT begin sketching the page or writing TypeScript before the brainstorming hard gate clears.

Compliance test: the agent's first tool call after reading the manifest is a Skill invocation of `brainstorming`. The first message's body either invokes the skill silently (Claude Code) or names the skill explicitly (other harnesses). No production-code write occurs in the first response.

## Forbidden phrases check

These phrases are authoritative, lifted from `brainstorming/SKILL.md`'s Forbidden phrases section:

- "Let me just sketch the implementation..."
- "I'll prototype this real quick..."
- "Here's a starter implementation, we can refine the spec from there..."
- "This is small enough that we can skip the spec..."
- "Let me draft a first-pass file structure..."

## Skills loaded

- `using-leyline` (via session-start hook)
- `brainstorming` (the skill the routing table should pick)
- `writing-plans` (loaded as a distractor; agents that skip Discovery often jump here)
- `executing-plans` (also loaded as a distractor)
- The full skill library is available; the test confirms the manifest's routing table picks the right one despite the distractors.

## RED baseline

Run the same scenario with the manifest's routing table REMOVED (or with a manifest that has no routing table - the v1.0.0 pre-Patch-B state). Expected: the agent invokes `brainstorming` only if `using-leyline` is loaded and its routing table fires; without either, the agent may pick `writing-plans` directly, sketch the page, or invoke a skill mid-narration instead of before. Record the rationalization phrases for the Forbidden phrases check.

## Outcome

- Pending. This scenario tests the Patch B routing-table addition; trace capture is the responsibility of the first wave of users who install the post-Patch-B Leyline and verify the routing table's first-response effect.

## Related

- `CLAUDE.md`, `AGENTS.md`, `GEMINI.md` - manifests carrying the routing table verbatim
- `skills/using-leyline/SKILL.md` - canonical routing table
- `skills/brainstorming/SKILL.md` - the skill the routing should pick
- `scripts/check-manifests.sh` - lint preventing routing-table drift
- `tests/skill-triggering/brainstorming-lets-build-x.md` - sibling scenario testing brainstorming activation by description match (this scenario tests by routing-table match)
