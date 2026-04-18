# Per-harness manifests (repo root)

Each supported harness (Claude Code, Cursor, Codex, OpenCode, Copilot CLI, Gemini CLI) reads a specific entry file at the repo root to discover skills, agents, and hooks.

## Files

| File | Harness | Role |
|------|---------|------|
| `CLAUDE.md` | Claude Code (also serves as the contributor guidelines for the repo) | Entry file + project rules |
| `AGENTS.md` | Codex and other AGENTS.md-reading harnesses | Entry file |
| `GEMINI.md` | Gemini CLI | Entry file with platform adaptation notes |
| `gemini-extension.json` | Gemini CLI | Extension manifest (discovery/metadata) |
| `README.md` | Humans | Installation and philosophy |

## Manifest content

`AGENTS.md`, `CLAUDE.md`, and `GEMINI.md` are independent regular files. They share substantial content (first-response rule, iron laws, hook-failure detection, routing, pipeline table, terminology) but are not symlinks; each carries harness-specific framing (tool-name mapping notes for AGENTS.md and GEMINI.md; contributor guidelines in CLAUDE.md). A drift lint (`scripts/check-manifests.sh`) keeps the shared sections in sync.

## Drift-lint coverage

`scripts/check-manifests.sh` enforces these invariants as substring matches:

| Invariant | Files covered |
|-----------|---------------|
| Five iron laws (each, verbatim) | `CLAUDE.md`, `AGENTS.md`, `GEMINI.md`, `README.md`, `skills/using-leyline/SKILL.md` |
| First-response rule (verbatim) | Same five files |
| Routing-table tokens (4 row keys + 4 entry-skill names) | `CLAUDE.md`, `AGENTS.md`, `GEMINI.md`, `skills/using-leyline/SKILL.md` (NOT README, which is human-facing) |
| Terminology terms ("human partner", "Discovery", "Experience", "UX artifact") | Same agent-facing four files |
| "Hook-failure detection" anchor | `CLAUDE.md`, `AGENTS.md`, `GEMINI.md` only (entry skill is the thing being detected as missing; README is human-facing) |

Running the lint:

```
bash scripts/check-manifests.sh
```

Exits 0 on success, 1 on any drift, with `DRIFT:` lines naming the missing invariants per file.

## Manifest section ordering

After the v1.0.x manifest behavior-shaping pass (Patch B), all three manifests follow the same load-bearing-first ordering:

1. Title + one-line purpose
2. **First-response rule** (highest leverage; appears in every load path)
3. **Iron laws**
4. **Hook-failure detection**
5. **Routing - where to enter** (4-row table)
6. **Pipeline (stages in order)**
7. **Terminology**
8. How [agent] should use this plugin
9. Discovery (file layout)
10. Platform adaptation (tool-name mapping)
11. Contributor rules (CLAUDE.md only)
12. Related

Sections 2-7 are the load-bearing block. Sections 8-12 are orientation that supports the load-bearing block but does not itself bind agent behavior.

## Contributor content in `CLAUDE.md`

The project's `CLAUDE.md` doubles as strict contributor guidelines. Notable rules:
- 94% PR rejection rate; most rejected PRs are agent-submitted "slop"
- Every PR must read and fully complete `.github/PULL_REQUEST_TEMPLATE.md`
- Search for duplicate PRs (open AND closed) before submitting
- "Compliance" changes to skills require extensive eval evidence
- No third-party dependencies unless adding a new harness
- No domain-specific skills — those belong in standalone plugins
- No speculative/theoretical fixes; real problems only
- Skills are behavior-shaping code; modifications require before/after eval evidence

## Related

- `structure/hooks.md` — how `hooks.json` / `hooks-cursor.json` complement the manifests
- `reference/harness-matrix.md` — per-harness feature availability
- `principles/behavior-shaping.md` — why terminology/discipline in these files is treated as load-bearing
