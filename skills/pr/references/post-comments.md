# Post Review Comments on GitHub

## Get Head SHA

```bash
gh api repos/{owner}/{repo}/pulls/{number} --jq '.head.sha'
```

## Post Review with Inline Comments

```bash
gh api repos/{owner}/{repo}/pulls/{number}/reviews \
  -X POST \
  --field event="COMMENT" \
  --field body="<summary>" \
  --field commit_id="<sha>" \
  --field 'comments[][path]=<file>' \
  --field 'comments[][position]=<diff line position>' \
  --field 'comments[][body]=<comment>'
```

## Position Calculation

`position` = line number within the diff hunk (1-based from `@@`).
Not the file line number.

1. Get diff: `gh pr diff <number>`
2. Find `@@` hunk containing target line
3. Count lines from `@@` to target

## Reply to Existing Comment

```bash
gh api repos/{owner}/{repo}/pulls/{number}/comments/{id}/replies \
  -f body='<reply>' --method POST
```

## Resolve Thread

```bash
gh api graphql -f query='mutation {
  resolveReviewThread(input:{threadId:"{id}"}) { thread { isResolved } }
}'
```

## Get owner/repo

```bash
gh repo view --json owner,name --jq '"\(.owner.login)/\(.name)"'
```
