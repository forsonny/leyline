# Changelog

All notable changes to the Leyline plugin are documented here. Newest first.

## [1.2.4] - 2026-04-21

OpenCode install examples no longer assume a checkout path that only exists on the maintainer's machine.

### Patch - OpenCode path placeholders

- Updated `README.md`, `docs/README.opencode.md`, and `.opencode/INSTALL.md` so the OpenCode install examples use user-supplied checkout-path variables instead of hard-coded `~/src/leyline` assumptions.
- Added a safer PowerShell example that tells users to replace the checkout path, removes any existing plugin link first, and points the symlink target at the user's actual Leyline clone.
- Kept the install guidance generic for downstream users on other machines while preserving the recommended symlink-based OpenCode setup.

## [1.2.3] - 2026-04-21

OpenCode install docs clarified so the shipped plugin behavior matches the documented local-install flow.

### Patch - OpenCode install docs clarification

- Tightened `README.md`'s OpenCode section to state the actual OpenCode plugin discovery paths, keep the recommended global-symlink install, and warn against copying only `leyline.js` without the full repo checkout.
- Updated `docs/README.opencode.md` to distinguish the recommended global install from the optional project-local plugin path and to make the symlink requirement explicit.
- Corrected the root README's verification prompt to `"let's build a dashboard filters feature"` so the expected `brainstorming` activation matches Leyline's routing table deterministically.

## [1.2.2] - 2026-04-21

OpenCode install path corrected to the real plugin API and backed by automated verification.

### Patch - OpenCode plugin install

- Replaced `.opencode/plugins/leyline.js`'s metadata shim with a real OpenCode plugin export and added a package `exports` entry for npm/plugin loading.
- The OpenCode plugin now syncs Leyline's `skills/`, `commands/`, and OpenCode-compatible reviewer agents into `~/.config/opencode/`, then injects `AGENTS.md` plus `skills/using-leyline/SKILL.md` through `experimental.chat.system.transform`.
- Added `tests/opencode/plugin-install.test.mjs` and an `npm test` script to verify the OpenCode plugin contract: function export, asset sync, reviewer-agent normalization, and prompt injection.
- Rewrote `docs/README.opencode.md`, `.opencode/INSTALL.md`, `README.md`, `dev/reference/harness-matrix.md`, and `dev/structure/metadata.md` to describe the working symlink/plugin flow instead of the stale manual-hook guidance.
- Updated `scripts/bump-version.sh` and `scripts/check-stage-0.sh` so version drift checks no longer depend on a fake version field inside `.opencode/plugins/leyline.js`.

## [1.2.1] - 2026-04-21

Codex install docs corrected to the current marketplace flow, plus release metadata sync hardening.

### Patch - Codex install path

- Replaced the stale Codex `[[plugins]]` / `[[hooks.session_start]]` guidance with the verified `codex plugin marketplace add` flow in `docs/README.codex.md` and `.codex/INSTALL.md`.
- Added `.agents/plugins/marketplace.json` and `.codex-plugin/plugin.json` so current Codex can actually discover Leyline from a repo marketplace instead of only registering the repo source.
- Fixed `skills/design-driven-development/SKILL.md` frontmatter so Codex no longer rejects the skill for invalid YAML during plugin load.
- Updated the root `README.md`, `dev/reference/harness-matrix.md`, and `dev/structure/docs.md` so Codex is no longer described as a manual-fetch plus hand-wired TOML install.
- Clarified in `docs/README.codex.md`, `.codex/INSTALL.md`, `README.md`, and `dev/structure/commands.md` that Codex does not surface Leyline's `commands/` files as plugin slash commands; use `@leyline` or explicit skills instead.
- Clarified in `skills/using-leyline/references/codex-tools.md` that the Codex install flow was revalidated against `codex-cli 0.122.0`, while the tool-name table remains a maintained reference.

### Patch - release metadata sync

- Synced version `1.2.1` across `package.json`, `gemini-extension.json`, `plugin.json`, `.claude-plugin/plugin.json`, and `.opencode/plugins/leyline.js`.
- Updated the README version badge to `1.2.1`.
- Hardened `scripts/bump-version.sh` so future releases also sync `.codex-plugin/plugin.json` in addition to the existing plugin manifests and the README badge.
- Hardened `scripts/check-stage-0.sh` so it now requires the Codex marketplace files and flags version drift across all shipped plugin manifests plus the README badge.
- Hardened `scripts/check-stage-0.sh` so it now rejects unquoted `description:` frontmatter values that contain a YAML-breaking `: ` sequence.

## [1.2.0] - 2026-04-18

`deep-discovery` convergence rule - closes runaway-loop and stop-early failure modes with a per-finding classification gate.

### Patch - deep-discovery step 4 classification rule

- Rewrote step 4 of `skills/deep-discovery/SKILL.md` to require per-finding classification with literal `(S)` / `(O)` / `(R)` / `(E)` letter tags before any material-or-not decision.
  - `(S) Structural` - a named approach, constraint, goal, non-goal, or dependency cannot survive the finding. Always material.
  - `(O) Operational` - runtime, scale, security, observability, rollback, migration, or on-call concern the spec does not address. Always material.
  - `(R) Second-order refinement` - internal-consistency fix between edits made in rounds 1..N-1, or sub-line clarity inside those edits. Not material.
  - `(E) Editorial` - terminology, phrasing, or naming inside the existing approach. Not material.
- Split the "non-material" exit into a new **convergence candidate** path: when all findings are `(R)` or `(E)`, the agent presents the per-finding classification, the count trend across rounds, and a completion-or-continue recommendation with reasoning to the human partner and WAITS. The completion marker is NOT appended without explicit human-partner approval, even when delegation was given in advance.
- Made "unreachable" categorical and duration-independent: scheduled meetings, flights, step-outs, indefinite absences all count. Duration of the absence does not scale the authorization.

### Patch - new anti-patterns, red flags, and forbidden phrases

Added to `skills/deep-discovery/SKILL.md`:

- **Anti-patterns (four new):** "Every Round Is Material Because I Keep Finding Something", "Delegation Authorizes The Action, Not Just The Recommendation", "Delegation Is Ongoing Authorization, Not Pre-Paid Consent", "Convergence-Metaphor Substitutes For Classification".
- **Red flags (seven new rows):** round-count appeals, material-finding-conflation, delegation-as-action, reachability-gradient, pre-paid-consent, tag-skipping, deferral-as-abdication.
- **Forbidden phrases (ten new):** verbatim surfaces observed under pressure-test, including "editorial whack-a-mole", "we are in the noise floor", "the pattern argues against it", "abdication dressed as caution", "seven full passes is empirically adequate", "the delegation was pre-paid consent", "a scheduled absence is different from real unreachability".

