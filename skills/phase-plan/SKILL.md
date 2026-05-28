---
name: phase-plan
description: "Break an approved decision or brief into a phased implementation plan with story-point cards, dependencies, and explicit failure modes. Triggers on: phase plan, break down work, task breakdown, story-point sizing, estimate per task, N-point cards, resize tasks, implementation plan. NOT for: making the decision itself (use architecture skill via graviton) or writing requirements (use proposal skill via meson)."
argument-hint: "[decision / brief to plan]"
version: 1.0.0
---

For **boson** — the planner agent. Turns a settled decision into a sequenced, sized plan that quark can pick up card-by-card.

## Inputs to gather first
- **Decision / brief** — what's being built (link the ADR or RFC)
- **Repo context** — paths, key modules, tests location
- **Team capacity & deadline** — how many cards in parallel, when does it ship
- **Definition of done** — tests? deploy? feature flag rollout?

## Output shape

```markdown
# Plan: <decision title>

## Scope
- In scope: …
- Out of scope: …

## Phases
### Phase 1 — <goal>
Why first: <unlocks / de-risks what>

- **Card 1.1** (2 pts) — <title>
  - Acceptance: <bullet>
  - Touches: `<path>`, `<path>`
  - Depends on: —
  - Failure mode: <what breaks if this is wrong>

- **Card 1.2** (3 pts) — <title>
  …

### Phase 2 — <goal>
…

## Dependency graph
1.1 → 1.2 → 2.1
       ↘  2.2

## Risks & rollback
- Risk: … → Mitigation: …
- Rollback plan: …

## Verification per phase
- Phase 1 done when: <test / metric>
- Phase 2 done when: …
```

## Sizing rules
- Cards are **1, 2, 3, or 5 points**. Anything 8+ must split.
- A point ≈ half a focused day for the implementer (calibrate to team).
- Re-estimate honestly when scope shifts; don't anchor to first guess.

## Discipline
- **One responsibility per card.** "Implement X and migrate Y" → two cards.
- Each card lists the files it touches and a failure mode — that's the contract for quark.
- Phases are ordered by **risk-burndown**, not by easy-first.
- If you can't size a card, mark it `?` and write what spike is needed.

## Anti-triggers
- "Should we use Postgres or DynamoDB" (decision not made) → graviton + `architecture`
- "What does the user want" → meson + `proposal`
- "Just write the code" → quark + `implement`

## Handoff
Cards go to quark one at a time, in dependency order:
```
Task(subagent_type=quark, prompt="Implement Card 1.1 from <plan link>: <title>. Files: <paths>. Acceptance: <bullet>.")
```

## References
- `references/proposal-template.md` (shared with `proposal` skill — for plan headers)
