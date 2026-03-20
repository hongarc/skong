# AWS Deployment Handoff Template

```markdown
# AWS Deployment Request

## Service/Project
Name and brief description

## What's Being Deployed
- List of changes/features
- PR link: [#XXX]
- Branch: `branch-name`

## Environment Variables Needed
| Key | Description | Secret? |
|-----|-------------|---------|
| VAR_NAME | What it's for | Yes/No |

## Infrastructure Changes
- [ ] New services needed
- [ ] Database changes
- [ ] New endpoints/routes
- [ ] Cron jobs / scheduled tasks

## Dependencies
- External services
- Other team deployments needed first

## Testing Done
- [ ] Local testing passed
- [ ] Preview/staging tested
- [ ] Describe what was tested

## Timeline
- Needed by: [date]
- Priority: Normal / Urgent

## Contact
- Slack channel: #channel
- Jira ticket: TICKET-XXX
```
