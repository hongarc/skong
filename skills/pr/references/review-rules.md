# PR Review Rules & Checklist

## Verify Before Claiming

**CRITICAL**: Read actual source before reporting any finding:
- Error handling → read wrapper/handler implementation (funcWrap re-throws via logErrorNotify)
- "Function returns X" → read the function definition
- "Breaks callers" → grep for callers, check usage
- "`this` is wrong" → trace the full call chain (delegator → auto-loader → method call) to verify binding
- Never assume utility function behavior — read the source

## Comment Format

Use severity tiers for every comment:
- `[S1-x] BLOCKER` — will crash, lose data, or break integrations. Must fix before merge.
- `[S2-x] WARNING` — convention violation, missing validation, fragile pattern. Should fix.
- `[S3-x] NIT` — style, minor inconsistency. Nice to fix.

### Standard format (for certain findings):
```
**[S1-x] BLOCKER — short title**

What's wrong (1-2 sentences)

Existing pattern (file:line):
\`\`\`javascript
// path/to/existing-code.js:42
existing code showing the right way
\`\`\`

**Suggested fix:**
\`\`\`javascript
corrected code
\`\`\`
```

### Question format (for uncertain findings — use `(question)` suffix):
```
**[S2-x] WARNING — short title (question)**

Current code does X. Existing pattern does Y (file:line):
\`\`\`javascript
existing code
\`\`\`

Why the difference? [specific concern about impact]
```

### Rules:
- Show **existing code as evidence** with file:line — not doc section citations
- Use **(question)** suffix when uncertain — don't state as fact without verifying
- Track **carryovers** from prior PRs — link to unresolved comments
- Number comments sequentially within each severity: S1-1, S1-2, S2-1, S2-2, etc.

## Checklist

**Critical**
- Logic bugs, off-by-one, null/undefined access
- Security: injection, auth bypass, missing permission checks
- Data loss (delete before create, missing transactions)
- Race conditions, variable scoping (const/let in try vs catch)

**Error Handling**
- Trace full chain: function → wrapper → error handler
- Read funcWrap/mainWrap/logErrorNotify implementations
- Missing handling at system boundaries

**Auth & Middleware**
- Mutation routes have auth middleware
- Services validate ownership before modifying data

**Performance**
- N+1 queries, sequential→parallel, unbounded memory
- Missing indexes, missing `.lean()` on read-only queries
- **MongoDB `$push` without `$slice`** → unbounded array growth. Every `$push` on an array MUST have `$slice` to cap size. Documents grow over time and degrade query performance
- **Redundant DB calls** — if data is already available (e.g. from JWT token, from a previous call), don't fetch again. Count sequential DB calls and ask "is each one necessary?"
- **MongoDB `$setOnInsert` redundancy** — filter fields in `findOneAndUpdate` are auto-included on upsert insert. Don't repeat them in `$setOnInsert`

**Data Flow — Read/Write Consistency**
- For every field **read** in a service (e.g. `if (record.some_field)`), verify it is **written** somewhere in the repositories. If a field is checked but never set, it's dead code or a bug
- For every field **written** in a repository `$set`, verify something reads it. Orphan writes waste storage
- Trace the full path: service reads field → which repository writes it? Check both directions

**Tests — Contract Consistency**
- When a service return value changes (e.g. from `{ token, user }` to `{ success: true }`), verify ALL test assertions match the new contract
- When a service signature changes (e.g. removes `token` param), verify ALL test calls match — no stale `mockToken` or unused stubs
- When stubs are set up (e.g. `require.cache` stubs), verify each stubbed method is actually called by the service. Remove unused stubs.

**Dead Code After Refactor**
- When a function/repo/service is no longer called after a refactor, flag it. Check: grep for callers. If zero callers → remove or add JSDoc noting "kept for future use"
- When imports are no longer used after code changes, remove them

**Completeness**
- Missing input validation/bounds (e.g. max date range on sync endpoints)
- Missing route registration, auth middleware

**JSDoc Consistency**
- All `@param` should be consistent: either all required or marked `[optional]` with brackets
- `@param` list must match actual destructured params — no stale/missing entries
- `@returns` should be present and match actual return value
- When a function signature changes, update ALL JSDoc in the file AND in delegators

**Consistency**
- Naming, patterns, imports match existing codebase
- Response format matches similar endpoints
- When code calls a shared service (e.g. `updateSource`, `getSources`), grep for 2-3 existing callers and verify the new call matches: argument style, field names, query shape, which fields are set (e.g. top-level `status` vs nested `additional_info.*`)
- Don't store MongoDB dot-notation field paths in config — use hardcoded strings at the call site like existing code does

**Database Indexes**
- New Mongoose models → do NOT use `schema.index()` or `unique: true` in schema
- Add PR comment with manual `db.collection.createIndex()` commands (see `db-indexes.md`)
- Check: query fields, unique lookups, soft-delete compound, TTL, sort fields

**Environment Variables**
- Scan diff for new `process.env.*` or new Joi schema entries in config files
- If new env vars found → add Environment Variables section to PR body (see `env-comment.md`)
- Secrets (JWT keys, API keys) → always mark Required even if they have defaults
- No new env vars → don't add the section

**Hidden Issues**
- Feature PR quietly fixes prod bug → flag, suggest splitting

## Fix Suggestions

Every finding MUST include:
1. **What's wrong** — the offending code
2. **Existing pattern** — file:line showing how it's done elsewhere
3. **Suggested fix** — code snippet
