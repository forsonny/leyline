# Stage 6 — Discipline (overlays during Execute)

Not sequential stages. Two overlays govern every action during stage 5. Both run in parallel; neither is optional when applicable. Violating the letter of the rules is violating the spirit of the rules.

**Overlays:**
- **6a. Code Discipline** — test-driven-development, systematic-debugging, verification-before-completion
- **6b. Experience Discipline** — design-driven-development, accessibility-verification

Code Discipline governs *all* work. Experience Discipline additionally governs every task whose "Files:" block touches a user-facing surface.

---

## 6a. Code Discipline

### 6a.1 test-driven-development

**Description line:** "Use when implementing any feature or bugfix, before writing implementation code"

**Iron Law:**
```
NO PRODUCTION CODE WITHOUT A FAILING TEST FIRST
```

**RED-GREEN-REFACTOR:**
1. **RED** — write a failing test
2. Verify it fails for the right reason
3. **GREEN** — write the minimal code to pass
4. Verify all tests pass
5. **REFACTOR** — clean up while all tests are green

**Always apply:** new features, bug fixes, refactoring, behavior changes.
**Exceptions (ask human partner):** throwaway prototypes, generated code, configuration files.
**Remedy if violated:** Delete the code. No exceptions. Implement fresh from tests.

**Supporting file:** `testing-anti-patterns.md`

### 6a.2 systematic-debugging

**Description line:** "Use when encountering any bug, test failure, or unexpected behavior, before proposing fixes"

**Iron Law:**
```
NO FIXES WITHOUT ROOT CAUSE INVESTIGATION FIRST
```

**Four phases (each must complete before the next):**
1. Root cause investigation — read error messages, reproduce consistently, note stack traces
2. Pattern analysis — what changed, what the system state was
3. Hypothesis formation — what would be true if the hypothesis is right
4. Verification and fix — only after phases 1–3

**Especially when:** under time pressure, "just one quick fix" seems obvious, multiple previous fixes failed.

### 6a.3 verification-before-completion

**Description line:** "Use when about to claim work is complete, fixed, or passing, before committing or creating PRs - requires running verification commands and confirming output before making any success claims; evidence before assertions always"

**Iron Law:**
```
NO COMPLETION CLAIMS WITHOUT FRESH VERIFICATION EVIDENCE
```

If you haven't run the verification command in this message, you cannot claim it passes.

**The gate:**
1. **IDENTIFY** the command that proves the claim
2. **RUN** it fresh and complete
3. **READ** full output, check exit code, count failures
4. **VERIFY** the output confirms the claim
5. **ONLY THEN** make the claim

**Claim → evidence mapping:**

| Claim | Requires | Not sufficient |
|-------|----------|----------------|
| Tests pass | Test command output: 0 failures | Previous run, "should pass" |
| Linter clean | Linter output: 0 errors | Partial check, extrapolation |
| Build succeeds | Build command: exit 0 | Linter passing, logs look good |
| Bug fixed | Test original symptom: passes | Code changed, assumed fixed |
| Regression test works | Red-green cycle verified | Test passes once |
| Agent completed | VCS diff shows changes | Agent reports "success" |
| Requirements met | Line-by-line checklist | Tests passing |

---

## 6b. Experience Discipline

Applies to every task whose "Files:" block touches a user-facing surface. See `reference/surface-types.md` for what qualifies as a surface.

### 6b.1 design-driven-development

**Description line:** "Use when implementing any user-facing surface, before writing implementation code. Enforces that a design artifact exists, is current, and is the source of truth for the implementation."

**Iron Law:**
```
NO USER-FACING SURFACE WITHOUT AN APPROVED DESIGN ARTIFACT FIRST
```

