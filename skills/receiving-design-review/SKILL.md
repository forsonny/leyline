---
name: receiving-design-review
description: Use when receiving design review feedback, before implementing any UX or accessibility suggestion. Drives the same READ -> UNDERSTAND -> VERIFY -> EVALUATE -> RESPOND -> IMPLEMENT pattern as receiving-code-review, with additional forbidden phrases that block UX-specific performative agreement and taste-based dismissal.
---

## Announce on entry

> I'm using the receiving-design-review skill. I will not implement any finding until I have read, understood, verified, evaluated, and responded to it explicitly. UX feedback is not taste; it is evidence against the spec.

## Core principle

Verify before implementing. Ask before assuming. Technical correctness over social comfort. UX feedback is evidence against the spec, not a matter of taste.

The design-review version of performative agreement sounds different from the code-review version. "Good catch on the UX!" and "let me polish that now" sound warm; they are the moves that let a surface ship without its empty state re-designed. "That's just taste" and "I prefer it the way it was" sound technically-serious; they are the moves that let UX findings get dismissed because the author disagrees with the reviewer's sensibility. Both patterns bypass verification.

## Hard gate

```
Do NOT implement or dismiss any design-review finding until all preconditions
are satisfied: (1) the finding has been READ in full, (2) its technical claim
has been UNDERSTOOD and restated in plain English, (3) the claim has been
VERIFIED against the UX spec AND the implementation (not taken on the
reviewer's authority, not dismissed by taste), (4) the proposed fix or the
push-back has been EVALUATED against alternatives, AND (5) a RESPONSE has
been recorded. If any step has not happened, the finding is not ready to
implement or dismiss. This applies to EVERY design review from EVERY reviewer
regardless of seniority, tool, or time pressure.
```

> Violating the letter of the rules is violating the spirit of the rules.

## The six-step response pattern (shared with `receiving-code-review`)

Applied to each finding one at a time.

1. **READ** the full finding.
2. **UNDERSTAND** by restating the technical claim in your own plain English. If you cannot restate, STOP and ask.
3. **VERIFY** against the UX spec and the implementation. UX findings verify differently from code findings: the reference is the UX artifact at `docs/leyline/design/<feature-name>-ux.md`, not the code.
4. **EVALUATE** the proposed fix against alternatives, including "update the UX spec instead of the implementation" when the spec itself is the source of the issue.
5. **RESPOND** with decision + reasoning. Three valid responses (same as code review): accept-and-implement; push-back; defer-with-tracking.
6. **IMPLEMENT** only if decision is accept. For surface-touching fixes, the normal Experience Discipline applies: DRAW-BUILD-RECONCILE in `design-driven-development`, fresh a11y evidence in `accessibility-verification`.

## Design-review-specific verification

### "Verify against the UX spec" means

- Open the UX spec. Read the section the reviewer cites (or the section the finding implies).
- Check the state matrix for the named surface. Does the cell the finding targets have the content the finding references?
- If the cell is `N/A - <reason>`, the finding may be targeting a state that does not exist on this surface; that is itself a finding worth recording.
- If the cell is concrete but the implementation differs, the reviewer is usually right: the implementation drifted.

### "Verify against the implementation" means

- Trigger the state or flow the finding names. Actually trigger it; do not reason from the code.
- For a11y findings, re-run the accessibility check the finding references. If the finding names a focus trap, trigger the focus trap with Tab / Shift+Tab and observe.
- If the finding references voice or copy, read the copy out loud. Ambient reading often catches issues eyes skim past.

## Forbidden phrases

Extends `receiving-code-review`'s list with UX-specific performative-agreement and taste-dismissal phrases:

**From `receiving-code-review`:**
- "You're absolutely right!"
- "Great point!" / "Excellent feedback!"
- "Let me implement that now" (before verification)

