# PR Review Rules & Checklist

## Verify Before Claiming

**CRITICAL**: Read actual source before reporting any finding:
- Error handling → read wrapper/handler implementation
- "Function returns X" → read the function definition
- "Breaks callers" → grep for callers, check usage
- Never assume utility function behavior

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

**Completeness**
- Missing input validation/bounds
- Missing route registration, auth middleware

**Consistency**
- Naming, patterns, imports match existing codebase
- Response format matches similar endpoints

**Hidden Issues**
- Feature PR quietly fixes prod bug → flag, suggest splitting

## Fix Suggestions

Every finding MUST include:
1. **What's wrong** — file:line
2. **Why** — impact
3. **How to fix** — code snippet

Confidence: **Verified** (read source) / **Likely** / **Uncertain**