### Patch - new test group + scenario + traces

- Created `tests/deep-discovery/` as a new test group.
- Added `tests/deep-discovery/converge-or-loop.md` - pressure-test scenario for convergence vs runaway-loop behavior. Captures RED baseline (agent auto-decides without classification under delegation), GREEN (classification applied, marker held for human-partner review), REFACTOR round-2-editorial-only variant (same behavior at lower round count), and closure verification trace (post-hardening pressure test with scheduled-absence + pre-paid-consent framings both rejected).
- Updated `tests/README.md` and `skills/writing-skills/testing-skills-with-subagents.md` suite-layout tables to reference the new group.

### Version

Bumped to 1.2.0 across `package.json`, `gemini-extension.json`, `plugin.json`, `.claude-plugin/plugin.json`, and `.opencode/plugins/leyline.js`. Change is additive at the skill level (new classification rule supersedes step 4 prose but preserves the material/non-material concept; no existing skill names, descriptions, or successor chains touched); minor-version bump per semver.

Open future-hardening candidates from the first REFACTOR trace, left unclosed pending real-session evidence: "tags are obvious enough that writing them is ceremony" (tag-skip), "substituting procedural judgment for the human partner's stated preference" (insubordination framing), "running an extra round is always conservative" (over-running as mirror failure).

## [1.1.0] - 2026-04-18

Manifest behavior-shaping pass (three patches: A, B, C).

### Patch A - first-response rule with lint and canonical scenario

- Promoted one verbatim first-response rule across five files (`CLAUDE.md`, `AGENTS.md`, `GEMINI.md`, `README.md`, `skills/using-leyline/SKILL.md`). Same architecture as the iron laws: write once, ship identically, lint for drift.
- Tightened `skills/using-leyline/SKILL.md`'s "## The rule" section to lift the same wording verbatim and add a visible-justification clause for the no-skill-applies path ("name the skills you considered and why you rejected each").
- Extended `scripts/check-manifests.sh` with a `FIRST_RESPONSE_RULE` invariant.
- Created `tests/manifest-behavior/first-response-with-hook-failure.md` - the canonical scenario testing manifest behavior when the session-start hook fails to inject `using-leyline`.

### Patch B - structural reshape

- Reordered all three manifests so load-bearing content (first-response rule, iron laws, hook-failure detection, routing, pipeline) precedes orientation content (Discovery, platform adaptation, contributor rules, related).
- Added "Hook-failure detection" section to all three manifests (NOT in `using-leyline` itself, since the entry skill is the thing being detected as missing).
- Added "Routing - where to enter" 4-row table verbatim from `using-leyline` to all three manifests; full routing table stays in the entry skill.
- Dropped the "Exit" column from CLAUDE.md's pipeline table (reduces drift surface vs README's pipeline-at-a-glance).
- Symmetrized AGENTS.md tool-mapping into per-harness pointers (Codex, OpenCode, Copilot CLI). Surfaced `docs/README.copilot-cli.md` as a missing doc - addressed in Patch C.
- All three manifests now reference `dev/reference/recommended-optional-tools.md` rather than enumerating MCPs inline.
- CLAUDE.md contributor rules moved to the bottom (after the agent-facing load-bearing block).
- Lint extensions: ROUTING_ROWS array (8 substring matches), TERMINOLOGY_TERMS array (4 terms), HOOK_FAILURE_ANCHOR check; routing and terminology scoped to AGENT_FACING_FILES (3 manifests + entry skill); README is human-facing and exempted.
- Added `tests/manifest-behavior/routing-table-correct-skill-pick.md` as the second canonical scenario.
- Per the deep-discovery recommendation, no forbidden phrases added in this patch - those require manifest-targeted RED traces which do not yet exist. A future Patch B.5 will add them once traces are captured.

### Patch C - Copilot CLI doc + manifests-doc update

