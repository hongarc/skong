# Handover Template

```markdown
# Feature: [Name]

## Overview
- **What**: 1-2 sentences
- **Who uses it**: users / trainers / admins
- **Entry point**: `POST /api/v1/...` or UI action

## Key Files
| File | Purpose |
|------|---------|
| `routes/feature.js` | API endpoints |
| `services/feature.js` | Business logic |
| `models/Feature.js` | Schema/model |

## Flow
1. User does X
2. API calls `service.doThing()`
3. Checks condition A → if true, does B
4. Saves to DB
5. Triggers notification / side effect

## Hidden Logic & Conditions

### Condition: [name]
- **When**: [description]
- **Check**: `db.collection.findOne({ field: value })`
- **If true**: [what happens]
- **If false**: [what happens instead]
- **Code**: `services/feature.js:42`

### Auto-assignment Rule
- **Logic**: [description]
- **Code**: `services/feature.js:78`

## Debug Runbook

### Issue: [symptom]
1. Check: `db.collection.findOne({ _id: ObjectId("...") })`
2. Look for: `field` should be `value`
3. If wrong → [how to fix]
4. Related code: `file:line`

### Issue: [another symptom]
...

## DB Queries (copy-paste ready)

```js
// Check user state
db.users.findOne({ _id: ObjectId("USER_ID") }, { status: 1, plan: 1, team_id: 1 })

// Check feature condition
db.collection.findOne({ user_id: ObjectId("USER_ID"), active: true })

// Find related records
db.collection.find({ team_id: ObjectId("TEAM_ID") }).sort({ created_at: -1 }).limit(5)
```

## Common Gotchas
- [Thing that's not obvious from the code]
- [Edge case that breaks if...]
- [Dependency on another service/feature]

## Contact
- Built by: [name]
- Slack: [channel]
- Jira: [ticket]
```
