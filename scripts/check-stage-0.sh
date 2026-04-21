#!/usr/bin/env bash
# Leyline Stage 0 self-test.
#
# Validates the structural invariants Stage 0 ships:
#   - required directories exist
#   - required files exist
#   - per-skill SKILL.md frontmatter is under 1024 bytes and has name+description
#   - version field is consistent across package.json, gemini-extension.json,
#     plugin.json, .claude-plugin/plugin.json, .codex-plugin/plugin.json,
#     .opencode/plugins/leyline.js, and the README badge
#   - shell scripts are executable in the index (or this is a fresh repo)
#   - manifest iron-law sync passes
#
# Exit code:
#   0 - all invariants hold
#   1 - at least one invariant failed

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
fail=0

check_path () {
    local path="$1"
    local kind="$2"
    if [[ "$kind" == "dir" && ! -d "$ROOT/$path" ]]; then
        echo "MISSING DIR:  $path" >&2
        fail=1
    elif [[ "$kind" == "file" && ! -f "$ROOT/$path" ]]; then
        echo "MISSING FILE: $path" >&2
        fail=1
    fi
}

# Required directories
for d in skills agents hooks scripts commands docs tests \
         docs/leyline/specs docs/leyline/design docs/leyline/plans \
         docs/windows .github .codex .opencode/plugins .agents \
         .agents/plugins .codex-plugin; do
    check_path "$d" dir
done

# Required root files
for f in package.json CHANGELOG.md RELEASE-NOTES.md LICENSE README.md \
         CODE_OF_CONDUCT.md CLAUDE.md AGENTS.md GEMINI.md gemini-extension.json \
         .gitattributes .gitignore; do
    check_path "$f" file
done

# Required plugin manifests
for f in plugin.json .claude-plugin/plugin.json .codex-plugin/plugin.json \
         .agents/plugins/marketplace.json .github/plugin/marketplace.json; do
    check_path "$f" file
done

# Required hook files
for f in hooks/hooks.json hooks/hooks-cursor.json hooks/run-hook.cmd hooks/session-start; do
    check_path "$f" file
done

# Required entry skill
check_path "skills/using-leyline/SKILL.md" file
check_path "skills/using-leyline/references/codex-tools.md" file
check_path "skills/using-leyline/references/copilot-tools.md" file

# Required scripts
for f in scripts/bump-version.sh scripts/check-manifests.sh scripts/check-stage-0.sh; do
    check_path "$f" file
done

# Required commands
for f in commands/brainstorm.md commands/write-plan.md commands/execute-plan.md; do
    check_path "$f" file
done

# Frontmatter check on every SKILL.md present
while IFS= read -r -d '' skill; do
    if ! head -n 1 "$skill" | grep -q '^---'; then
        echo "FRONTMATTER: $skill missing leading ---" >&2
        fail=1
        continue
    fi

    fm=$(awk '/^---$/{c++; print; next} c==1{print} c==2{exit}' "$skill")
    fm_bytes=$(printf '%s' "$fm" | wc -c | tr -d ' ')
    if [[ "$fm_bytes" -gt 1024 ]]; then
        echo "FRONTMATTER: $skill frontmatter is $fm_bytes bytes (limit 1024)" >&2
        fail=1
    fi

    if ! printf '%s' "$fm" | grep -q '^name:'; then
        echo "FRONTMATTER: $skill missing name:" >&2
        fail=1
    fi

    if ! printf '%s' "$fm" | grep -q '^description:'; then
        echo "FRONTMATTER: $skill missing description:" >&2
        fail=1
    fi
done < <(find "$ROOT/skills" -type f -name SKILL.md -print0 2>/dev/null)

# Version sync
pkg_ver=$(grep -E '"version"' "$ROOT/package.json" | head -n 1 | sed -E 's/.*"version"[[:space:]]*:[[:space:]]*"([^"]+)".*/\1/' | tr -d '\r')
ext_ver=$(grep -E '"version"' "$ROOT/gemini-extension.json" | head -n 1 | sed -E 's/.*"version"[[:space:]]*:[[:space:]]*"([^"]+)".*/\1/' | tr -d '\r')
shim_ver=$(grep -E 'version:' "$ROOT/.opencode/plugins/leyline.js" | head -n 1 | sed -E 's/.*version:[[:space:]]*"([^"]+)".*/\1/' | tr -d '\r')
root_plugin_ver=$(grep -E '"version"' "$ROOT/plugin.json" | head -n 1 | sed -E 's/.*"version"[[:space:]]*:[[:space:]]*"([^"]+)".*/\1/' | tr -d '\r')
claude_plugin_ver=$(grep -E '"version"' "$ROOT/.claude-plugin/plugin.json" | head -n 1 | sed -E 's/.*"version"[[:space:]]*:[[:space:]]*"([^"]+)".*/\1/' | tr -d '\r')
codex_plugin_ver=$(grep -E '"version"' "$ROOT/.codex-plugin/plugin.json" | head -n 1 | sed -E 's/.*"version"[[:space:]]*:[[:space:]]*"([^"]+)".*/\1/' | tr -d '\r')
readme_badge_ver=$(grep -Eo 'Version-[0-9]+\.[0-9]+\.[0-9]+-green\.svg' "$ROOT/README.md" | head -n 1 | sed -E 's/^Version-([0-9]+\.[0-9]+\.[0-9]+)-green\.svg$/\1/' | tr -d '\r')

if [[ "$pkg_ver" != "$ext_ver" || "$pkg_ver" != "$shim_ver" || "$pkg_ver" != "$root_plugin_ver" || "$pkg_ver" != "$claude_plugin_ver" || "$pkg_ver" != "$codex_plugin_ver" || "$pkg_ver" != "$readme_badge_ver" ]]; then
    echo "VERSION DRIFT: package.json=$pkg_ver gemini-extension.json=$ext_ver plugin.json=$root_plugin_ver .claude-plugin/plugin.json=$claude_plugin_ver .codex-plugin/plugin.json=$codex_plugin_ver .opencode/plugins/leyline.js=$shim_ver README.md=$readme_badge_ver" >&2
    fail=1
fi

# Manifest iron-law sync (delegated)
if [[ -x "$ROOT/scripts/check-manifests.sh" ]]; then
    if ! "$ROOT/scripts/check-manifests.sh" >/dev/null 2>&1; then
        echo "MANIFEST DRIFT: scripts/check-manifests.sh failed; re-run for details" >&2
        fail=1
    fi
elif [[ -f "$ROOT/scripts/check-manifests.sh" ]]; then
    if ! bash "$ROOT/scripts/check-manifests.sh" >/dev/null 2>&1; then
        echo "MANIFEST DRIFT: scripts/check-manifests.sh failed; re-run for details" >&2
        fail=1
    fi
fi

# Executable bit on POSIX shell scripts (only meaningful inside a git repo)
if [[ -d "$ROOT/.git" ]]; then
    for script in hooks/session-start scripts/bump-version.sh scripts/check-manifests.sh scripts/check-stage-0.sh; do
        if ! git -C "$ROOT" ls-files --stage -- "$script" 2>/dev/null | awk '{print $1}' | grep -q '^100755$'; then
            echo "EXEC BIT:    $script is not marked +x in the git index (run: git update-index --chmod=+x $script)" >&2
            fail=1
        fi
    done
fi

if [[ "$fail" -eq 0 ]]; then
    echo "OK: Stage 0 invariants hold."
    exit 0
fi

echo "" >&2
echo "Stage 0 self-test failed. Address the items above and re-run." >&2
exit 1
