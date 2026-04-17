# `hooks/` — session-start wiring

**Location:** `hooks/` at the repo root.
**Files:**
- `hooks.json` — hook registration (Claude Code format)
- `hooks-cursor.json` — hook registration (Cursor format)
- `run-hook.cmd` — Windows launcher
- `session-start` — POSIX launcher (executable)

## What the hook does

Registers a `SessionStart` hook that runs on `startup`, `clear`, and `compact` events. The hook prints the entry skill's content (the `using-leyline` skill) to stdout so the harness injects it as system context before the model's first token of reply. This is what makes skill-checking automatic instead of opt-in.

## `hooks.json` (Claude Code)

```json
{
  "hooks": {
    "SessionStart": [
      {
        "matcher": "startup|clear|compact",
        "hooks": [
          {
            "type": "command",
            "command": "\"${CLAUDE_PLUGIN_ROOT}/hooks/run-hook.cmd\" session-start",
            "async": false
          }
        ]
      }
    ]
  }
}
```

Key fields:
- `matcher` — regex on event name; covers new sessions, manual clears, and auto-compaction
- `type: command` — shell command hook
- `command` — calls the cross-platform launcher with a `session-start` argument
- `async: false` — must complete before the model responds

## `hooks-cursor.json`

Equivalent registration in Cursor's hook format. Same entry-skill injection, different JSON shape.

## Launchers

- `run-hook.cmd` — Windows batch launcher; dispatches to the `session-start` action
- `session-start` — POSIX shell script; same behavior for Linux/macOS

Both print the contents of the entry skill to stdout.

## Why it matters

The entry skill (`using-leyline`) mandates skill-checking before the agent's first response, including clarifying questions. Without the hook, the agent would only see the skill if someone manually attached it. The hook removes that gap.

## Related

- `reference/session-start-hook.md` — deeper wiring-level reference
- `structure/skills.md` — `using-leyline` is the entry skill injected by the hook
- `reference/harness-matrix.md` — per-harness hook support
