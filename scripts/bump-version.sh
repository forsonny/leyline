#!/usr/bin/env bash
# Leyline version bump helper.
#
# Usage:
#     scripts/bump-version.sh <patch|minor|major|X.Y.Z>
#
# Edits the versioned manifests, appends a stub entry to CHANGELOG.md,
# syncs the README badge, and prints a reminder to update RELEASE-NOTES.md
# for significant releases.

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
ROOT_PLUGIN="$ROOT/plugin.json"
CLAUDE_PLUGIN="$ROOT/.claude-plugin/plugin.json"
README="$ROOT/README.md"

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

# Sync root plugin.json version
if [[ -f "$ROOT_PLUGIN" ]]; then
    tmp="$ROOT_PLUGIN.tmp"
    sed -E "s/(\"version\"[[:space:]]*:[[:space:]]*)\"[^\"]+\"/\1\"${new}\"/" "$ROOT_PLUGIN" > "$tmp"
    mv "$tmp" "$ROOT_PLUGIN"
fi

# Sync .claude-plugin/plugin.json version
if [[ -f "$CLAUDE_PLUGIN" ]]; then
    tmp="$CLAUDE_PLUGIN.tmp"
    sed -E "s/(\"version\"[[:space:]]*:[[:space:]]*)\"[^\"]+\"/\1\"${new}\"/" "$CLAUDE_PLUGIN" > "$tmp"
    mv "$tmp" "$CLAUDE_PLUGIN"
fi

# Sync README badge version
if [[ -f "$README" ]]; then
    tmp="$README.tmp"
    sed -E \
        -e "s/\[!\[Version: [^]]+\]\(https:\/\/img\.shields\.io\/badge\/Version-[^)]+-green\.svg\)\]/[![Version: ${new}](https:\/\/img.shields.io\/badge\/Version-${new}-green.svg)]/" \
        "$README" > "$tmp"
    mv "$tmp" "$README"
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
