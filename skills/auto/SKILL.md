---
name: auto
description: "Full development workflow with approval gates: research, propose, implement, review, commit. Triggers on: auto, full workflow, start task, do everything. NOT for: single-step tasks like just reviewing a PR or just deploying."
argument-hint: "[task] [fast|research-only]"
version: 1.0.0
---

Parse `$ARGUMENTS` to determine mode:

- `/auto [task]` → **Full** — research → proposal → implement → review → commit
- `/auto:fast [task]` → **Fast** — implement → review → commit (skip proposal)
- `/auto:research-only [topic]` → **Research only** — research → proposal

## Gate 0: Understand
- Read `CLAUDE.md` for project context
- If task unclear → ask
- Identify which skills are needed

## Mode: Full
See `references/full-flow.md`
```
Research → [approve] → Proposal → [approve] → Implement → Test → Self-Review → [approve] → Commit → Learn
```

## Mode: Fast
See `references/fast-flow.md`
```
Scan codebase → Implement → Test → Self-Review → [approve] → Commit → Learn
```

## Mode: Research Only
See `references/research-only-flow.md`
```
Research → [approve] → Proposal → [approve] → Learn
```

## End: Commit (all modes except research-only)
After user approves changes:
- Ask: "Commit locally? Create PR? Deploy?" — user decides
- If commit → `git add <files> && git commit`
- If PR → `gh pr create`
- If deploy → activate `deploy` skill
- If skip → done

## End: Learn (MANDATORY — all modes)
See `references/learn.md`
Reflect → summarize skill improvements → ask user → apply if approved

## Rules
- Never skip approval gates
- Auto-fix on failure (max 3 retries)
- Concise reports — no fluff
- YAGNI, KISS, DRY
