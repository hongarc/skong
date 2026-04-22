---
name: pr
description: "All PR operations: auto review+fix+push+resolve, manual review with inline comments, fix review comments. Triggers on: pr, auto pr, review pr, fix pr, pr comments. NOT for: general code questions without a PR number."
argument-hint: "<PR number> [auto|review|fix|comment]"
version: 1.0.0
---

Parse `$ARGUMENTS` to determine mode:

- `/pr 123 auto` or `/pr 123` → **Auto flow** (default)
- `/pr 123 review` → **Review only** (present findings, ask which to post)
- `/pr 123 review comment` → **Review + post** comments
- `/pr 123 fix` → **Fix existing** review comments

## Worktree Setup (MANDATORY — DO NOT SKIP)

```bash
REPO_ROOT=$(git rev-parse --show-toplevel)
REPO_NAME=$(basename "$REPO_ROOT")
BRANCH=$(gh pr view <number> --json headRefName --jq '.headRefName')
```

**If `REPO_NAME` ends with `-worktree`** → already in worktree:
- `git fetch origin && git checkout "$BRANCH"`
- Set `WORK_DIR="$REPO_ROOT"`

**If NOT** → in main repo:
1. Check if worktree already exists: `git worktree list` — look for `$REPO_NAME-worktree`
2. If exists → `cd` into it, checkout branch
3. If not → Ask: "Create worktree at `../$REPO_NAME-worktree`?"
   - `git worktree add "${REPO_ROOT}/../${REPO_NAME}-worktree" "origin/$BRANCH"`
4. Ask to copy dotfiles (.env, .npmrc, .nvmrc, etc.)
5. Set `WORK_DIR` to worktree path

**ALL operations use `$WORK_DIR`. NEVER remove worktree.**

## Mode: Auto (default)

See `references/auto-flow.md` — full pipeline:
```
Fetch → Review → Fix → Lint → Test → Commit → Push → Reply → Resolve → Summary
```

## Mode: Review

See `references/review-rules.md` for checklist.
See `references/post-comments.md` for posting API.

1. Fetch PR diff + metadata
2. Read all changed files (full files, not just diff) + project CLAUDE.md
3. Analyze with full checklist (verify before claiming)
4. Present findings with suggested fixes
5. If `comment` arg: ask which to post as inline PR comments
6. **Never post automatically** — always ask user

## Mode: Fix

See `references/fix-flow.md` — fix existing review comments:
```
Fetch comments → Read files → Fix → Commit → Push → Reply → Resolve
```

## Test Evidence

After running tests for a PR, save HTML results locally using Catppuccin Frappé theme.
See `references/test-evidence.md` for template, palette, and `save-test-html.sh` usage.

- Name: `test-results-UP-<ticket>.html`
- **Never commit** — local only, user captures screenshots
- Regenerate after any test changes

## PR Body / Comment Formatting

When writing PR bodies, review replies, or any `gh` command that takes a markdown `--body`, see `references/pr-body.md`.

**TL;DR:** prefer `--body-file <path>` over inline heredocs, and **never** escape backticks inside a single-quoted heredoc (`<<'EOF'`) — the shell already leaves them alone, so `\`` renders as a literal backslash-backtick in the published PR. After creating/editing, verify with `gh pr view <number> --json body -q '.body' | head`.

## Decision Rules

| Situation | Action |
|-----------|--------|
| Clear bug | Fix automatically (auto mode) |
| Convention violation | Fix automatically (auto mode) |
| Code correct, reviewer misunderstood | Reply with explanation |
| Genuinely ambiguous | ASK the user |
| Test fails after 3 attempts | ASK the user |
