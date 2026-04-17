#!/usr/bin/env bash
# Leyline version bump helper.
#
# Usage:
#     scripts/bump-version.sh <patch|minor|major|X.Y.Z>
#
# Edits package.json's version, appends a stub entry to CHANGELOG.md,
# and prints a reminder to update RELEASE-NOTES.md for significant releases.

set -euo pipefail

MODE="${1:-}"
if [[ -z "$MODE" ]]; then
    echo "Usage: $0 <patch|minor|major|X.Y.Z>" >&2
    exit 2
fi

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PKG="$ROOT/package.json"
CHANGELOG="$ROOT/CHANGELOG.md"
GEMINI_EXT="$ROOT/gemini-extension.json"
OPENCODE_SHIM="$ROOT/.opencode/plugins/leyline.js"

current=$(grep -E '"version"' "$PKG" | head -n 1 | sed -E 's/.*"version"[[:space:]]*:[[:space:]]*"([^"]+)".*/\1/' | tr -d '\r')
IFS='.' read -r MAJ MIN PAT <<< "$current"

case "$MODE" in
    major) MAJ=$((MAJ + 1)); MIN=0; PAT=0 ;;
    minor) MIN=$((MIN + 1)); PAT=0 ;;
    patch) PAT=$((PAT + 1)) ;;
    *.*.*) MAJ="${MODE%%.*}"; rest="${MODE#*.}"; MIN="${rest%%.*}"; PAT="${rest#*.}" ;;
    *) echo "Unknown mode: $MODE" >&2; exit 2 ;;
esac

new="${MAJ}.${MIN}.${PAT}"
today=$(date +%Y-%m-%d)

# Update package.json version
tmp="$PKG.tmp"
sed -E "s/(\"version\"[[:space:]]*:[[:space:]]*)\"[^\"]+\"/\1\"${new}\"/" "$PKG" > "$tmp"
mv "$tmp" "$PKG"

# Sync gemini-extension.json version
if [[ -f "$GEMINI_EXT" ]]; then
    tmp="$GEMINI_EXT.tmp"
    sed -E "s/(\"version\"[[:space:]]*:[[:space:]]*)\"[^\"]+\"/\1\"${new}\"/" "$GEMINI_EXT" > "$tmp"
    mv "$tmp" "$GEMINI_EXT"
fi

# Sync .opencode/plugins/leyline.js version field
if [[ -f "$OPENCODE_SHIM" ]]; then
    tmp="$OPENCODE_SHIM.tmp"
    sed -E "s/(version:[[:space:]]*)\"[^\"]+\"/\1\"${new}\"/" "$OPENCODE_SHIM" > "$tmp"
    mv "$tmp" "$OPENCODE_SHIM"
fi

# Prepend changelog stub under the top-level heading
stub="## [${new}] - ${today}\n\n- (describe user-visible changes)\n\n"
awk -v stub="$stub" '
    NR == 1 { print; next }
    !done && /^## / { printf "%s", stub; done = 1 }
    { print }
' "$CHANGELOG" > "$CHANGELOG.tmp"
mv "$CHANGELOG.tmp" "$CHANGELOG"

echo "Bumped leyline: ${current} -> ${new}"
echo "CHANGELOG.md: stub entry added for ${new}. Fill it in before committing."
echo "RELEASE-NOTES.md: extend for significant releases."
