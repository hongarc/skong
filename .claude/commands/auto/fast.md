---
description: Fast auto workflow - skip proposal, go straight to implement + review
argument-hint: [task description]
---

**Think harder** and execute fast workflow for:
<task>$ARGUMENTS</task>

**Use for small tasks that don't need a proposal.**

## Fast Workflow

### Step 1: Quick Research
- Grep/glob codebase for related code
- Understand existing patterns (no web search)
- **Output:** `✓ Step 1: Scanned codebase — [findings]`

### Step 2: Implement
- Activate `implement` skill
- Create branch, implement, run tests
- Auto-fix if tests fail (max 3 retries)
- **Output:** `✓ Step 2: Implemented — [N files, tests status]`

### Step 3: Self-Review
- Activate `review-code` skill
- Apply checklist, fix critical issues
- **Output:** `✓ Step 3: Reviewed — [issues status]`

### Gate: User Approval
- Show `git diff --stat` and summary
- Use `AskUserQuestion`: "Done. Create PR? (yes/no)"
- If yes → `gh pr create`

### Step 4: Learn & Improve Skills
**MANDATORY after every workflow.**
1. Reflect: new patterns, gotchas, missing checklist items, better approaches
2. Summarize proposed skill updates:
```
### [skill-name] — [file]
- Suggested: [what to add/change]
- Why: [what we learned]
```
3. Use `AskUserQuestion`: "Found skill improvements. Approve updates? (yes/no/edit)"
4. Only update after user confirms

### Output
`✓ Complete: [PR URL or "local only"] — Skills: [updated/no updates]`
