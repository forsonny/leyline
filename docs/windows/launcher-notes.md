# Windows launcher notes

Leyline's session-start hook uses two launchers:

- `hooks/run-hook.cmd` - Windows (batch)
- `hooks/session-start` - POSIX (bash)

Both read an action argument (`session-start`) and print the entry skill `skills/using-leyline/SKILL.md` to stdout. The harness captures stdout and injects it as system context.

## Required: line-ending hygiene on Windows clones

Windows clones with `core.autocrlf=true` (the install default) convert `hooks/session-start` and `scripts/bump-version.sh` to CRLF. POSIX `bash` then errors out with `bad interpreter: /usr/bin/env bash^M`. Two safeguards are in place:

1. The repo ships a `.gitattributes` file pinning shell scripts and the POSIX launcher to LF on every platform.
2. POSIX launchers and shell scripts must be marked executable in the index. After `git init` (or after cloning if the bit was lost), run:

   ```
   git update-index --chmod=+x hooks/session-start scripts/bump-version.sh
   ```

If you maintain a Windows clone for development and have not configured `.gitattributes` to take effect on existing files, run `git add --renormalize .` once after cloning to apply the line-ending rules.

## Path handling

- The Windows launcher resolves `%~dp0..` to the plugin root. `%~dp0` ends with a trailing backslash, so `..` is appended without an extra separator.
- Paths in `hooks.json` use `${CLAUDE_PLUGIN_ROOT}`; the harness substitutes the install location. On Windows, this resolves to a path with backslashes.
- Spaces in install paths are safe because `hooks.json` quotes the command string.

## PowerShell vs cmd

`run-hook.cmd` is a classic batch script; it runs on both `cmd.exe` and PowerShell. No PowerShell-specific features are used.

## Newlines and output encoding

- Skills use LF line endings. `type` on Windows preserves them when piping to stdout.
- If a harness complains about CRLF injection, check that the local clone has not converted line endings. Configure `core.autocrlf=false` on the Leyline working copy.

## Common problems

- **The hook does not fire on new sessions.** Verify `hooks.json` is registered by the harness. Restart the harness after install.
- **The hook fires but the entry skill never appears.** Run `hooks\run-hook.cmd session-start` manually; the output should be the full `using-leyline` skill text. If it is empty, check that the `skills/using-leyline/SKILL.md` path exists and is readable.
- **The hook fires but the model replies before the skill is injected.** Confirm `async: false` in `hooks.json`. Asynchronous hooks do not block the model.
- **POSIX users get `bad interpreter: /usr/bin/env bash^M`.** `core.autocrlf=true` rewrote LF to CRLF in shell scripts. Apply the line-ending hygiene section above.

## Related

- `../../hooks/run-hook.cmd`
- `../../hooks/session-start`
- `../../hooks/hooks.json`
- `../../reference/session-start-hook.md`
