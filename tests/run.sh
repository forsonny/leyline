#!/usr/bin/env bash
# Leyline test runner.
#
# Pressure-test scenarios are markdown files under tests/<group>/ describing a
# situation and the expected agent behavior. This runner lints scenario files
# for format compliance and lists them for manual execution. Full automated
# dispatch across harnesses is out of scope for v0.x; scenarios are run
# interactively in a target harness and the Outcome section is updated with
# the observed trace.
#
# Usage:
#     tests/run.sh [--lint] [--list] [--group <group>]
#
# Flags:
#     --lint         Check scenario files for required sections; exit non-zero on drift.
#     --list         List all scenario files (default).
#     --group <name> Restrict to one group (e.g., skill-triggering).

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TESTS="$ROOT/tests"
MODE="list"
GROUP=""

while [[ $# -gt 0 ]]; do
    case "$1" in
        --lint) MODE="lint"; shift ;;
        --list) MODE="list"; shift ;;
        --group) GROUP="$2"; shift 2 ;;
        *) echo "Unknown flag: $1" >&2; exit 2 ;;
    esac
done

if [[ -n "$GROUP" ]]; then
    TARGET="$TESTS/$GROUP"
    [[ -d "$TARGET" ]] || { echo "No such test group: $GROUP" >&2; exit 2; }
else
    TARGET="$TESTS"
fi

mapfile -t SCENARIOS < <(find "$TARGET" -type f -name '*.md' -not -name 'README.md' 2>/dev/null | sort)

if [[ "${#SCENARIOS[@]}" -eq 0 ]]; then
    echo "No scenarios found under: $TARGET"
    echo ""
    echo "Add scenario files following the format in tests/README.md."
    exit 0
fi

case "$MODE" in
    list)
        echo "Discovered ${#SCENARIOS[@]} scenario file(s):"
        for s in "${SCENARIOS[@]}"; do echo "  $s"; done
        echo ""
        echo "Automation is not yet wired. Run each scenario manually by:"
        echo "  1. Loading the relevant skill set into your harness"
        echo "  2. Pasting the Scenario section as the human partner's first message"
        echo "  3. Confirming the agent's behavior matches the Expected section"
        echo "  4. Capturing the trace into the Outcome section and committing"
        echo ""
        echo "See docs/testing.md and skills/writing-skills/testing-skills-with-subagents.md."
        ;;

    lint)
        # Required sections for every scenario file.
        REQUIRED=(
            "^## Scenario$"
            "^## Expected behavior$"
            "^## Forbidden phrases check$"
            "^## Skills loaded$"
            "^## RED baseline$"
            "^## Outcome$"
            "^## Related$"
        )

        fail=0
        for s in "${SCENARIOS[@]}"; do
            file_fail=0
            for section_regex in "${REQUIRED[@]}"; do
                if ! grep -qE "$section_regex" "$s"; then
                    echo "MISSING SECTION: $s  ($section_regex)" >&2
                    file_fail=1
                fi
            done
            if [[ "$file_fail" -eq 0 ]]; then
                echo "OK: $s"
            else
                fail=1
            fi
        done

        [[ "$fail" -eq 0 ]] || exit 1
        ;;
esac
