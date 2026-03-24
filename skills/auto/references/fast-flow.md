# Fast Auto Flow

Skip proposal — for small tasks.

## Step 1: Quick Research
- Grep/glob codebase for related code
- Understand existing patterns (no web search)
- **Output:** `✓ Step 1: Scanned — [findings]`

## Step 2: Implement
- Activate `implement` skill
- Create branch, implement, run tests
- If tests fail → fix and retry (max 3x)
- **Output:** `✓ Step 2: Implemented — [N files, tests status]`

## Step 3: Self-Review
- Activate `pr` skill (review mode)
- Apply checklist from `.claude/skills/pr/references/review-rules.md`
- Fix critical issues
- **Output:** `✓ Step 3: Reviewed — [issues status]`

## Gate: User Approval
Show `git diff --stat` + summary.
Ask: "Approve changes?"

## Step 4: Commit / PR / Deploy
Ask: "Commit locally? Create PR? Deploy? Skip?"
