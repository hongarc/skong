# Full Auto Flow

## Step 1: Research
- Use Agent tool with parallel subagents:
  - Existing codebase patterns (grep/glob)
  - External solutions (web search if needed)
  - Dependencies and impacts
- Max 150 lines report
- **Output:** `✓ Step 1: Research — [findings]`

## Gate 1: Research Review
Ask: "Research done. Proceed to proposal or adjust?"

## Step 2: Proposal
- Activate `proposal` skill
- Use template: `.claude/skills/proposal/references/proposal-template.md`
- Write to `proposals/{date}-{slug}.md`
- **Output:** `✓ Step 2: Proposal — [path]`

## Gate 2: Approval
Ask: "Proposal ready. Approve to implement?"

## Step 3: Implement
- Activate `implement` skill
- Follow existing patterns, edit existing files
- Run tests after implementation
- If tests fail → fix and retry (max 3x)
- **Output:** `✓ Step 3: Implemented — [N files, tests status]`

## Step 4: Self-Review
- Run `git diff`
- Apply checklist from `.claude/skills/pr/references/review-rules.md`
- Fix critical issues, re-test
- **Output:** `✓ Step 4: Reviewed — [issues status]`

## Gate 3: User Review
Show `git diff --stat` + summary.
Ask: "Approve changes?"

## Step 5: Commit / PR / Deploy
Ask: "Commit locally? Create PR? Deploy? Skip?"
Execute based on answer.