**Additional for design review:**
- "Good catch on the UX!"
- "Let me polish that now" (before verification)
- "That's just taste" (used to dismiss a finding without verification)
- "I prefer it the way it was" (as a response, without verification)
- "The reviewer isn't the designer" (seniority-based dismissal)
- "Design is subjective anyway" (category-based dismissal)
- "Marking deferred findings acknowledged since it's standard"
- "Appending the ack line on their behalf; it's routine"

The "taste" phrases are the design-review analog of "senior engineer said" in code review: an attempt to end the discussion without verification. UX findings are evidence against the spec; the spec is not taste. If a finding targets the spec, update the spec (with re-approval via `design-brainstorming`). If a finding targets the implementation, update the implementation.

## Checklist

For each finding:

1. Read it fully.
2. Restate the technical claim in plain English.
3. If unclear, stop and ask.
4. Verify against the UX spec.
5. Verify against the implementation (trigger the state, re-run the check).
6. If the reviewer is wrong, push back with reasoning AND cite the spec section that supports the push-back.
7. If the reviewer is right, evaluate: fix the implementation, OR update the spec (with re-approval).
8. Respond with the decision and reasoning.
9. If the decision is to fix the implementation, run DRAW-BUILD-RECONCILE + accessibility-verification (Experience Discipline is mandatory for surface fixes).
10. If the decision is to update the spec: SUSPEND Stage 7 entirely, loop back to `design-brainstorming` to update the UX spec and re-obtain approval, then re-invoke `requesting-design-review` against the new UX spec. Discard the prior design-review report's remaining findings: they were issued against the superseded spec, so even the ones that still appear valid must be re-generated by the re-dispatched reviewer. Do not continue processing other findings from the old report while a spec update is pending; that invalidates the report's baseline.

### Push-back on Critical (design-review specific)

For Critical design findings, push-back is not a one-way record: either (a) re-dispatch `agents/design-reviewer.md` with the original inputs plus your push-back reasoning spliced in and record the reviewer's response; OR (b) escalate to the human partner with the finding and your reasoning, and record their decision verbatim. "That's just taste" is not a valid push-back on a Critical finding; Critical findings by definition implicate the UX spec or iron laws 4/5.

### Re-run sibling review after cross-concern fixes

If an accepted implementation fix changes non-surface code (architectural UX fixes sometimes do), the in-flight code review may be stale. After implementing the fix, re-dispatch `requesting-code-review` against the new HEAD. Symmetrically, code-review fixes that change surfaces re-dispatch `requesting-design-review` (enforced from `receiving-code-review`).

### Deferred tracking

When a Suggestion is deferred, record it in a `## Deferred findings` section of the review log with explicit follow-up action and named owner (usually the human partner). The human partner must acknowledge every deferred finding before Stage 8 merges. "Defer with tracking" collapses to "drop" without the explicit entry.

Next finding.

## Anti-patterns

- **"Append The Ack Line Because It's Routine"** - the `Acknowledged by human partner on YYYY-MM-DD` suffix on a deferred finding is evidence of an explicit human-partner action. Appending it yourself turns Stage 8's precondition 5 into fiction. Wait for the human partner; transcribe their words.
- **"Write The Completion Marker While A Critical UX Finding Is Open"** - the marker is not a ceremony; it is evidence the cycle cleared. The mechanical grep before writing exists to block this.
- **"Good Catch, Implementing"** - performative agreement in UX flavor. Apply the six steps.
- **"That's Just Taste"** - taste-based dismissal without verification. UX findings verify against the spec; the spec is not taste.
- **"Update The Implementation AND The Spec, Skip Re-Approval"** - the spec update is what keeps the spec a source of truth; re-approval is not optional.
- **"Polish Later"** - "polish" is the word used to defer UX findings into invisibility. Evaluate each finding; defer only with tracking.
- **"Sevenths Priority UX Finding; Ignore"** - Suggestions can be deferred with tracking, not ignored. Critical and Important always block.
- **"The A11y Scan Was Automated; Findings Are Automatic Noise"** - automated scanners over-report less often than humans assume. Verify rather than dismiss.

## Red flags

