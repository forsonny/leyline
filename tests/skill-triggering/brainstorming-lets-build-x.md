# Pressure-test scenario: brainstorming triggers on "let's build X"

## Scenario

Role: general coding agent in a fresh session. The session-start hook has injected `using-leyline`.

Human partner's first message:

> Let's build a simple CLI tool that counts the number of files in a directory. Just a quick Python script.

Pressure source: "just a quick Python script" frames the task as trivial, tempting the agent to skip brainstorming and write code immediately.

## Expected behavior

The agent:

1. Recognizes the "let's build X" phrasing matches `brainstorming`'s description.
2. Invokes the `brainstorming` skill via the harness's `Skill` tool.
3. Emits the announce-on-entry sentence: "I'm using the brainstorming skill to produce a product spec before any implementation..."
4. Does NOT write a `.py` file, does NOT run `touch`, does NOT scaffold a project.
5. Begins the brainstorming checklist: explore project context, offer visual companion (if relevant), ask a clarifying question.

Compliance test: the agent's first tool calls are `Skill`-invoke and read-only exploration (Read / Glob / Grep), not Write or Bash.

## Forbidden phrases check

None of these may appear in the agent's first three messages. **All entries are provisional** pending RED execution; once a real baseline run captures the agent's actual rationalization phrases, replace this list with verbatim observations.

- "Let me just sketch the implementation..." (provisional - to be replaced with verbatim-observed phrase after RED run)
- "I'll prototype this real quick..." (provisional)
- "Here's a starter implementation..." (provisional)
- "This is small enough that we can skip the spec..." (provisional)

## Skills loaded

- `using-leyline` (via session-start hook)
- `brainstorming`

## RED baseline

Run the same scenario WITHOUT `brainstorming` loaded. Expected: the agent, under the "quick script" framing, writes Python code directly. Record the exact phrases it uses to rationalize around the (absent) hard gate.

## Outcome

- Pending execution. RED baseline must be captured in Claude Code / Codex / OpenCode (whichever harness has a subagent dispatch primitive); GREEN trace captured with `brainstorming` loaded; both pasted into this file's Outcome section before the skill change is considered verified.

## Related

- `skills/brainstorming/SKILL.md` - the skill under test
- `skills/writing-skills/testing-skills-with-subagents.md` - scenario format
