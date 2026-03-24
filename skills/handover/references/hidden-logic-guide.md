# Finding Hidden Logic

## What to Look For

### Conditional Behavior
```js
// Pattern: if user has X status → different behavior
if (user.status === 'inactive') { /* skip assignment */ }
if (!user.plan || user.plan === 'free') { /* limit features */ }
if (subscription.expired) { /* downgrade permissions */ }
```

Search for: `if.*status`, `if.*active`, `if.*plan`, `if.*role`, `if.*permission`

### Auto-Assignment / Fallback
```js
// Pattern: if no X → auto-assign Y
if (!trainer) { trainer = team.default_trainer }
if (!assignee) { assignee = getNextAvailable() }
```

Search for: `default`, `fallback`, `auto`, `assign`, `next`

### Time-Based Conditions
```js
// Pattern: behavior changes based on dates
if (trial_end < Date.now()) { /* expired */ }
if (daysSince(last_active) > 30) { /* mark inactive */ }
```

Search for: `Date.now`, `expired`, `trial`, `days`, `timeout`

### Feature Flags / Role Gates
```js
if (team.features.includes('advanced')) { /* enabled */ }
if (user.role !== 'trainer') { throw new Error('Forbidden') }
```

Search for: `features`, `role`, `permission`, `allowed`, `can`

### Side Effects
```js
// Things that happen as a consequence
await sendNotification(user, 'assigned')
await webhook.trigger('user.updated', data)
await queue.add('sync-external', { userId })
```

Search for: `notify`, `webhook`, `trigger`, `emit`, `queue`, `publish`

## How to Document Each

For each hidden logic found:
1. **What**: describe the condition
2. **Where**: exact file:line
3. **When**: what triggers it
4. **Impact**: what changes if this condition is true/false
5. **DB check**: query to verify the condition state