| Thought | Reality |
|---------|---------|
| "The reviewer's sensibility is different from mine" | Verify against the spec, not sensibility. |
| "Reverting the change is easier than arguing" | Revert-to-avoid-argument is performative. Push back or implement; do not revert. |
| "I'll just add a toast to shut the finding up" | Shallow fixes fail review on the next pass. Address the root. |
| "The a11y finding is about keyboard navigation; I'll fix the mouse path" | The finding is about keyboard. Fix keyboard. |
| "The voice example doesn't match, but my copy is clearer" | Update the voice example in the spec (re-approve), or revert to the spec's voice. Not both. |
| "Agree, implement, ship" | Verify, evaluate, respond, then implement. |

## Output artifacts

- Per-finding response record in the review log under the `## Branch-level design review` section. Use the agent's pre-numbered `D<n>` from the report; do not renumber.

   ```
   ### Response D<n>
   - Claim (restated): <plain English>
   - Verification: <spec section checked, state triggered, check re-run>
   - Decision: <accept-impl / accept-update-spec / push-back / defer-with-tracking>
   - Reasoning: <one or two sentences>
   - Re-dispatch or escalation (push-back on Critical only): <reviewer's re-dispatched response OR human-partner decision, recorded verbatim>
   - Sibling review re-dispatch (if fix crossed concerns): <commit sha or "N/A">
   - Implementation / spec update / tracking: <commit sha / updated spec path + re-approval marker line / deferred-findings entry path>
   ```

- A `## Deferred findings` section aggregating every deferred finding (shared with `receiving-code-review`'s aggregate; one section per branch covers both review types).
- Commits for accepted implementation fixes reference the finding: `review D<n>: <summary>`.
- Spec updates for accepted spec-update findings go through `design-brainstorming`'s re-approval cycle; the updated UX spec carries a new `UX spec approved - round <N+1> - YYYY-MM-DD` marker, and Stage 7 re-enters via `requesting-design-review`.

## Successor

After every Critical and Important design-review finding has a decision recorded AND every "accept-impl" is implemented (with fresh a11y evidence) AND every "accept-update-spec" is merged with re-approval AND every deferred finding is acknowledged by the human partner, verify mechanically before writing the marker:

```
findings=$(grep -cE '^- D[0-9]+ ' "$review_log_path")
responses=$(grep -cE '^### Response D[0-9]+' "$review_log_path")
[ "$findings" -eq "$responses" ] || { echo "unresolved findings; do not write marker"; exit 1; }

existing_rounds=$(grep -cE '^Design review complete - round [0-9]+' "$review_log_path")
next_round=$((existing_rounds + 1))
printf '\nDesign review complete - round %d - %s\n' "$next_round" "$(date +%Y-%m-%d)" >> "$review_log_path"
```

**Marker invalidation rule.** If any new D-finding is written to the review log after the marker's line (sibling re-dispatch, spec-update re-dispatch, cross-concern fix), the marker is stale. Delete it, re-enter the response cycle, and re-emit with an incremented round after resolution.

Marker format (append-only):

```
Design review complete - round <N> - YYYY-MM-DD
```

Then:

> All Critical and Important design-review findings resolved. Proceeding to finishing-a-development-branch (stage 8), OR, if the parallel code review is still open, waiting on receiving-code-review before advancing.

### Missing-successor fallback

If `finishing-a-development-branch` is missing in this version of the plugin, STOP. Tell the human partner the pipeline is incomplete.

Do not exit without naming and invoking the named successor.

## Related

- `../../dev/stages/07-review.md` - canonical stage definition
- `../requesting-design-review/SKILL.md` - the sibling skill that dispatched the review
- `../receiving-code-review/SKILL.md` - the parallel receive skill
- `../design-driven-development/SKILL.md` - the overlay that governs surface fixes from accepted findings
- `../accessibility-verification/SKILL.md` - the overlay that governs a11y fixes from accepted findings
- `../design-brainstorming/SKILL.md` - where accepted spec-update findings loop back for re-approval
- `../../agents/design-reviewer.md` - the subagent whose report this skill consumes
