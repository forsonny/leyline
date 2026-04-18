#!/usr/bin/env bash
# Leyline manifest-drift lint.
#
# The iron-law block, terminology block, and pipeline table appear in multiple
# manifest files (CLAUDE.md, AGENTS.md, GEMINI.md, README.md, and the entry
# skill). They must stay in sync. This script extracts the iron-law block from
# each file and confirms the same five iron-law strings appear everywhere.
#
# Exit code:
#   0 - all manifests carry all five iron laws verbatim
#   1 - at least one manifest is missing or has drifted

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# Files that carry the iron laws and the first-response rule (the highest-leverage
# invariants). The README is human-facing but still ships these so installers
# read the same rules the agent reads.
FILES=(
    "$ROOT/CLAUDE.md"
    "$ROOT/AGENTS.md"
    "$ROOT/GEMINI.md"
    "$ROOT/README.md"
    "$ROOT/skills/using-leyline/SKILL.md"
)

# Files that carry the routing table and terminology block (agent-facing only;
# README does not duplicate routing or terminology since its audience is humans
# scanning for install steps, not agents executing the routing).
AGENT_FACING_FILES=(
    "$ROOT/CLAUDE.md"
    "$ROOT/AGENTS.md"
    "$ROOT/GEMINI.md"
    "$ROOT/skills/using-leyline/SKILL.md"
)

LAWS=(
    "NO PRODUCTION CODE WITHOUT A FAILING TEST FIRST"
    "NO FIXES WITHOUT ROOT CAUSE INVESTIGATION FIRST"
    "NO COMPLETION CLAIMS WITHOUT FRESH VERIFICATION EVIDENCE"
    "NO USER-FACING SURFACE WITHOUT AN APPROVED DESIGN ARTIFACT FIRST"
    "NO COMPLETION CLAIMS ON A USER-FACING SURFACE WITHOUT FRESH ACCESSIBILITY EVIDENCE"
)

# The first-response rule is the highest-leverage instruction in the plugin.
# It must appear verbatim in every manifest so every load path delivers it.
# Drift here is the same class of error as iron-law drift.
FIRST_RESPONSE_RULE="Before any response or action - including clarifying questions - check whether any Leyline skill applies. If one does (probability >= 1%), invoke it before narrating. If none does, name the skills you considered and why you rejected each."

# The 4-row routing table excerpts. Each manifest must carry these verbatim
# from skills/using-leyline/SKILL.md so the entry-skill mapping is identical
# everywhere. Lint substring-matches the entry-skill cell of each row plus the
# distinguishing left-cell phrase. (The full row text varies by harness's
# Markdown table formatting; substring matches the load-bearing tokens.)
ROUTING_ROWS=(
    "let's build X"
    "brainstorming"
    "fix this bug"
    "systematic-debugging"
    "review this code"
    "requesting-code-review"
    "execute the plan"
    "subagent-driven-development"
)

# Load-bearing terminology terms. Each manifest must carry these so the
# terminology block stays in sync.
TERMINOLOGY_TERMS=(
    "human partner"
    "Discovery"
    "Experience"
    "UX artifact"
)

# Hook-failure detection paragraph anchor. Must appear in all manifests
# (not the entry skill, which is the thing being detected as missing).
HOOK_FAILURE_ANCHOR="Hook-failure detection"
HOOK_FAILURE_FILES=(
    "$ROOT/CLAUDE.md"
    "$ROOT/AGENTS.md"
    "$ROOT/GEMINI.md"
)

fail=0

for file in "${FILES[@]}"; do
    if [[ ! -f "$file" ]]; then
        echo "MISSING: $file" >&2
        fail=1
        continue
    fi

    for law in "${LAWS[@]}"; do
        if ! grep -qF "$law" "$file"; then
            echo "DRIFT:   $file does not contain iron law: $law" >&2
            fail=1
        fi
    done

    if ! grep -qF "$FIRST_RESPONSE_RULE" "$file"; then
        echo "DRIFT:   $file does not contain the first-response rule verbatim" >&2
        fail=1
    fi
done

# Routing and terminology are agent-facing invariants - they appear in the three
# manifests and the entry skill, but NOT the README (which is human-facing).
for file in "${AGENT_FACING_FILES[@]}"; do
    for row in "${ROUTING_ROWS[@]}"; do
        if ! grep -qF "$row" "$file"; then
            echo "DRIFT:   $file does not contain routing token: $row" >&2
            fail=1
        fi
    done

    for term in "${TERMINOLOGY_TERMS[@]}"; do
        if ! grep -qF "$term" "$file"; then
            echo "DRIFT:   $file does not contain terminology term: $term" >&2
            fail=1
        fi
    done
done

# Hook-failure detection lives only in the three manifests (not the entry skill,
# since the entry skill IS what the agent fails to find when the hook breaks;
# not the README, which is human-facing).
for file in "${HOOK_FAILURE_FILES[@]}"; do
    if ! grep -qF "$HOOK_FAILURE_ANCHOR" "$file"; then
        echo "DRIFT:   $file does not contain Hook-failure detection section" >&2
        fail=1
    fi
done

if [[ "$fail" -eq 0 ]]; then
    echo "OK: iron laws + first-response rule + routing table + terminology + hook-failure detection all in sync."
    exit 0
fi

echo "" >&2
echo "Manifest drift detected. Update the affected manifest(s) so the iron laws, first-response rule, routing table, terminology, and hook-failure detection all appear verbatim, then re-run." >&2
exit 1
