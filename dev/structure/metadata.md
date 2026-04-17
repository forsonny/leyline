# Repo metadata (root files)

Files at the repo root that describe the package rather than its behavior.

## `package.json`

```json
{
  "name": "leyline",
  "version": "0.1.0",
  "type": "module",
  "main": ".opencode/plugins/leyline.js"
}
```

Minimal manifest. The `main` entry points at an OpenCode plugin shim. The `type: module` is ESM. The `name` is what marketplace installers register; the `version` is bumped by `scripts/bump-version.sh`.

## `CHANGELOG.md`

Per-release entries, newest first. Each entry describes user-visible changes (new skills, skill behavior updates, hook changes, harness support). Kept short and factual.

## `RELEASE-NOTES.md`

Longer-form notes for significant releases. Pairs with `CHANGELOG.md`: the changelog is the audit log, the release notes are the narrative.

## `LICENSE`

MIT.

## `CODE_OF_CONDUCT.md`

Community standards. Referenced by the README's Community section.

## `README.md`

Entry for humans. Covers what the plugin does, install steps per harness, the basic workflow, what's inside, and contributor pointers.

## Release lifecycle

1. Finish work via the usual pipeline (brainstorm → ... → finish)
2. `scripts/bump-version.sh` bumps `package.json` version
3. Update `CHANGELOG.md` (final step in any work, per CLAUDE.md global rules)
4. If significant, extend `RELEASE-NOTES.md`
5. Tag and publish to the marketplace

## Related

- `structure/scripts.md` — `bump-version.sh` details
- `structure/manifests.md` — per-harness manifests that sit alongside these metadata files at root
