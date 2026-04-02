# Database Index Comments for PRs

## When to Apply

When a PR introduces **new Mongoose models or new collections**, check for indexes needed and add a PR comment with manual index creation commands.

## Rules

- **Do NOT use `schema.index()` or `unique: true`** in Mongoose schemas — these cause auto-index creation on app startup which is dangerous in production
- Instead, add an **"Indexes to Create"** section in the PR body (first comment) with `db.collection.createIndex()` commands
- Indexes should be created manually by the team before/after deploy

## What to Check

1. Fields used in query `$match` / `.find()` — need indexes
2. Fields used in `unique` lookups (e.g., profile + device_token) — need compound index
3. Soft-delete pattern (`is_deleted`) — include in compound index
4. TTL fields (e.g., `expires_at`) — need TTL index with `expireAfterSeconds: 0`
5. Fields used in `.sort()` — consider index

## PR Comment Format

```markdown
## Indexes to Create (manual)

Run these commands in MongoDB before/after deploy:

### `collection_name` collection
\`\`\`javascript
// Description of what this index supports
db.collection_name.createIndex({ field: 1 }, { name: "idx_field_name" })

// Unique index
db.collection_name.createIndex({ field: 1 }, { unique: true, name: "idx_field_unique" })

// TTL index — auto-delete expired documents
db.collection_name.createIndex({ expires_at: 1 }, { expireAfterSeconds: 0, name: "idx_expires_at_ttl" })

// Compound index for soft-delete queries
db.collection_name.createIndex({ field1: 1, field2: 1, is_deleted: 1 }, { name: "idx_field1_field2_is_deleted" })
\`\`\`
```

## Naming Convention

- Format: `idx_<field1>_<field2>_<purpose>`
- Examples: `idx_profile_unique`, `idx_profile_device_token`, `idx_expires_at_ttl`, `idx_profile_is_deleted`
