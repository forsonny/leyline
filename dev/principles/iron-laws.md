# Iron Laws

Non-negotiable rules that appear in skill text, typically in a fenced code block for emphasis. Every iron law is preceded in its home skill by the sentence:

> Violating the letter of the rules is violating the spirit of the rules.

## The five iron laws

### Code Discipline (6a)

#### 1. Test-Driven Development

```
NO PRODUCTION CODE WITHOUT A FAILING TEST FIRST
```

**Home skill:** `test-driven-development`
**Exception surface (must ask the human partner):** throwaway prototypes, generated code, configuration files.
**Remedy if violated:** Delete the code. Don't keep it as reference, don't adapt it while writing tests, don't look at it. Implement fresh from tests.

#### 2. Systematic Debugging

```
NO FIXES WITHOUT ROOT CAUSE INVESTIGATION FIRST
```

**Home skill:** `systematic-debugging`
**Gate:** If Phase 1 (Root Cause Investigation) isn't complete, you cannot propose fixes.
**Applies to:** test failures, production bugs, unexpected behavior, performance problems, build failures, integration issues.
**Especially when:** under time pressure, "just one quick fix" seems obvious, multiple previous fixes failed.

#### 3. Verification Before Completion

```
NO COMPLETION CLAIMS WITHOUT FRESH VERIFICATION EVIDENCE
```

**Home skill:** `verification-before-completion`
**Rule:** If you haven't run the verification command in this message, you cannot claim it passes.
**Interpretation:** Claiming work is complete without verification is dishonesty, not efficiency.

### Experience Discipline (6b)

#### 4. Design-Driven Development

```
NO USER-FACING SURFACE WITHOUT AN APPROVED DESIGN ARTIFACT FIRST
```

**Home skill:** `design-driven-development`
**Exception surface (must ask the human partner):** internal admin UI behind a feature flag, throwaway prototypes, library code with no user surface, CLI output already specified in the product spec.
**Remedy if violated:** Delete the surface. Don't keep it as reference, don't adapt it, don't look at it. Implement fresh from the design artifact.
**What counts as "user-facing surface":** any output a human perceives — screens, views, modals, toasts, error messages, empty states, loading states, CLI text, command output formatting, log formatting when humans read logs, email templates, accessibility affordances.

#### 5. Accessibility Verification

```
NO COMPLETION CLAIMS ON A USER-FACING SURFACE WITHOUT FRESH ACCESSIBILITY EVIDENCE
```

**Home skill:** `accessibility-verification`
**Rule:** If you haven't run the accessibility verification procedure in this message, you cannot claim the surface is complete.
**Interpretation:** Claiming a UI is complete without fresh a11y evidence is dishonesty, not efficiency.

## Hard gates (iron-law-adjacent)

### Brainstorming hard gate

> Do NOT invoke any implementation skill, write any code, scaffold any project, or take any implementation action until you have presented a design and the user has approved it. This applies to EVERY project regardless of perceived simplicity.

**Home skill:** `brainstorming`
**Why:** "Simple" projects are where unexamined assumptions cause the most wasted work.

### Design-brainstorming hard gate

> Do NOT invoke any implementation skill on any user-facing surface until the UX spec has been presented and the human partner has approved it. This applies to EVERY project that has a user-facing surface, regardless of perceived simplicity. A CLI has user-facing surfaces. A library has user-facing surfaces if it produces human-readable output.

**Home skill:** `design-brainstorming`
**Why:** UX is not an afterthought. Surfaces shipped without design artifacts cannot be verified against intent, and "I'll design as I code" consistently produces the first thing that works rather than the thing that should ship.

### Experience gate (implementation-time)

> Before dispatching the implementer for any task whose "Files:" block touches a user-facing surface, verify that `docs/leyline/design/<file>` exists, is current, and covers the surface. If not, stop. Do not dispatch. Return to `design-brainstorming`.

**Home skill:** `subagent-driven-development` / `executing-plans`
**Why:** Iron Law #4 needs an enforcement point during execution; the gate is that point.

## Cross-cutting maxims

- **Evidence over claims** — paired in TDD's RED verification, verification-before-completion's gate function, and accessibility-verification's in-message-output requirement
- **Systematic over ad-hoc** — process over guessing
- **Complexity reduction** — simplicity as primary goal
- **"The letter is the spirit"** — you cannot lawyer your way around iron laws

## Related

- `stages/06-discipline.md` — how the five iron laws overlay the Execute stage (6a + 6b)
- `principles/behavior-shaping.md` — why iron laws are framed this way (to survive rationalization)
- `principles/terminology.md` — "iron law" and "violating the letter is violating the spirit" as load-bearing phrases
- `principles/experience-discipline.md` — deeper writeup of iron laws 4 and 5