- Added `docs/README.copilot-cli.md` (UNVERIFIED, matching the Codex/OpenCode docs' verification posture). Includes install commands, verify steps, tool-name mapping table, limitations (subagent support, parallel-dispatch primitive availability, hook firing, marketplace fetching), and cross-references.
- Updated `dev/structure/manifests.md` with a drift-lint coverage table and a manifest section-ordering reference reflecting the post-Patch-B structure.

### Version

Bumped to 1.1.0 across `package.json`, `gemini-extension.json`, `plugin.json`, `.claude-plugin/plugin.json`, and `.opencode/plugins/leyline.js`. The behavior-shaping changes are additive (no breaking changes to existing skill names, descriptions, or successor chains); minor-version bump per semver.

## [1.0.0] - 2026-04-17

First stable release. Structural completeness across the full eight-stage pipeline plus meta-skill; marketplace manifests wired for all six supported harnesses.

- Structural: 21 skills, 2 subagents, 4 sample pressure-test scenarios, session-start hook for Claude Code and Cursor, per-harness install docs and marketplace manifests.
- Discipline: five iron laws as fenced code blocks with "Violating the letter..." preemption at home skills; hard gates with mechanical grep-based preconditions at every stage entry; verbatim completion markers at every handoff; forbidden-phrase lists in every skill; constructed-context rule for subagent dispatch.
- Review evidence: ten deep-discovery passes (nine on pipeline stages, one on the meta-skill); ten hardening releases with documented findings and fixes; cross-stage upstream fixes (approval markers, baseline-note location, marker invalidation) rippled correctly.
- No breaking changes from 0.10.2; this is a marker release for structural completeness. See `RELEASE-NOTES.md` for the narrative.
- Version bumped to 1.0.0 across `package.json`, `gemini-extension.json`, `plugin.json`, `.claude-plugin/plugin.json`, and `.opencode/plugins/leyline.js`.
- README rewritten for a release framing: badges, pipeline-at-a-glance ASCII diagram, feature summary, install-per-harness, iron-law summary, what-s-inside inventory, verification-evidence summary, learn-more pointers.

## [0.10.2] - 2026-04-17

Marketplace setup across supported harnesses + MAKER gitignore.

- Added `.claude-plugin/marketplace.json` — self-hosting marketplace manifest listing leyline as a plugin with `source: "./"`. Install: `/plugin marketplace add forsonny/leyline` then `/plugin install leyline@leyline-marketplace` on Claude Code.
- Added `.claude-plugin/plugin.json` — Claude Code plugin manifest with metadata, license, homepage, repository, and directory pointers. Cursor consumes the same format.
- Added `.github/plugin/marketplace.json` — GitHub Copilot CLI marketplace manifest. Install: `copilot plugin marketplace add https://github.com/forsonny/leyline` then `copilot plugin install leyline`.
- Added top-level `plugin.json` — generic plugin manifest for harnesses that fall back to a root-level manifest lookup.
- Updated `gemini-extension.json` with `homepage`, `repository`, and `mcpServers: {}` per Gemini CLI extension reference. Install: `gemini extensions install https://github.com/forsonny/leyline`.
- Rewrote `README.md` install section with per-harness concrete commands using the real `forsonny/leyline` URL; replaced placeholder marketplace IDs.
- Updated `docs/README.codex.md`, `docs/README.opencode.md`, `.codex/INSTALL.md`, `.opencode/INSTALL.md` with real clone URLs.
- Updated `dev/reference/harness-matrix.md` Claude Code row.
- Added MAKER framework patterns to `.gitignore` (`.maker/`, `.maker-*/`, `maker-cache/`, `maker-state/`, `maker-checkpoints/`, `maker-output/`, `MAKER.md`, `maker-*.md`). Removed the `.maker-checkpoints/` directory that had accumulated 11 tracked checkpoint JSONs.
- Version bumped to 0.10.2 across `package.json`, `gemini-extension.json`, `.opencode/plugins/leyline.js`, `.claude-plugin/plugin.json`, and top-level `plugin.json`.

## [0.10.1] - 2026-04-17

Stage 9 hardening pass (v1.0.0 readiness).

- Version bumped to 0.10.1 across `package.json`, `gemini-extension.json`, and `.opencode/plugins/leyline.js` (previously stuck at 0.1.0 despite CHANGELOG entries through 0.10.0).
- Meta-skill compliance: `writing-skills/SKILL.md` now has all 15 mandatory sections it declares (Iron law `NO SKILL CONTENT CHANGE WITHOUT BEFORE-AND-AFTER PRESSURE-TEST EVIDENCE`, "Violating the letter..." preemption, Hard gate with mechanical content-change detection, Output artifacts, Missing-successor fallback).
- Content-change detection is now mechanical: six grep commands that produce a deterministic signal; judgment-only determinations are no longer acceptable.
- Scenario format reconciled across three sources (`tests/README.md`, `skills/writing-skills/testing-skills-with-subagents.md`, sample scenarios under `tests/skill-triggering/`): seven sections (Scenario / Expected behavior / Forbidden phrases check / Skills loaded / RED baseline / Outcome / Related).
- Sample scenarios' speculative forbidden phrases marked `(provisional - to be replaced with verbatim-observed phrase after RED run)` where phrases were not observed. `receiving-review-performative-agreement.md`'s phrases are authoritative (lifted verbatim from the skill's own list, not provisional).
- Added fourth scenario `writing-skills-self-reflexive.md`: contributor edits the meta-skill without running its cycle; tests the meta-skill's resistance to self-modification shortcut.
- `render-graphs.js` shipped: Node.js script that walks a path, extracts `dot` fenced blocks from SKILL.md files, and renders them via system `dot` to SVG / PNG. Supports `--format`, `--out`, and `--group` flags. Removes the broken cross-reference.
- `tests/run.sh` upgraded from Stage 0 stub: now has `--lint` mode that verifies every scenario file has the seven required sections; exits non-zero on drift.
- `brainstorming/SKILL.md` and `using-leyline/SKILL.md` gained Forbidden phrases sections (previously missing despite the newly-declared 15-section contract).
- `anthropic-best-practices.md` now carries a review-status block (reviewed 2026-04-17, source references) to mitigate silent drift when Anthropic docs evolve.
- `writing-skills/SKILL.md` overlay-exemption rule broadened to match actual shipped overlays (sections 6, 12, 13, 14 exempted for Stage 6 overlays; iron law + core principle + process + anti-patterns + red flags + forbidden phrases + related remain required).
- Reference-file exemption tightened: no YAML frontmatter required; H1 title serves as the identifier. The three shipped reference files under `writing-skills/` now comply explicitly.
- Non-existent skill-type examples (`flatten-with-flags`, `condition-based-waiting`) replaced with shipped examples (`using-git-worktrees` for Technique; `dispatching-parallel-agents` for Pattern; `implementer-prompt.md` for Subagent-prompt template).
- Announce-on-entry strengthened with explicit STOP commitment.
- "When to use" decision diagram: the non-content exit node is now a doublecircle (terminal state), not a box; matches `graphviz-conventions.dot` rule 4.
- Per-harness install docs (`docs/README.codex.md`, `docs/README.opencode.md`) now call out the parallel-dispatch primitive dependency that `dispatching-parallel-agents` and Stage 7 parallel review require; documents the sequential-fallback behavior when the primitive is unavailable.

## [0.10.0] - 2026-04-17

Stage 9 - Meta skill, supporting references, pressure-test scenarios.

- Added `skills/writing-skills/SKILL.md` - the TDD-for-prose meta skill. RED-GREEN-REFACTOR mapped to pressure tests. Six-step process (baseline, record rationalizations verbatim, write minimal rebuttal, verify, refactor against new rationalizations, commit with traces). Mandatory-section checklist (15 sections for pipeline stages; reduced for overlays, reference files, subagent-prompt templates). Content-change vs non-content-change rule gates the pressure test. Returns to caller (meta-skill; no pipeline successor). Frontmatter 404 bytes.
- Added `skills/writing-skills/testing-skills-with-subagents.md` - pressure-test scenario format, RED-GREEN-REFACTOR execution detail, trace format required for PR submission, harness-portability rules.
- Added `skills/writing-skills/anthropic-best-practices.md` - cross-reference mapping Anthropic's official skill-authoring guidance to Leyline's opinionated extensions (frontmatter limits, 15 mandatory sections, tool-naming mapping, 1%-invoke threshold, verbatim markers, TDD-for-prose).
- Added `skills/writing-skills/persuasion-principles.md` - the seven behavior-shaping levers (iron laws, hard gates, "Violating the letter..." preemption, Red Flags tables, named anti-patterns, announce-on-entry, forbidden phrases) with mechanism explanations. Weak-shape catalogue (soft-recommendation prose, abstract principles, long example walkthroughs, shame appeals, good-faith reliance) for contrast.
- Added `skills/writing-skills/graphviz-conventions.dot` - DOT reference file with shape conventions (doublecircle / box / diamond), label conventions, flow conventions, and eight explicit rules for in-skill diagrams.
- Added `skills/writing-skills/examples/README.md` - placeholder for worked examples that land as contributors capture RED/GREEN traces in publishable form.
- Added three sample pressure-test scenarios under `tests/skill-triggering/`:
  - `brainstorming-lets-build-x.md` - verifies `brainstorming` triggers on "let's build X" and the hard gate blocks premature code writing.
  - `tdd-under-time-pressure.md` - verifies the TDD iron law holds against a "we have an hour to ship" pressure message injected mid-task.
  - `receiving-review-performative-agreement.md` - verifies `receiving-code-review` blocks performative-agreement phrases and enforces the six-step pattern per finding.

  Each scenario has RED baseline instructions, GREEN expected-behavior, forbidden-phrase checks, and skills-loaded list. Outcomes pending actual execution in the target harnesses.

## [0.9.1] - 2026-04-17

Stage 8 hardening pass + upstream baseline-location and marker-discipline fixes.

- Fixed Option 1 step ordering: append `Merged - YYYY-MM-DD - <sha>` to the baseline note BEFORE removing the worktree.
- Moved the baseline note out of the worktree to the main repo (`$main_repo_root/docs/leyline/plans/...`) via `realpath "$(git rev-parse --git-common-dir)/.."`. Option 4 (discard) now legitimately preserves the audit trail.
- Added explicit mechanical grep to every Stage 8 precondition: plan-complete, surfaces, deferred-ack count-match, post-marker findings check (invalidates stale markers).
- Added marker-discipline guard to both receive skills: before writing the marker, verify all findings have responses; after writing, any new finding invalidates the marker. Round number auto-increments.
- Added ack transcription discipline: receive skills forbid the agent from appending the `Acknowledged by human partner` line on its own authority. New anti-patterns and forbidden phrases covering both behaviors.
- Option 1 now LOCAL-ONLY with explicit "do not push"; `git branch -d` not `-D`.
- Option 2 runs `git remote` discovery; pins PR body to `$main_repo_root/.git/leyline-pr-body-<feature-name>.md`; PR-URL fallback recipe for GitHub / GitLab / Bitbucket.
- Option 3 "keep" names the resume path via `using-leyline`.
- Option 4 "discard" records the baseline-note line BEFORE destructive commands; checks remote branches.
- Base-ref validated with `git rev-parse --verify`; fallback to `origin/HEAD` on unresolved ref.
- Step 1 test-discovery prefers current CLAUDE.md over baseline's recorded; honors `baseline-red-authorized` passthrough; requires FULL command output.
- Merge message defers to project convention.
- Announce commits to four-option discipline ("exactly four, not a fifth").
- Added "resume the kept branch" row to `using-leyline` entry table.

## [0.9.0] - 2026-04-17

Stage 8 - Finish skill + upstream review-log markers.

- Added `skills/finishing-a-development-branch/SKILL.md` - the pipeline's terminal skill. Six-item precondition check (plan complete, inside worktree on feature branch, code-review complete marker present, design-review complete marker present when surfaces touched, deferred findings acknowledged, fresh test run). Four-step process: Verify tests -> Determine base branch -> Present four options -> Execute choice. DOT process diagram for option 4 enforcing explicit-confirmation ("type `discard` to confirm, or anything else to abort"). Destructive-action rules with out-of-scope escalation for force-push / rebase / unconfirmed branch deletion.
- Added verbatim review-complete markers in `receiving-code-review` and `receiving-design-review`:
  - `Code review complete - round <N> - YYYY-MM-DD`
  - `Design review complete - round <N> - YYYY-MM-DD`

  Appended to the review log's branch-level sections only after all Critical/Important findings have decisions, all accepted fixes are implemented and verified, and all deferred findings carry verbatim human-partner acknowledgement. Stage 8 greps for these markers as preconditions.
- Per-option output artifacts defined: merge appends `Merged - YYYY-MM-DD - <sha>` to the baseline note; keep appends `Kept - YYYY-MM-DD`; discard appends `Discarded - YYYY-MM-DD - reason: <...>` (baseline note preserved for audit).
- Option 2 (push and PR) includes a PR body constructor that cites product spec, UX spec, baseline note, and review log paths.

## [0.8.1] - 2026-04-17

Stage 7 hardening pass.

- Shrunk agent frontmatter descriptions to fit the 1024-char limit (`code-reviewer.md` 376 bytes; `design-reviewer.md` 408 bytes). Routing hints preserved; multi-example exposition moved to a `## When dispatched` section in the agent body.
- Added explicit parallel-dispatch orchestration in `subagent-driven-development`'s Stage 7 handoff: when any task touched a surface, `requesting-code-review` and `requesting-design-review` dispatch concurrently via `dispatching-parallel-agents` with two problem packets. Sequential dispatch is now forbidden (leaks first report's framing into the second reviewer).
- Narrowed `requesting-code-review` description and body to branch-level only; per-task code review runs via `code-quality-reviewer-prompt.md`, which dispatches the same agent with `{MODE}=per-task`. Avoids the precondition-STOP misfire mid-Stage-5.
- Added branch-level re-dispatch-or-escalate clause for push-back on Critical findings (both receive skills): push-back now either re-dispatches the reviewer with reasoning spliced in, or escalates to the human partner with the decision recorded verbatim.
- Added "re-run sibling review after cross-concern fixes" clause to both receive skills: code-review fixes touching surfaces re-dispatch `requesting-design-review`; design-review fixes changing non-surface code re-dispatch `requesting-code-review`. Neither review stays fresh while the sibling is stale.
- Added explicit spec-update suspension semantics to `receiving-design-review`: spec-update findings SUSPEND Stage 7 entirely, loop through `design-brainstorming` for re-approval, then re-dispatch `requesting-design-review` against the new round. Prior report's remaining findings are discarded (issued against superseded spec).
- Added deferred-findings tracking mechanism: when no external issue tracker exists, deferrals go into a `## Deferred findings` section of the review log with specific follow-up action and named owner. Human partner must acknowledge every deferred finding before Stage 8 merges; "defer with tracking" no longer collapses to "drop".
- Added per-task `design-quality-reviewer-prompt.md` wrapper analogous to `code-quality-reviewer-prompt.md`. Produces "Blocks task completion: yes/no" triage; stage-5 per-task loop now uses it for surface-touching tasks instead of dispatching `agents/design-reviewer.md` directly.
- Updated both agents to pre-number findings (`F1..Fn` for code-reviewer, `D1..Dn` for design-reviewer) rather than leaving numbering to the coordinator. Commit-message references (`review F3:`) and per-finding response records are now reproducible.
- Both agents now carry explicit iron-law sweeps: code-reviewer greps the review log for `Failing-test output`, `Systematic-debugging record - task <N>`, and post-implementation verification. design-reviewer greps for concrete a11y evidence (trivial pastes like "looks fine on my machine" are Critical findings). Structural-review Critical markers defined for design-reviewer block 4 when no scanner is available.
- Added explicit grep template to `requesting-design-review` precondition 3 (`a11y_paste_count` vs `ux_task_count` plus trivial-paste detection).
- Added forbidden-justification phrases to design-reviewer block 1 ("cleaner", "more modern", "feels better", "more intuitive", "matches our brand") parallel to code-reviewer's list.
- Added branch-level large-diff handling: the agent partitions its own review by file group inside a single branch-level dispatch; only per-task mode requests a split from the coordinator.
- Added `{MODE}` as an explicit input token across all four wrappers.
- Added "Done well entries do not soften severity" rule to both agents.

## [0.8.0] - 2026-04-17

Stage 7 - Review skills + agents.

- Added `skills/requesting-code-review/SKILL.md` - branch-level dispatch skill. Hard gate with precondition check (tasks complete, SHAs captured, agent definition present, per-task review logs present). Dispatches `agents/code-reviewer.md` with constructed inputs (WHAT_WAS_IMPLEMENTED, PLAN_OR_REQUIREMENTS, BASE_SHA, HEAD_SHA, DESCRIPTION). Parallel-dispatch discipline when surfaces touched. Hands off to `receiving-code-review`; never filters the report.
- Added `skills/receiving-code-review/SKILL.md` - response-discipline skill. Six-step pattern (READ -> UNDERSTAND -> VERIFY -> EVALUATE -> RESPOND -> IMPLEMENT) applied per finding, one at a time. Forbidden phrases block performative agreement ("You're absolutely right!", "Great point!", "Let me implement that now" before verification). Three valid responses (accept / push-back / defer-with-tracking). Per-finding response record in the review log.
- Added `skills/requesting-design-review/SKILL.md` - parallel branch of code review when surfaces touched. Precondition includes verifying the UX-spec approval marker AND that per-task a11y evidence exists in the review log before dispatch. Constructs UX_SPEC / SURFACES_IMPLEMENTED / ACCESSIBILITY_EVIDENCE / SHAs / DESCRIPTION. Parallel with `requesting-code-review`.
- Added `skills/receiving-design-review/SKILL.md` - shared six-step pattern plus UX-specific forbidden phrases ("Good catch on the UX!", "Let me polish that now" before verification, "That's just taste", "I prefer it the way it was", "The reviewer isn't the designer", "Design is subjective anyway"). Verify against BOTH the UX spec AND the implementation (trigger states, re-run a11y checks). Accepted spec-update findings loop through `design-brainstorming` for re-approval; accepted implementation fixes run through DRAW-BUILD-RECONCILE and fresh a11y evidence per Experience Discipline.
- Added `agents/code-reviewer.md` - Senior Code Reviewer subagent definition. Frontmatter with example blocks for per-task and branch-level dispatch contexts. Six review blocks (plan alignment, code quality, architecture and design, documentation and standards, issue identification with Critical/Important/Suggestions tiers, communication protocol). Structured report format with "Done well" / "Plan-update recommendations" / "Notes for the coordinator" sections.
- Added `agents/design-reviewer.md` - Senior Experience Reviewer subagent definition. Harness-aware capability detection (browser automation, design-tool MCPs, a11y scanners, snapshot tools; falls back to structural review when none available). Six review blocks mirroring code-reviewer (artifact alignment, flow correctness, state completeness, accessibility assessment, voice and tone coherence, issue identification). Records tools used in "Methodology" section so the coordinator can understand evidence basis.

## [0.7.1] - 2026-04-17

Stage 6 hardening pass.

- TDD Related section now links to `design-driven-development` (reciprocal cross-reference; previously asymmetric).
- TDD exceptions list now binds to the Stage 4 `Exception: <kind> task - no failing test. Verification: ...` task-block convention: asking the human partner is not enough; the exception must be declared verbatim in the task block or the spec-reviewer flags it.
- TDD anti-patterns list gained "The Test Can't Fail, But It Passes" — the shape that most directly violates iron law 1 by being structurally incapable of RED.
- DDD DRAW step 3 loosened: if the plan explicitly names a UX spec round (`UX spec round <N>`), the spec must be at >= N; if the plan does not name a round, trust the spec's latest marker. Fixes the unperformable-check gap.
- DDD RECONCILE gained an intentional-cross-platform-divergence clause: for `Surfaces: cross-platform`, per-platform divergence declared in the UX spec's Per-platform adaptation section IS the artifact's truth for that platform; only undeclared divergence is silent drift.
- DDD DRAW gained an explanatory note covering the apparent duplication with Stage 5's Experience gate (inline path may skip, artifact could change between dispatch and execution, check 4 is unique to DRAW).
- systematic-debugging step 5 now requires a structured `Systematic-debugging record - task <N>` entry in the review log with root cause, falsifying test, hypothesis, fix, and regression coverage — Stage 7's code-reviewer greps for the entry to verify phase 1 occurred.
- accessibility-verification now declares a default WCAG level (2.2 AA when the UX spec is silent) and defines "critical" per tool (axe-core `critical`, Lighthouse audit-failed, pa11y ERROR; for manual walks: focus trap, unlabeled interactive, inaccessible state, color-only information).
- writing-plans header template now notes the optional `Product spec round <N>` / `UX spec round <N>` pin syntax that DDD uses.

## [0.7.0] - 2026-04-17

Stage 6 - Discipline overlay skills.

- Added `skills/test-driven-development/SKILL.md` - 6a.1 iron law (`NO PRODUCTION CODE WITHOUT A FAILING TEST FIRST`). Full RED-GREEN-REFACTOR cycle with "right reason" gate; five-step checklist; remedy-if-violated ("delete the code, implement fresh"); exceptions list (throwaway / generated / config) with human-partner-ask requirement; forbidden phrases; returns-to-caller semantics.
- Added `skills/test-driven-development/testing-anti-patterns.md` - catalogue of structural, timing, meaning, RED-phase, and REFACTOR-phase anti-patterns (Test Photocopy, Tautological, Snapshot-only, One Big Test, Fragile to Order, Magic-Sleep, Mocked Everything, etc.) with concrete fixes.
- Added `skills/systematic-debugging/SKILL.md` - 6a.2 iron law (`NO FIXES WITHOUT ROOT CAUSE INVESTIGATION FIRST`). Four sequential phases (root-cause investigation with "read the error message, then read it again", pattern analysis, falsifiable hypothesis formation, verification-and-fix); gate diagram; claim-to-evidence gate integrated with `verification-before-completion`; forbidden phrases.
- Added `skills/verification-before-completion/SKILL.md` - 6a.3 iron law (`NO COMPLETION CLAIMS WITHOUT FRESH VERIFICATION EVIDENCE`). IDENTIFY -> RUN -> READ -> VERIFY -> CLAIM gate; claim-to-evidence mapping table (Tests pass / Linter clean / Build succeeds / Type-check passes / Bug fixed / Regression test works / Agent completed / Requirements met / Merged / Deployed / Documented); "fresh" rule (current message, after the last change); forbidden phrases.
- Added `skills/design-driven-development/SKILL.md` - 6b.1 iron law (`NO USER-FACING SURFACE WITHOUT AN APPROVED DESIGN ARTIFACT FIRST`). DRAW-BUILD-RECONCILE cycle with four DRAW checks (file exists, approval marker present, round matches plan, surface covered); exception list; remedy-if-violated ("delete the surface, implement fresh"); no-silent-drift enforcement; forbidden phrases.
- Added `skills/accessibility-verification/SKILL.md` - 6b.2 iron law (`NO COMPLETION CLAIMS ON A USER-FACING SURFACE WITHOUT FRESH ACCESSIBILITY EVIDENCE`). IDENTIFY -> RUN -> READ -> VERIFY -> CLAIM gate; tool-agnostic (automated scan OR manual keyboard walk OR screen-reader narration); claim-to-evidence mapping extending 6a.3's table with surface-specific rows (UX complete, Accessible, Design matches spec, each state triggered, Permission-denied, Offline); forbidden phrases.

## [0.6.1] - 2026-04-17

Stage 5 hardening pass + upstream fixes.

- Added verbatim approval markers to `brainstorming` (`Product spec approved - round <N> - YYYY-MM-DD`) and `design-brainstorming` (`UX spec approved - round <N> - YYYY-MM-DD`) so the Stage 5 Experience gate can grep the spec file rather than relying on session state. Fixes iron-law-4 gate that was previously unrunnable after any session boundary.
- Stage 5 precondition check now greps both approval markers and verifies the feature branch is active (`git rev-parse --abbrev-ref HEAD` matches the recorded branch); wrong-branch routes back to `using-git-worktrees` rather than committing to `main`.
- Extended missing-successor fallback in `subagent-driven-development` to cover `agents/code-reviewer.md`, `agents/design-reviewer.md`, `systematic-debugging`, and the Stage 7 skills. Review passes against missing agent definitions are now blocked rather than silently fictional.
- Removed Stage 5's branch-level final reviewers (they duplicated Stage 7). Stage 5 now hands off to Stage 7 directly with a structured final-summary message; Stage 7 owns the branch-level review pass. `dev/stages/05-execute.md` updated to match.
- After any reviewer fix, ALL prior review passes re-run (not just the specific pass that returned findings). A quality fix can regress spec compliance; a design fix can regress either.
- Added explicit STOP conditions to `subagent-driven-development` matching the `executing-plans` enumeration (blocker, plan gap, unclear instruction, repeated rejection, out-of-scope finding, irresolvable reviewer conflict).
- Added implementer-failure routing to `systematic-debugging` (iron law 2); if that skill is not yet shipped, STOP rather than letting the implementer guess.
- Added re-dispatch discipline when an implementer asks a question: stash partial edits, answer, re-dispatch with explicit "discard prior partial edits" instruction, STOP after three questions on the same task.
- Added large-diff handling rule: reviews over ~300 lines split by file group.
- Added review-log writes (`docs/leyline/plans/<YYYY-MM-DD>-<feature-name>-review-log.md`) per task; Stage 7 consumes this for `{ACCESSIBILITY_EVIDENCE}`.
- Added conflict-resolution rule: spec reviewer wins when spec and quality reviewers disagree; if spec itself is wrong, loop back to `brainstorming`.
- Spec reviewer now INDEPENDENTLY re-runs the verification command (not just validates that output was pasted), checks a11y evidence for concreteness (tool output or keyboard-walk + screen-reader transcript; "looks fine on my machine" fails iron-law-5), and validates implementer-report field completeness.
- Implementer prompt now forbids vague deviation justifications ("necessary," "cleaner," "better," "required," "more idiomatic," "follows conventions"); must name a specific reason.
- Parallel-agents skill: terminology drift fixed (`EVERY session` -> `EVERY project`); explicit caller-invocation note added to `subagent-driven-development` Related section.
- Added `verification-before-completion` and `systematic-debugging` to `subagent-driven-development` Related section.
- `executing-plans` gained matching approval-marker preconditions, structured final-summary template, and extended missing-successor fallback.

## [0.6.0] - 2026-04-17

Stage 5 - Execute skills.

- Added `skills/subagent-driven-development/SKILL.md` - five-item precondition check including subagent-primitive availability, hard gate with "applies to EVERY project", core principle + "why subagents", per-task loop with up to four review passes (implementer / spec reviewer / code-quality reviewer / design reviewer when surfaces touched), final branch-level reviewer dispatches after all tasks complete, constructed-context rule, anti-patterns, forbidden phrases, named successor `requesting-code-review` (+ `requesting-design-review` when surfaces touched).
- Added `skills/subagent-driven-development/implementer-prompt.md` - subagent prompt template with paths, task-block verbatim, step discipline including TDD-first and non-code exception, structured report format.
- Added `skills/subagent-driven-development/spec-reviewer-prompt.md` - subagent prompt template with four named checks (TASK-BLOCK COMPLIANCE, PLAN-FILES COMPLIANCE, SPEC COMPLIANCE, FAILING-TEST DISCIPLINE) and "None." enforcement.
- Added `skills/subagent-driven-development/code-quality-reviewer-prompt.md` - wrapper around the canonical `code-reviewer` agent with per-task triage (Blocks task completion: yes/no); planned to dispatch `agents/code-reviewer.md` in Stage 7.
- Added `skills/executing-plans/SKILL.md` - the inline-execution fallback. Announce-on-entry explicitly advises switching to subagent dispatch when available. Hard gate requires confirming the subagent primitive is LITERALLY absent (not just inconvenient). Checklist includes pre-task experience gate, failing-test-first (or declared Exception), verification-matches-Expected halting rule, five stop conditions (blocker / plan gap / unclear instruction / repeated verification failure / out-of-scope finding).
- Added `skills/dispatching-parallel-agents/SKILL.md` - tactical skill invoked from within Stage 5 when 2+ genuinely independent problems surface. Hard gate requires four independence preconditions; pre-dispatch independence check; constructed-context-per-subagent rule with explicit anti-patterns against cross-subagent coordination. Returns control to the calling skill.

## [0.5.1] - 2026-04-17

Stage 4 hardening pass.

- Extended missing-successor fallback to cover `design-driven-development` and `accessibility-verification` (the overlay skills referenced by UX task blocks) so surface-touching plans halt visibly rather than shipping references to vapor skills.
- Added non-code-task exception to the failing-test-first rule: doc-only / CHANGELOG / config-only / CI-only / dependency-bump / formatting tasks may skip the failing-test step only when they declare the exception verbatim in the task block (`Exception: <kind> task - no failing test. Verification: ...`). Undeclared exceptions are findings.
- Replaced the `def function(input): ...` ellipsis in the code task template with a concrete runnable example (`normalize_input` returning `raw.strip().lower()`).
- Added explicit baseline-path extraction (`grep -E '^- Worktree path:' "$baseline_path" | sed 's/^- Worktree path:[[:space:]]*//'`) with a STOP clause when the line is missing or malformed.
- Standardized on `<feature-name>` across Stage 3 and Stage 4 (Stage 3 previously used `<topic>`). The slug is shared across product spec, UX spec, baseline note, and plan filenames.
- Reconciled gate and checklist: five preconditions counted consistently (feature-name resolution now part of the gate).
- Added 5-minute task-granularity heuristic (implementation block under ~20 lines, one production file, one-line verification, one decision point).
- Softened commit-message convention: task template defers to project `CONTRIBUTING.md` / `CLAUDE.md` / recent `git log`, falls back to `<Task N>: <component> - <summary>` only when none exists.
- UX task block now handles `N/A - <reason>` state-matrix cells verbatim and notes that reduced-template Surfaces (`developer-facing`, `cli-only`) only populate the states that appear in the UX spec's matrix.
- Split the revise loop into two branches: file-map revisions route back to the file-structure pass, task-only revisions route back to task writing.
- Added "dispatch unless literally unavailable" rebuttal to self-review step: token pressure / rate limits / session length are NOT legitimate fallback reasons.
- Added "NOT legitimate fallback" clause to the `executing-plans` successor.
- Extended plan-reviewer EXACT PATHS check with file-existence verification (`git cat-file -e HEAD:<path>` and `test -d <parent>`).
- Extended plan-reviewer COMPLETE CODE check: now flags `# TODO`, `# FIXME`, `# XXX`, `pass  # implement`, "follow the pattern in", "similar to", "mirrors the", "as discussed", "you know what to do".
- UX task RECONCILE step now routes divergence explicitly to `design-brainstorming` for re-approval.
- Line-range syntax in `Modify:` paths softened to advisory (`near <function-name>`) since line numbers go stale after first edit.
- Tech Stack field: added a "load-bearing" heuristic with concrete examples (Python 3.11 for `ExceptionGroup`, React 19 for `use()`).
- Added plan-overwrite guard at save step: STOP and ask the human partner if the plan file already exists.
- Promoted plan-reviewer HEADER FIELDS check to section 8 with same "None." enforcement; also verifies that referenced paths resolve.

## [0.5.0] - 2026-04-17

Stage 4 - Plan skill.

- Added `skills/writing-plans/SKILL.md` - precondition check with five items (topic resolution, product-spec marker, UX-spec marker / skip line, baseline note present, cwd inside worktree); hard gate with "applies to EVERY project"; core principle and load-bearing audience assumption (enthusiastic junior engineer with poor taste, no judgement, no project context, aversion to testing); scope check that splits independent subsystems; file-structure pass; task granularity rules (2-5 minutes, one action per step); required plan header with spec / UX / baseline references and Surfaces value; code task block template with failing-test-first TDD discipline; UX task block template with state-matrix-trigger-and-observe, accessibility-verification, DRAW-BUILD-RECONCILE; process diagram with revise-loop; self-review step with subagent reviewer; forbidden phrases; successor `subagent-driven-development` (preferred) or `executing-plans` (fallback); missing-successor fallback.
- Added `skills/writing-plans/plan-reviewer-prompt.md` - subagent prompt template with seven executor-readiness checks (task granularity, exact paths, complete code, failing-test discipline, UX task coverage, context assumptions, verification steps).

## [0.4.1] - 2026-04-17

Stage 3 hardening pass.

- Fixed placeholder-as-literal bug in the precondition grep: both marker checks now use explicit regex (`grep -E '^Deep-discovery pass complete - round [0-9]+ - [0-9]{4}-[0-9]{2}-[0-9]{2}$'`) rather than angle-bracket templates.
- Added `<topic>` derivation step (step 0) with missing-file routing: zero `*-design.md` files under `docs/leyline/specs/` routes to `brainstorming`, not `deep-discovery`.
- Split missing-spec vs missing-marker routing for both product and UX specs.
- Hard gate now covers working-tree-clean as a third clause and carries the "applies to EVERY project" universality line matching Stages 1 and 2.
- Working-tree check uses `--ignore-submodules=none` so dirty submodules are caught.
- Added nested-worktree detection (`git rev-parse --git-common-dir` != `git rev-parse --git-dir`) with explicit human-partner prompt.
- Inverted directory-selection priority: `CLAUDE.md` preference now beats `.worktrees/` / `worktrees/` folder existence. Broadened the CLAUDE.md grep (`director|folder|location|path|dir`) and instructed scanning of `## Worktrees`-style headings. `dev/stages/03-isolate.md` updated to match.
- Platform-aware global defaults: Linux `~/.config/leyline/...`, macOS `~/Library/Application Support/leyline/...`, Windows `%LOCALAPPDATA%\leyline\...`.
- Protected-branch handling for gitignore fix: STOP and ask rather than committing blindly.
- Branch-naming rules prescribed: strip `-design.md` suffix, lowercase, replace non-`[a-z0-9/-]`, validate with `git check-ref-format`.
- Base-ref discovery prescribed via `git symbolic-ref --short refs/remotes/origin/HEAD` with detached-HEAD STOP and `init.defaultBranch` fallback.
- Test- and setup-discovery orders prescribed (CLAUDE.md / Makefile / package.json / language-specific).
- Setup-failure framing reworded: not distinguishable from feature regressions; resolve or escalate.
- Removed "record in the plan" false choice: baseline always goes to `docs/leyline/plans/YYYY-MM-DD-<topic>-baseline.md` since the plan does not yet exist at this stage.
- Added verbatim `baseline-red-authorized - scope: <reason> - failing-tests: <count> - YYYY-MM-DD` template for authorized red-baseline proceed.
- Output artifacts now name Stage 8 as the consumer of the baseline note.
- Announce-on-entry strengthened with explicit STOP commitment.

## [0.4.0] - 2026-04-17

Stage 3 - Isolate skill.

- Added `skills/using-git-worktrees/SKILL.md` - precondition check that greps for the verbatim 2a and 2b completion markers (or the 2b skip line), hard gate with "Violating the letter..." preemption, priority-ordered directory selection (`.worktrees/` > `worktrees/` > `CLAUDE.md` preference > ask human partner), gitignore safety-verification gate that blocks creation until `git check-ignore -q` passes, branch-naming convention derived from the spec filename slug, green-baseline test gate that explicitly STOPs on a red baseline, recorded baseline note with worktree path / branch / base SHA / test-command result, Forbidden Phrases section, successor `writing-plans` with missing-successor fallback.

## [0.3.1] - 2026-04-17

Stage 2 hardening pass.

- Promoted both entry gates to `## Hard gate` fenced blocks with the "Violating the letter of the rules..." preemption, matching Stage 1 rendering.
- Removed the "or earlier" early-termination loophole from `deep-discovery/100-question-prompt.md`.
- Created `design-interrogation/report-template.md` to parallel 2a; added round-N storage convention for 2b UX-interrogation outputs (`docs/leyline/design/YYYY-MM-DD-<topic>-design-interrogation-round-<N>.md`).
- Fixed 2b decision tree: `single-screen-ui` now has its own "non-trivial state matrix" branch; secondary diamond relabeled accordingly.
- Added verbatim completion-marker lines to both skills (`Deep-discovery pass complete - round <N> - YYYY-MM-DD`, `Design-interrogation pass complete - round <N> - YYYY-MM-DD`).
- Made `Questions asked: N` / `Dimensions probed:` / `Chain anchors:` lines mandatory at the top of every report (subagent and inline).
- Added Q75 pivot and Q25/Q50/Q75 coherence anchors to both prompts.
- Added dimensions: `Cost / unit economics at target scale` and `Migration / backfill path for stateful features` to 2a; `Internationalization and text expansion` and `Perceived latency / loading budgets` to 2b.
- Added Forbidden Phrases section to 2b; expanded 2a's list.
- Added anti-patterns to both: "Subagents Are Available But I'll Run Inline To Save Time", "Reframe The Finding As A Strength". Added "Silent Edit To UX Spec, Skip Re-Approval" to 2b. Added "I'll Run It After The Next Step" to 2a.
- Tightened 2a materiality definition to "cannot survive the finding as written".
- Added cross-domain finding routing to 2a: product-domain findings loop to `brainstorming`, UX-domain findings loop to `design-brainstorming`.
- Defined "supports dispatch": the primitive exists; token pressure / rate limits / session length are NOT legitimate fallback reasons.
- Added inline-run transcript path conventions.
- Concretized Surfaces-dependent dimensions note in 2a prompt.
- Added Pass-audit "required for inline runs" block to both report templates; added sync comments between each SKILL.md dimensions list and its prompt counterpart.

## [0.3.0] - 2026-04-17

Stage 2 - Interrogate skills.

- Added `skills/deep-discovery/SKILL.md` - 100-question product-spec pressure test, subagent-dispatch-or-inline runner, three-section report format (Critical Issues / Strengths / Revised Proposal), materiality decision that loops back to `brainstorming` on material findings, entry-STOP gate, missing-successor fallback, named successor (`design-interrogation` when 2b warranted, otherwise `using-git-worktrees`).
- Added `skills/deep-discovery/100-question-prompt.md` - full subagent prompt template with dimension list, chain-of-reasoning rules, and report-format spec.
- Added `skills/deep-discovery/report-template.md` - blank report for inline runs.
- Added `skills/design-interrogation/SKILL.md` - 100-question UX-spec pressure test, when-to-invoke decision tree (required / optional / skipped per Surfaces), skip discipline (verbatim line in UX spec), focus areas (state completeness, failure paths, a11y realism, voice, platform conventions, a11y tree, cross-surface state, motion / color, copy density, IA coherence, per-platform divergence), three-section report format, material-revisions loop to `design-brainstorming`, successor `using-git-worktrees`.
- Added `skills/design-interrogation/100-question-prompt.md` - sibling subagent prompt template for UX-spec pressure testing.

## [0.2.0] - 2026-04-17

Stage 1 - Discovery skills.

- Added `skills/brainstorming/SKILL.md` - product spec hard gate, 11-step checklist (now with wait-for-answer on the visual-companion step and "and commit" on the save step), Surfaces field, decision and process diagrams (process diagram now has a "not approved -> revise" loop-back edge), anti-pattern preemption (expanded), successor-naming rule with missing-successor fallback.
- Added `skills/brainstorming/spec-document-reviewer-prompt.md` - subagent prompt template for spec hygiene review.
- Added `skills/brainstorming/visual-companion.md` - guidance for offering a visual companion at step 2; DOT rendering claim clarified, external-file path moved to the canonical `docs/leyline/specs/` location.
- Added `skills/design-brainstorming/SKILL.md` - UX spec hard gate with entry-STOP gate, per-Surfaces templates (developer-facing, cli-only, single-screen-ui, multi-screen-ui with IA at canonical position 4, cross-platform), 14-step checklist, state-matrix discipline (header now `Permission-denied`), voice examples, successor-naming rule with missing-successor fallback, "not approved -> revise" loop-back edge in the process diagram.
- Added `skills/design-brainstorming/ux-spec-reviewer-prompt.md` - sibling subagent prompt template with UX-specific completeness checks (state-matrix, voice examples, failure paths).
- Terminology pass: "user instructions" -> "human partner instructions" in brainstorming; "The user did not ask about states" -> "The human partner did not ask about states" in design-brainstorming red flags. Description field for `brainstorming` rewritten to open with "Use when" per skill-file-format convention.

## [0.1.0] - 2026-04-17

Initial scaffold.

- Repository skeleton: `skills/`, `agents/` (placeholder until Stage 7), `hooks/`, `scripts/`, `commands/`, `docs/`, `tests/`.
- Per-harness manifests at repo root: `CLAUDE.md`, `AGENTS.md`, `GEMINI.md`, `gemini-extension.json`. Pipeline tables and iron-law blocks held in sync by `scripts/check-manifests.sh`.
- Session-start hook wiring for Claude Code and Cursor with POSIX and Windows launchers. Cursor / Codex / OpenCode / Copilot CLI / Gemini CLI install paths shipped as alpha and explicitly marked unverified pending end-to-end validation.
- Entry skill `using-leyline` installed at `skills/using-leyline/SKILL.md`. Includes a missing-successor fallback that halts the pipeline rather than improvising past absent skills.
- Tool-name mapping references for Codex and Copilot CLI under `skills/using-leyline/references/`.
- Deprecated-redirector slash commands: `/brainstorm`, `/write-plan`, `/execute-plan`. Frontmatter `description` values quoted to satisfy strict YAML parsers.
- Spec, design, and plan archive directories under `docs/leyline/`.
- Line-ending and executable-bit hygiene: `.gitattributes` pins shell scripts to LF, the Windows launcher forces UTF-8 via `chcp 65001`, the version bump script strips CR before parsing.
- Version sync: `scripts/bump-version.sh` updates `package.json`, `gemini-extension.json`, and `.opencode/plugins/leyline.js` together.
- Stage 0 self-test at `scripts/check-stage-0.sh` and a tests-runner stub at `tests/run.sh`.
- PR template requires before/after pressure-test traces for skill changes and a checkbox for `dev/` corpus updates.
- MIT license and Code of Conduct.
