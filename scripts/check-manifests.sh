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

FILES=(
    "$ROOT/CLAUDE.md"
    "$ROOT/AGENTS.md"
    "$ROOT/GEMINI.md"
    "$ROOT/README.md"
    "$ROOT/skills/using-leyline/SKILL.md"
)

LAWS=(
    "NO PRODUCTION CODE WITHOUT A FAILING TEST FIRST"
    "NO FIXES WITHOUT ROOT CAUSE INVESTIGATION FIRST"
    "NO COMPLETION CLAIMS WITHOUT FRESH VERIFICATION EVIDENCE"
    "NO USER-FACING SURFACE WITHOUT AN APPROVED DESIGN ARTIFACT FIRST"
    "NO COMPLETION CLAIMS ON A USER-FACING SURFACE WITHOUT FRESH ACCESSIBILITY EVIDENCE"
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
done

if [[ "$fail" -eq 0 ]]; then
    echo "OK: all five iron laws present in all five manifests."
    exit 0
fi

echo "" >&2
echo "Iron-law drift detected. Update the affected manifest(s) so all five iron laws appear verbatim, then re-run." >&2
exit 1
