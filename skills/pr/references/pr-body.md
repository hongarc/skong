# Writing PR / Comment Bodies

## DO NOT escape backticks in heredoc-fed bodies

When passing markdown to `gh pr create`, `gh pr edit`, `gh pr comment`, etc., the backtick is the most important character to get right — it's how inline `code`, code blocks, and many table cells are rendered. Escaping it turns code formatting into literal `\`` in the published PR.

### Always prefer `--body-file`

Writing the body to a file and using `--body-file` sidesteps every shell-quoting gotcha:

```bash
cat > /tmp/pr-body.md <<'PRBODY'
## Summary

Fixed `POST /authentication/client/login` so it returns `{ requires_2fa: true }`
instead of `firebase_token` when `x-device-token` is set.
PRBODY

gh pr create --base develop --head <branch> --title "..." --body-file /tmp/pr-body.md
gh pr edit <number>   --body-file /tmp/pr-body.md
```

Backticks inside `<<'PRBODY'` (quoted terminator) are **not** interpreted by the shell — write them as literal `` ` ``, not `\``.

### If you must use inline `--body "$(cat <<'EOF' ... EOF)"`

A **single-quoted** HEREDOC terminator (`<<'EOF'`, not `<<EOF`) disables shell expansion, which means backticks and `$` are already safe — do not escape them:

```bash
# CORRECT — single-quoted terminator, no escaping
gh pr create --body "$(cat <<'EOF'
Added `foo()` to fix `bar`.
EOF
)"

# WRONG — escaped backticks render as literal \` in the PR
gh pr create --body "$(cat <<'EOF'
Added \`foo()\` to fix \`bar\`.
EOF
)"
```

If the terminator is **unquoted** (`<<EOF`), shell expansion IS active — then backticks run as command substitution. In that case switch to `<<'EOF'` instead of trying to escape.

## Always verify after creation

After creating or editing a PR body, re-read it to confirm formatting:

```bash
gh pr view <number> --json body -q '.body' | head -30
```

If you see `\`` in the output, the body is broken — fix it with `gh pr edit <number> --body-file <file>` before moving on.

## Same rule applies to

- `gh pr comment <number> --body ...`
- `gh pr review --body ...`
- `gh issue comment ...`
- Any `gh` command accepting a markdown body
