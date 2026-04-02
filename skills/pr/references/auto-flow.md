# Auto PR Flow

## 1. Fetch PR Info (parallel)

```bash
gh pr view <number> --json headRefName,baseRefName,title,body,author,state,labels
gh pr diff <number>
gh api repos/{owner}/{repo}/pulls/{number}/comments --paginate
gh api repos/{owner}/{repo}/pulls/{number}/reviews --paginate
gh api repos/{owner}/{repo}/issues/{number}/comments --paginate
gh api graphql -f query='{ repository(owner:"{owner}",name:"{repo}") {
  pullRequest(number:{number}) { reviewThreads(first:50) { nodes {
    id isResolved comments(first:1) { nodes { databaseId body } }
  } } } } }'
```

Build `comment_database_id → thread_graphql_id` map. Skip resolved threads.

## 2. Review

Read all changed files (full file) + siblings + imports + project CLAUDE.md.
Apply checklist from `review-rules.md`.
Group: **Must fix** / **Should fix** / **Clarification** / **Ask user**

### Environment Variable Check
Scan diff for new env vars (see `env-comment.md`). If found:
- Add **Environment Variables** section to PR body with Required/Optional table
- Secrets → always Required even with defaults

## 3. Fix

For each must-fix and should-fix:
- Read file, apply fix per project conventions
- Keep changes minimal
- Auto-detect and run lint
- Run related tests — if fail, fix and retry (max 3x)
- Self-verify: `git diff` — no accidental deletions, no debug code

## 4. Ship (STRICT order: Commit → Push → Reply → Resolve)

```bash
cd "$WORK_DIR" && git add <specific files>
cd "$WORK_DIR" && git commit -m "fix(<scope>): address review comments"
cd "$WORK_DIR" && git push origin "$BRANCH"
```

Reply to each comment, then resolve threads. See `ship-and-reply.md`.

## 5. Testing Guide

Generate for reviewer/QA:
1. What changed (1-2 sentences)
2. How to test manually
3. Test data / curl commands
4. Edge cases to verify
