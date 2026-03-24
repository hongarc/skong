# Fix PR Comments Flow

## 1. Fetch Comments (parallel)

```bash
gh api repos/{owner}/{repo}/pulls/{number}/comments --paginate
gh api repos/{owner}/{repo}/pulls/{number}/reviews --paginate
gh api repos/{owner}/{repo}/issues/{number}/comments --paginate
gh api graphql -f query='{ repository(owner:"{owner}",name:"{repo}") {
  pullRequest(number:{number}) { reviewThreads(first:50) { nodes {
    id isResolved comments(first:1) { nodes { databaseId body } }
  } } } }'
```

Build `comment_id → thread_id` map. Skip resolved.

## 2. Categorize & Confirm

Read files + CLAUDE.md. Present summary:
- **Code fixes** — bugs, logic, data loss
- **Clarification** — code correct, misunderstood
- **Suggestions** — nice-to-have

Ask user which to address.

## 3. Fix

Read file + context, apply fix per conventions. Keep minimal.

## 4. Ship (Commit → Push → Reply → Resolve)

Stage specific files only (never `-A`).
```bash
git commit -m "fix(<scope>): address review comments"
git push origin "$BRANCH"
```

## 5. Reply & Resolve

**Fixed**: `"Fixed. <what changed>"`
**No change**: `"<explanation>"`

```bash
gh api repos/{owner}/{repo}/pulls/{number}/comments/{id}/replies \
  -f body='<reply>' --method POST

gh api graphql -f query='mutation {
  resolveReviewThread(input:{threadId:"{id}"}) { thread { isResolved } }
}'
```

## 6. Summary Table

| # | File | Comment | Action | Status |
|---|------|---------|--------|--------|
