# Session-start hook reference

How the plugin forces skill-checking before the agent's first response in every new or reset session.

## Files

- `hooks/hooks.json` — Claude Code hook registration
- `hooks/hooks-cursor.json` — Cursor hook registration
- `hooks/run-hook.cmd` — Windows launcher
- `hooks/session-start` — POSIX launcher

## Claude Code registration

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

## Event matcher

`startup|clear|compact` — regex union covering:
- **startup** — new session
- **clear** — user manually cleared context
- **compact** — harness auto-compacted on approach to context limit

All three events drop conversation context, so the hook must re-inject the entry skill each time.

## Runtime variable

`${CLAUDE_PLUGIN_ROOT}` is set by the harness to the plugin install directory. The launcher path is absolute relative to that variable, so installation location doesn't matter.

## Sync requirement

`async: false` — the hook must complete before the model replies. If it ran async, the model could produce its first token before the entry skill was in context, defeating the whole point.

## Launcher behavior

Both launchers (`run-hook.cmd` and `session-start`) are minimal dispatchers. Called with argument `session-start`, they print the content of the `using-leyline` entry skill to stdout. The harness reads stdout and injects the text as system context.

## What the entry skill does

`using-leyline` is the introduction to the skills system. It instructs the agent to:

- Check for relevant skills before any response, including clarifying questions
- Invoke skills with probability threshold "1%" — if there is even a 1% chance a skill applies, invoke it
- Announce skill invocation explicitly ("Using [skill] to [purpose]")
- Follow skill checklists by creating `TodoWrite` entries per item
- Treat skills as overrides of default system prompt behavior where they conflict
- Respect user instructions as highest priority (CLAUDE.md > skills > default system prompt)

## Debug checklist

If skills aren't activating:
1. Verify the hook is registered for the harness in use (`hooks.json` vs `hooks-cursor.json`)
2. Verify `${CLAUDE_PLUGIN_ROOT}` resolves to the correct install path
3. Verify the launcher is executable (POSIX) or the `.cmd` is discoverable (Windows)
4. Run the launcher manually with `session-start` to confirm it prints the entry skill
5. Verify the `using-leyline` skill's frontmatter is under 1024 chars (truncation would break it)

## Related

- `structure/hooks.md` — directory-level summary
- `structure/skills.md` — the `using-leyline` entry skill row
- `reference/harness-matrix.md` — per-harness hook support
- `reference/skill-file-format.md` — frontmatter limits
