---
description: Git operations — clean branches, create releases/tags
argument-hint: [clean|release] [options]
---

Activate the `git` skill: $ARGUMENTS

Modes:
- `/git clean` → sync branches, delete old local releases, reduce .git
- `/git release` → create tag + GitHub release from package.json version
- `/git release v1.2.3` → release specific version
- `/git release patch|minor|major` → bump and release
