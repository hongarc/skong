# Debug Runbook Template

For each known issue, create an entry:

```markdown
### Issue: [What the user/teammate reports]

**Symptoms**: [What they see — error message, wrong data, nothing happens]

**Quick Check**:
```js
// 1. Check the main record
db.collection.findOne(
  { _id: ObjectId("RECORD_ID") },
  { status: 1, field_that_matters: 1, updated_at: 1 }
)
// Expected: { status: "active", field_that_matters: true }
// If status != "active" → that's the problem
```

**Root Cause Checklist**:
- [ ] Is the record in correct state? (check `status` field)
- [ ] Is the user active? (`db.users.findOne({ _id: ... })`)
- [ ] Is the team subscription valid?
- [ ] Was this triggered at the right time? (check `created_at`)
- [ ] Is the related service running? (check logs)

**Fix**:
```js
// Option A: Fix the data
db.collection.updateOne(
  { _id: ObjectId("RECORD_ID") },
  { $set: { status: "active" } }
)

// Option B: Re-trigger the process
// Call API endpoint or run script
```

**Related Code**: `services/feature.js:42` — look at the condition check

**Escalate if**: [when to ask the original dev]
```

## Common Debug Patterns

### "It works for user A but not user B"
→ Check: roles, permissions, team settings, subscription plan

### "It worked yesterday but not today"
→ Check: expiration dates, cron jobs, recent deploys, config changes

### "Nothing happens when I click X"
→ Check: API response, browser console, is the feature flag on?

### "Wrong data showing"
→ Check: cache (Redis/CDN), query filters, soft-delete flags
