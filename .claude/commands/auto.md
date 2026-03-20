---
description: Auto workflow - research, propose, implement, review, deploy with approval gates
argument-hint: [task description or Jira ticket]
---

**Think harder** and execute the full development workflow for:
<task>$ARGUMENTS</task>

**IMPORTANT:** Analyze skills at `.claude/skills/*` and activate what's needed.

## Workflow — Sequential with Approval Gates

### Gate 0: Understand
- Read `CLAUDE.md` for project context
- If task is unclear, use `AskUserQuestion` to clarify
- Identify which skills are needed

### Step 1: Research
- Use Agent tool with multiple researcher subagents in parallel to explore:
  - Existing codebase patterns (grep/glob for related code)
  - External solutions (web search if needed)
  - Dependencies and impacts
- Keep research report concise (max 150 lines)
- **Output:** `✓ Step 1: Research complete — [key findings summary]`

### Gate 1: Research Review
- Present research findings to user
- Use `AskUserQuestion`: "Research done. Should I proceed to proposal, or adjust research scope?"
- If user wants changes → redo research
- If approved → next step

### Step 2: Proposal
- Activate `proposal` skill
- Create proposal using template at `.claude/skills/proposal/references/proposal-template.md`
- Write to `proposals/{date}-{slug}.md`
- Include alternatives, trade-offs, recommendation
- **Output:** `✓ Step 2: Proposal created — [file path]`

### Gate 2: Lead Approval
- Present proposal summary to user
- Use `AskUserQuestion`: "Proposal ready. Review and approve to proceed with implementation, or request changes?"
- If user wants changes → update proposal and re-present
- If approved → next step

### Step 3: Implement
- Activate `implement` skill
- Create feature/fix branch: `git checkout -b feat/short-description`
- Follow plan from approved proposal
- Edit existing files — don't create unnecessary new files
- YAGNI, KISS, DRY
- Run `npm test` after implementation
- **Output:** `✓ Step 3: Implemented — [N files changed, tests status]`

### Auto-Check: If Tests Fail
- Read test output carefully
- Identify root cause
- Fix the issue
- Re-run tests
- Repeat until all tests pass (max 3 attempts)
- If still failing after 3 attempts → use `AskUserQuestion` to ask user for help
- **Output:** `✓ Step 3b: Tests fixed — [what was wrong and how it was fixed]`

### Step 4: Self-Review
- Activate `review-code` skill
- Run `git diff` to review all changes
- Apply review checklist from `.claude/skills/review-code/references/review-checklist.md`
- Check for: security issues, logic errors, performance, code style
- **Output:** `✓ Step 4: Self-review — [N issues found: X critical, Y important, Z suggestions]`

### Auto-Check: If Critical Issues Found
- Fix all critical and important issues
- Re-run tests to verify fixes don't break anything
- Re-run self-review
- Repeat until 0 critical issues
- **Output:** `✓ Step 4b: Issues resolved — [what was fixed]`

### Gate 3: User Review
- Present summary of all changes (files changed, what was done, test results)
- Show `git diff --stat`
- Use `AskUserQuestion`: "Implementation complete. Review changes and approve for PR, or request changes?"
- If user wants changes → fix and re-review
- If approved → next step

### Step 5: PR & Deploy
- Create PR with `gh pr create` — link Jira ticket, clear description
- Use `AskUserQuestion`: "PR created. Deploy to Vercel preview? (yes/no/skip)"
- If yes → `npx vercel` for preview deployment
- If skip → done
- **Output:** `✓ Step 5: PR created — [PR URL]`

### Final Report
```
## Summary
- Task: [description]
- Proposal: [file path]
- Branch: [branch name]
- PR: [PR URL]
- Files changed: [count]
- Tests: [pass/fail count]
- Deploy: [preview URL or "skipped"]

## What Changed
- Bullet list of changes

## Next Steps
- Items needing follow-up
```

### Step 6: Learn & Improve Skills
**This step is MANDATORY after every completed workflow.**

1. Reflect on the entire workflow. Identify learnings:
   - New patterns discovered in codebase
   - Gotchas or edge cases encountered
   - Better approaches found during implementation
   - Checklist items that were missing but should exist
   - Workflow steps that were unnecessary or missing
   - New consistency rules observed

2. Summarize what could improve which skill(s):
```
## Skill Improvements Found

### [skill-name] — [file to update]
- Current: [what it says now or what's missing]
- Suggested: [what to add/change]
- Why: [what happened that taught us this]

### [skill-name] — [file to update]
- ...
```

3. Present summary to user with `AskUserQuestion`:
   "Workflow complete. I found these potential skill improvements. Approve updates? (yes/no/edit)"

4. **Only update skill files after user confirms.**
   - If yes → apply all changes
   - If edit → ask which to apply
   - If no → skip, move on

- **Output:** `✓ Step 6: Skills updated — [list of files changed] or "no updates"`

---

## Critical Rules
- **Never skip gates** — always wait for user approval
- **Never skip Step 6 (Learn)** — always reflect and propose improvements
- **Auto-fix on failure** — tests fail? fix and retry (max 3x). Review issues? fix and re-review.
- **Step markers required** — every step outputs `✓ Step N: [status]`
- **Concise reports** — sacrifice grammar for clarity
- **No over-engineering** — YAGNI, KISS, DRY at all times
- **Always ask before updating skills** — summarize first, user confirms, then apply
