# Environment Variable Detection for PRs

## When to Apply

On **every PR review** (auto or manual), scan for new environment variables in the diff. If any are found, include an Environment Variables section in the PR body.

## How to Detect

1. Check diff for changes in config files (e.g., `common/config/*.js`)
2. Look for new `process.env.XXXX` references
3. Look for new Joi schema entries like `joi.string().required()` vs `joi.string().default()`

## Classification

| Joi Validation | Required? | Action |
|---------------|-----------|--------|
| `.required()` (no default) | **Yes — must set** | Mark as Required in table |
| `.default(value)` | No | Show default, mark as Optional |

## PR Body Format

Add this section to the PR Summary:

```markdown
## Environment Variables

> **Required** — must be set in staging/production before deploy:

| Variable | Required | Description |
|----------|----------|-------------|
| `VAR_NAME` | **Yes** | What it does. Must be unique per environment. |

> Optional — have sensible defaults:

| Variable | Default | Description |
|----------|---------|-------------|
| `VAR_NAME` | `value` | What it does |
```

## Rules

- Only show env vars that are **new in this PR** (not pre-existing ones)
- If NO new env vars → don't add the section
- If all new vars have defaults → still mention them but note "no env changes required"
- For secrets (JWT secrets, API keys) → always mark as Required even if they have a default, and note "Must be unique per environment"
- Group: required first, then optional
