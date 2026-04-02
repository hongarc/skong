---
name: aws
description: "AWS operations: SSM parameters, profile switching, secrets management. Triggers on: aws, ssm, parameter store, set env, set secret. NOT for: deploying apps (use /deploy) or general infra questions."
argument-hint: "[ssm|profile] [dev|staging|prod] [action]"
version: 1.0.0
---

Parse `$ARGUMENTS` to determine mode:

- `/aws ssm set TWO_FA_SECRET` → Set SSM parameter (asks profile first)
- `/aws ssm get TWO_FA_SECRET` → Read SSM parameter (asks profile first)
- `/aws ssm list` → List parameters (asks profile first)
- `/aws profile` → List/switch AWS profiles

## Step 1: ALWAYS Ask Profile First

**Before any SSM operation**, dynamically read `~/.aws/config` and build a selection table:

1. Read `~/.aws/config` with the Read tool
2. Parse all `[profile <name>]` sections — extract `role_arn`, `region` from each
3. Extract account ID from `role_arn` (the number between `iam::` and `:role`)
4. Extract role name from `role_arn` (after last `/`)
5. Skip `[default]` unless it's the only option
6. Present the table and ask user to select:

```
Which AWS profile?

| # | Profile | Account | Role | Region |
|---|---------|---------|------|--------|
| 1 | <name> | <account> | <role> | <region> |
| 2 | <name> | <account> | <role> | <region> |
```

**Do NOT hardcode profiles.** Always read from `~/.aws/config` at runtime.
**Do NOT proceed** until the user selects a profile.

Always use `--profile <name>` and `--region <region>` explicitly. Never assume defaults.

### Test profile access
```bash
aws sts get-caller-identity --profile <profile>
```

## SSM Parameter Store

### Naming Convention
```
/ENV/{SERVICE}/{ENV}/CD/{VAR_NAME}
```

| Segment | Values |
|---------|--------|
| `SERVICE` | `API`, `AUTH_API`, `CMS_API`, `AUTOMATION_SERVICE`, etc. |
| `ENV` | `DEV`, `STG`, `PRD` |
| `CD` | Always `CD` for app config |

Examples:
- `/ENV/API/DEV/CD/TWO_FA_SECRET`
- `/ENV/API/STG/CD/TWO_FA_SECRET`
- `/ENV/API/PRD/CD/TWO_FA_SECRET`

### Detect SSM Environment

Infer the SSM env segment from the profile name or existing parameters:
1. List a few existing params: `aws ssm describe-parameters --profile <profile> --max-results 5`
2. Extract the env segment from the path (e.g. `/ENV/API/DEV/CD/...` → `DEV`)
3. Use that env segment for all operations in this session

### Set Parameter
```bash
# Generate a UUID v4 secret
SECRET=$(python3 -c "import uuid; print(str(uuid.uuid4()))")

# Set as SecureString
aws ssm put-parameter \
  --profile <profile> \
  --region ap-southeast-1 \
  --name "/ENV/API/<ENV>/CD/<VAR_NAME>" \
  --value "$SECRET" \
  --type SecureString

# Set as plain String
aws ssm put-parameter \
  --profile <profile> \
  --region ap-southeast-1 \
  --name "/ENV/API/<ENV>/CD/<VAR_NAME>" \
  --value "<value>" \
  --type String

# Update existing (add --overwrite)
aws ssm put-parameter ... --overwrite
```

### Read Parameter
```bash
# Read with decryption
aws ssm get-parameter \
  --profile <profile> \
  --region ap-southeast-1 \
  --name "/ENV/API/<ENV>/CD/<VAR_NAME>" \
  --with-decryption \
  --query 'Parameter.{Name:Name,Value:Value,Type:Type,Version:Version}'
```

### List Parameters
```bash
# List by prefix
aws ssm describe-parameters \
  --profile <profile> \
  --region ap-southeast-1 \
  --parameter-filters "Key=Name,Option=BeginsWith,Values=/ENV/API/<ENV>/CD" \
  --max-results 50 \
  --query 'Parameters[].{Name:Name,Type:Type}'

# Search by keyword
aws ssm describe-parameters \
  --profile <profile> \
  --region ap-southeast-1 \
  --parameter-filters "Key=Name,Option=Contains,Values=<keyword>" \
  --max-results 20 \
  --query 'Parameters[].Name'
```

### Delete Parameter
```bash
aws ssm delete-parameter \
  --profile <profile> \
  --region ap-southeast-1 \
  --name "/ENV/API/<ENV>/CD/<VAR_NAME>"
```

## Rules

- **Secrets** (JWT keys, API keys, passwords) → always use `--type SecureString`
- **Config values** (URLs, feature flags, numbers) → use `--type String`
- **Generate secrets** with `python3 -c "import uuid; print(str(uuid.uuid4()))"` or `openssl rand -base64 32`
- **Always confirm** before writing to staging/production — ask the user
- **Always read back** after setting to verify
- **Never log** secret values in plain text to PR comments or shared channels
