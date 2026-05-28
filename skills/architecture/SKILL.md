---
name: architecture
description: "Produce architecture decisions, ADRs, system designs, and solution-design docs. Triggers on: ADR, architecture decision, solution design, design doc, system design, new service design, db swap, tech stack swap, module boundary. NOT for: BA / requirements / user stories (use proposal skill via meson) or phased implementation plans (use phase-plan skill via boson)."
argument-hint: "[decision / question]"
version: 1.0.0
---

For **graviton** — the architect agent. Turns an open technical question into a written decision document with options, trade-offs, and a chosen path.

## Inputs to gather first
- **Decision being made** — phrased as a question, not "we should do X"
- **Constraints** — latency budget, scale, team size, deadlines, infra, cost ceiling
- **Existing ADRs / docs** — link them so you don't re-derive
- **Reversibility tolerance** — one-way doors deserve more rigor than two-way

If a constraint is missing, ask once and proceed with stated assumptions.

## Output shape (ADR style)

```markdown
# ADR-NNN: <decision question>

## Status
Proposed | Accepted | Superseded

## Context
2–4 sentences. Why the decision is needed now. Link tickets / prior ADRs.

## Options
### Option A — <name>
- How it works (1 paragraph)
- Pros
- Cons
- Effort: S/M/L

### Option B — <name>
…

### Option C — <name>   ← include only if it adds signal
…

## Decision
Option <X>. One paragraph justifying against the stated constraints.

## Consequences
- What gets easier
- What gets harder
- Migration / rollback cost
- Reversibility: one-way | two-way

## Open questions
- …
```

## Discipline
- **2–3 options minimum**, scored against the listed constraints. No single-option ADRs.
- Name the trade-off explicitly — every "pro" should have a matching "con".
- Effort sizes are gut estimates, not promises. Hand off to boson via `phase-plan` for real planning.
- Flag reversibility honestly. If it's a one-way door, say so in big letters.
- Don't invent constraints the user didn't give you. Ask.

## Anti-triggers
- "How should we plan the rollout of <already-decided thing>" → boson + `phase-plan`
- "Write up the requirements for <feature>" → meson + `proposal`
- "Research libraries for X" (no decision yet) → photon + `research`

## Handoff
After the ADR is accepted, hand off to boson with:
```
Task(subagent_type=boson, prompt="Plan implementation of ADR-NNN: <decision>. Repo context: <paths>.")
```

## References
- `references/proposal-template.md` (shared with `proposal` skill — same skeleton)
