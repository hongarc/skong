---
description: Everfit release flow — sync master, tag vX.Y.Z, GitHub release, propagate to develop / releasing_staging / master-debugging
argument-hint: <version>
---

Activate the `release` skill: $ARGUMENTS

Examples:
- `/release 3.92.6` → full pipeline
- `/release` → asks for version

Pipeline:
1. Sync local master from origin
2. Tag `vX.Y.Z` (overwrite if exists, push)
3. Create GitHub release with changelog
4. Merge master → develop, releasing_staging, master-debugging
   - Clean: open PR directly
   - Conflict: branch `merge_master_to_<short>`, auto-resolve, push, open PR

Hard rules: never force-push or `--no-verify` on protected branches; smart conflict resolution (lockfile regen, version → master, comments lose to code, semantic conflicts escalate).
