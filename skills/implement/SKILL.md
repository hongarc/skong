---
name: implement
description: "Implement a feature, bug fix, or task from a plan/ticket/proposal. Triggers on: implement, build, code this, start task, fix bug. NOT for: PR review, research, or proposals."
version: 1.0.0
---

# Implementation Skill

## When to Use
- Implementing a feature from an approved proposal
- Working on a Jira ticket
- Bug fixes
- Any coding task

## Workflow

### Step 0: Understand
- Read the proposal/ticket/requirements
- Read relevant existing code
- Identify affected files
- Check for existing patterns to follow

### Step 1: Plan
- Break into small, testable steps
- Identify dependencies between steps
- **Before branching:** `git fetch origin <base>` and branch off `origin/<base>` — NEVER off stale local. If the user names a base branch, assume local is stale.
- Create branch: `git checkout -b feat/short-description origin/<base>` (or `fix/...`)
- **Sanity check:** if user mentions existing code ("X is already there" or gives a GitHub URL), grep the freshly-fetched base for X before writing anything — don't re-add what already exists.

### Step 2: Implement
- Follow existing codebase patterns — don't invent new ones
- Edit existing files — don't create new files unless necessary
- Keep changes focused on the task
- No over-engineering: YAGNI, KISS, DRY

### Step 3: Verify
- Run existing tests: `npm test`
- Test manually if needed
- Check for lint errors
- Read your own diff: `git diff`

### Step 4: Self-Review
- Apply `references/implementation-checklist.md`
- Fix issues before asking for PR

### Step 5: PR
- `gh pr create` with clear title and description
- Link Jira ticket in PR body
- Request review from lead

## Key Rules
- DO NOT create new files when editing existing ones works
- DO NOT add features not in the requirements
- DO NOT refactor unrelated code
- Verify before claiming done — run commands, read output