**Cycle — DRAW-BUILD-RECONCILE** (UX analog of RED-GREEN-REFACTOR):
1. **DRAW** — confirm the design artifact exists and is current; if not, stop and loop back to `design-brainstorming`
2. **Verify** the artifact specifies what is being built (if the task touches a surface not in the state matrix, stop)
3. **BUILD** — implement the minimal code that instantiates the artifact (TDD runs in parallel under 6a.1)
4. **RECONCILE** — side-by-side: artifact vs implementation. Fix the implementation, OR update the artifact and re-get approval. **No silent drift.**

**Exception surface (must ask the human partner):** internal admin UI behind a feature flag, throwaway prototypes, library code with no user surface, CLI output already specified in the product spec.

**Remedy if violated:** Delete the surface. Don't keep it as reference, don't adapt it, don't look at it. Implement fresh from the design artifact.

**What counts as "user-facing surface":** any output a human perceives — screens, views, modals, toasts, error messages, empty states, loading states, CLI text, command output formatting, log formatting when humans read logs, email templates, accessibility affordances.

**Announce on entry:**
> I'm using the design-driven-development skill to implement this surface. The source of truth is `docs/leyline/design/<file>`; I will not diverge from it without updating the artifact and re-getting approval.

**Anti-patterns:**
- **"I Know What Looks Good"** — the artifact is the source of truth, not your taste
- **"The Artifact Is Out Of Date"** — then stop and update it, don't implement from memory
- **"I'll Match The Artifact Later"** — you won't
- **"The Artifact Didn't Say"** — if it didn't say, it isn't designed; stop and design it

### 6b.2 accessibility-verification

**Description line:** "Use when about to claim a user-facing surface is complete, before committing or creating PRs. Requires running accessibility checks and confirming output before making any completion claim."

**Iron Law:**
```
NO COMPLETION CLAIMS ON A USER-FACING SURFACE WITHOUT FRESH ACCESSIBILITY EVIDENCE
```

If you haven't run the accessibility verification procedure in this message, you cannot claim the surface is complete.

**The gate:**
1. **IDENTIFY** the appropriate check (keyboard walkthrough for web, VoiceOver/NVDA script for critical flows, contrast check, semantic-HTML lint, aria audit, terminal output re-read for CLI voice)
2. **RUN** it fresh and complete in this message
3. **READ** output; count violations
4. **VERIFY** zero critical violations; lower-severity triaged
5. **ONLY THEN** claim the surface complete

**Tool-agnostic on purpose.** The skill does not require axe-core or lighthouse. It requires that *some* accessibility verification ran in this message and produced readable output. See `reference/recommended-optional-tools.md` for optional tools that deepen fidelity.

**Claim → evidence mapping** (extends the 6a.3 table):

| Claim | Requires | Not sufficient |
|-------|----------|----------------|
| UX complete | Every state in the state matrix implemented and walked through | Happy-path screenshot |
| Accessible | Fresh a11y run with 0 violations, OR manual keyboard/screen-reader walkthrough documented in this message | "I followed accessibility practices" |
| Design matches spec | Fresh side-by-side (artifact vs implementation) in this message | "It looks right" |
| Empty/loading/error states | Each state triggered and observed in this message | "We have the components" |
| Flow works | Full user journey walked end-to-end in this message | Individual screens rendered |

**Red flags:**

| Thought | Reality |
|---------|---------|
| "I followed accessibility best practices" | Evidence or it didn't happen. |
| "It renders fine for me" | You are not every user. |
| "The framework handles accessibility" | No framework handles all of it. Run the check. |
| "I tested keyboard navigation earlier" | Fresh run in this message. |
| "This is internal, doesn't need a11y" | Internal users also have disabilities. |

---

## Related

- `stages/05-execute.md` — the stage these overlays govern
- `stages/07-review.md` — where review gates catch violations
- `principles/iron-laws.md` — consolidated iron laws (now five)
- `principles/experience-discipline.md` — deeper writeup of 6b
- `reference/surface-types.md` — what triggers Experience Discipline
- `reference/recommended-optional-tools.md`
