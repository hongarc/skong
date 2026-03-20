---
name: git
description: "Git operations: clean up branches, create releases/tags, sync protected branches. Triggers on: git clean, git release, create tag, release version, prune branches, reduce git size."
argument-hint: "[clean|release] [options]"
version: 1.0.0
disable-model-invocation: true
---

Parse `$ARGUMENTS` to determine mode:

- `/git clean` → **Clean** — sync branches, delete stale, reduce .git
- `/git release` → **Release** — create tag + GitHub release from version
- `/git release v1.2.3` → Release specific version
- `/git release patch|minor|major` → Bump and release

## Mode: Clean

See `references/clean.md` for full flow.

1. `git fetch --all --prune`
2. Check protected branches (main/develop) vs remote — pull if behind
3. Keep latest release branch, delete older local ones
4. Show plan (1 question) → execute
5. `git gc --aggressive --prune=now`

## Mode: Release

See `references/release.md` for full flow.

1. Detect version from `package.json` (or arg)
2. Ensure on main/master (latest code)
3. Create git tag
4. Push tag
5. Create GitHub release

## Rules
- **Always show plan before executing**
- **Never delete non-release local branches**
- **Never delete remote branches**
- Clean: pull only develop + latest release
- Release: always from main/master unless specified
