Review the following GitHub PR or code changes: $ARGUMENTS

Activate the `review-code` skill. Follow the workflow:

If argument is a PR number or URL:
1. Fetch PR with `gh pr view`
2. Get diff with `gh pr diff`
3. Read changed files for context
4. Apply review checklist
5. Present findings categorized as Critical/Important/Suggestion

If no argument:
1. Check `git diff` for local changes
2. Run self-review checklist
3. Report issues to fix before PR

Always be specific: file paths, line numbers, code snippets.
