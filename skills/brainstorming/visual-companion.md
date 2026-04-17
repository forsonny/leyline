# Visual companion

Guidance for step 2 of the `brainstorming` checklist: when to offer a visual companion alongside the written spec, and what counts as one.

## When to offer

Offer a visual companion if any of the following is true of the proposed work:

- It involves layout (where things sit relative to each other on a page or in a terminal).
- It involves a flow with branches (multi-step processes with decision points).
- It involves geometry or spatial reasoning (graphs, hierarchies, time lines, state machines).
- The human partner has used spatial language ("the left panel", "above the form", "right after they click").

If none of those apply (a config file change, a backend optimization, a refactor), do not offer.

## How to offer

Send the offer as its own message. Do not bundle it with a clarifying question. The human partner needs to make a separate decision about whether the visual companion is worth the small extra cost.

Suggested phrasing:

> Before I ask the next clarifying question: would a visual companion (an ASCII diagram, a small Mermaid flowchart, or a state-machine sketch) help us align on this? It's optional and only useful for the spatial parts of the proposal.

Wait for an answer. If the human partner says no, proceed to step 3 (clarifying questions). If yes, ask which format they prefer and produce the visual companion before continuing.

## What counts as a visual companion

| Kind | When useful | How to deliver |
|------|-------------|----------------|
| ASCII wireframe | Layout of a single screen, terminal, or document | Inline in the message, fenced as text |
| Mermaid flowchart | Multi-step user flow with branches | Inline in the message, fenced as `mermaid` |
| Mermaid state diagram | A surface with several distinct modes (idle, loading, error, success) | Inline as `mermaid` |
| DOT graph | Static structure - hierarchies, dependencies | Inline as a `dot` fenced block - renders as text in most viewers; paste into a graphviz-capable renderer for the image |
| Linked external file | A wireframe larger than ~40 lines, or one the human partner wants to keep | Save alongside the spec under `docs/leyline/specs/` and link with a relative path |

## What a visual companion is NOT

- It is not a UX artifact. UX artifacts come from `design-brainstorming` (stage 1b) and live under `docs/leyline/design/`. Visual companions support the product spec in stage 1a; they are a comprehension aid.
- It is not a mockup. Pixel-perfect visual design belongs to a different toolchain.
- It is not a substitute for the written spec. The text is still the source of truth.

## Mermaid examples

A simple flow:

```
flowchart TD
    Start([User opens dashboard])
    Auth{Logged in?}
    Login[Show login]
    Dashboard[Show dashboard]
    Start --> Auth
    Auth -->|no| Login
    Auth -->|yes| Dashboard
```

A simple state matrix as a state diagram:

```
stateDiagram-v2
    [*] --> Empty
    Empty --> Loading: fetch
    Loading --> Success: data arrived
    Loading --> Error: request failed
    Error --> Loading: retry
    Success --> [*]
```

## ASCII wireframe example

```
+------------------------------------------+
| Logo            Search...        Profile |
+------------------------------------------+
| Sidebar    | Main content area           |
|            |                             |
| - Item A   | <selected item details>     |
| - Item B   |                             |
| - Item C   | [Action 1] [Action 2]       |
+------------------------------------------+
```

## Related

- `SKILL.md` step 2 - where this is offered
- `../design-brainstorming/SKILL.md` - the UX spec stage where visual artifacts become a different concern
- `../../dev/reference/diagrams.md` - DOT vs Mermaid conventions across the plugin
