# Implementation Checklist

## Before Coding
- [ ] Read the requirements/proposal/ticket fully
- [ ] Read existing code in affected area
- [ ] Identified patterns to follow
- [ ] Created feature/fix branch

## During Coding
- [ ] Following existing code style
- [ ] No new files unless truly needed
- [ ] Only changes relevant to the task
- [ ] Error handling at system boundaries only
- [ ] No hardcoded secrets or credentials

## Before PR
- [ ] `npm test` passes
- [ ] `git diff` reviewed — no accidental changes
- [ ] No console.log left behind
- [ ] No commented-out code
- [ ] No TODO without a Jira ticket reference
- [ ] Commit messages are clean and descriptive

## PR Creation
- [ ] Title: concise, describes the change
- [ ] Body: what changed, why, how to test
- [ ] Jira ticket linked
- [ ] Correct base branch
