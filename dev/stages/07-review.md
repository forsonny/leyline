# Stage 7 — Review

Stage 7 branches by what the implementation touched. Tasks or features touching user-facing surfaces get **design review in parallel with code review**; the two are dispatched as separate subagents with distinct constructed contexts. All Critical and Important findings from both reviews must be resolved before `finishing-a-development-branch` (stage 8).

**Code review branch:**
- `requesting-code-review`
- `receiving-code-review`
- `code-reviewer` subagent (see `agents/code-reviewer.md`)

**Design review branch (when surfaces touched):**
- `requesting-design-review`
- `receiving-design-review`
- `design-reviewer` subagent (see `agents/design-reviewer.md`)

**Successor:** `finishing-a-development-branch` (stage 8)

---

## 7.1 Code review branch

### 7.1.1 `requesting-code-review`

**Description line:** "Use when completing tasks, implementing major features, or before merging to verify work meets requirements"
**Core principle:** Review early, review often.

**Mandatory triggers:** after each task in subagent-driven development, after completing a major feature, before merge to main.
**Optional but valuable:** when stuck, before refactoring, after fixing a complex bug.

**Dispatch procedure:**
1. Capture `BASE_SHA` and `HEAD_SHA`
2. Dispatch `code-reviewer` subagent; fill placeholders `{WHAT_WAS_IMPLEMENTED}`, `{PLAN_OR_REQUIREMENTS}`, `{BASE_SHA}`, `{HEAD_SHA}`, `{DESCRIPTION}`
3. Act on feedback: Critical → fix immediately; Important → fix before proceeding; Minor → note for later; push back with reasoning if the reviewer is wrong

### 7.1.2 `receiving-code-review`

**Description line:** "Use when receiving code review feedback, before implementing suggestions, especially if feedback seems unclear or technically questionable - requires technical rigor and verification, not performative agreement or blind implementation"
**Core principle:** Verify before implementing. Ask before assuming. Technical correctness over social comfort.

**Response pattern:** READ → UNDERSTAND → VERIFY → EVALUATE → RESPOND → IMPLEMENT (one item at a time).

**Forbidden phrases:**
- "You're absolutely right!"
- "Great point!" / "Excellent feedback!"
- "Let me implement that now" (before verification)

When feedback is unclear: stop, ask, do not implement.

### 7.1.3 `code-reviewer` subagent

**File:** `agents/code-reviewer.md`
**Role:** Senior Code Reviewer. Expertise in software architecture, design patterns, best practices.
**Six review blocks:** Plan alignment, Code quality, Architecture & design, Documentation & standards, Issue identification (Critical/Important/Suggestions), Communication protocol.

---

## 7.2 Design review branch

Dispatched when the change touches a user-facing surface (see `reference/surface-types.md`).

### 7.2.1 `requesting-design-review`

**Description line:** "Use when completing any task that touches a user-facing surface, or before merging any branch containing UX changes. Dispatches the design-reviewer subagent."
**Successor:** `receiving-design-review`

**Dispatch procedure:**
1. Capture `BASE_SHA` and `HEAD_SHA`
2. Dispatch `design-reviewer` subagent with:
   - `{UX_SPEC}` — path to the UX artifact
   - `{SURFACES_IMPLEMENTED}` — list of surfaces touched
   - `{ACCESSIBILITY_EVIDENCE}` — output of the a11y check run
   - `{BASE_SHA}`, `{HEAD_SHA}`, `{DESCRIPTION}`
3. Act on response by severity (Critical / Important / Suggestions); same discipline as code review

### 7.2.2 `receiving-design-review`

**Description line:** "Use when receiving design review feedback, before implementing suggestions. Requires technical rigor and verification, not performative agreement or blind implementation."
**Core principle:** Verify before implementing. Ask before assuming. Technical correctness over social comfort.

**Forbidden phrases (adds to `receiving-code-review`'s list):**
- "Good catch on the UX!"
- "Let me polish that now" (before verification)
- "That's just taste" (used to dismiss feedback)

### 7.2.3 `design-reviewer` subagent

**File:** `agents/design-reviewer.md`
**Role:** Senior Experience Reviewer. Expertise in interaction design, information architecture, accessibility (WCAG 2.2), visual hierarchy, cross-platform UX conventions.

**Six review blocks (mirrors code-reviewer):**
1. **Artifact alignment** — compare implemented surface to UX spec; every state in the matrix implemented and reachable
2. **Flow correctness** — walk every documented flow end-to-end; confirm error paths and recovery
3. **State completeness** — empty, loading, error, success, permission-denied, offline: each exists or is explicitly omitted per spec
4. **Accessibility assessment** — keyboard operability, focus management, screen-reader narration, contrast, text scaling, motion preference
5. **Voice and tone coherence** — against spec's example strings and platform conventions
6. **Issue identification** — Critical / Important / Suggestions with specific, actionable recommendations

**Harness-aware capability detection.** The `design-reviewer` inspects the harness it is running in and uses whatever relevant capabilities are available: browser-automation tools, design-tool MCPs, accessibility-scanning MCPs, snapshot-testing harnesses. If none are available, it falls back to structural review based on code reading and spec comparison — best judgment without automated evidence. See `reference/recommended-optional-tools.md`.

---

## 7.3 Parallel dispatch

When a task or finished feature touches a user-facing surface:

1. `requesting-code-review` dispatches `code-reviewer`
2. `requesting-design-review` dispatches `design-reviewer`
3. Both run concurrently with distinct constructed contexts (neither inherits the parent session)
4. Both responses are received and acted on by severity
5. All Critical + Important findings across both reviews must be resolved before stage 8

## Related

- `stages/05-execute.md` — in-execution reviews use the same pattern at task scope
- `stages/08-finish.md`
- `structure/agents.md` — `code-reviewer` and `design-reviewer` entries
- `reference/recommended-optional-tools.md`
- `reference/surface-types.md`
