---
name: review-inbox
description: "Manage PR review inbox: clean up closed/merged notifications, show open PRs needing review, offer to review. Triggers on: review inbox, my reviews, pending reviews, clean notifications."
argument-hint: "[clean|list|all]"
version: 1.0.0
---

# Review Inbox

Manage GitHub PR review notifications.

## Workflow

### Step 1: Fetch review-requested notifications

```bash
gh api "notifications?all=true&per_page=100" --jq '.[] | select(.reason == "review_requested")'
```

### Step 2: Check PR state for each notification

For each notification, extract the PR number from `subject.url` and check if the PR is open, closed, or merged:

```bash
# Extract owner/repo and PR number from subject.url
# subject.url format: https://api.github.com/repos/{owner}/{repo}/pulls/{number}
gh api "repos/{owner}/{repo}/pulls/{number}" --jq '{state, merged}'
```

### Step 3: Auto-mark closed/merged as read

If PR is closed or merged AND notification is unread, mark as read:

```bash
gh api "notifications/threads/{thread_id}" -X PATCH
```

Report how many were cleaned up.

### Step 4: Filter by review state vs latest commit

For each PR, compare my last review's commit SHA with the PR's current HEAD SHA:

```bash
# Get my last review commit SHA
my_last_review_sha=$(gh api repos/{owner}/{repo}/pulls/{number}/reviews \
  --jq '[.[] | select(.user.login == "<me>")] | sort_by(.submitted_at) | last | .commit_id')

# Get current HEAD
head_sha=$(gh api repos/{owner}/{repo}/pulls/{number} --jq '.head.sha')

# Get my last review state
my_last_state=$(gh api repos/{owner}/{repo}/pulls/{number}/reviews \
  --jq '[.[] | select(.user.login == "<me>")] | sort_by(.submitted_at) | last | .state')
```

**Rules:**
| My last review | SHA matches HEAD? | Action |
|----------------|-------------------|--------|
| `APPROVED` | Yes | Skip — already approved, mark notification read |
| `APPROVED` | No | Re-review — author pushed new changes |
| `CHANGES_REQUESTED` | Yes | Skip — waiting for author to fix, mark notification read |
| `CHANGES_REQUESTED` | **No** | **Re-review** — author pushed fixes, need to verify |
| `COMMENTED` or none | Any | Re-review — not yet submitted a formal review |

### Step 5: Show open PRs needing review

List remaining open PRs grouped by repo:

```
| # | Repo | PR | Title | Author | Updated |
```

### Step 6: Ask to review

Ask user: "Which PR to review? (number or skip)"

If user picks one, use the `/pr` skill to review it.

## Arguments

- `clean` — only clean up closed/merged (steps 1-3)
- `list` — only show open PRs needing review (steps 1-2, 4)
- `all` or no argument — full flow (clean + list + ask)

## Key Rules

- Never mark open PR notifications as read
- Show count of cleaned up notifications
- Group PRs by repo for readability
- Use `gh api` for all GitHub operations — no web browser needed
