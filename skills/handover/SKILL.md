---
name: handover
description: "Create feature handover docs for teammates: how it works, hidden logic, debug guide, DB queries to check conditions. Triggers on: handover, hand over, document feature, feature guide, explain feature for team, write runbook. NOT for: proposals or technical docs for lead approval."
argument-hint: "[feature name or description]"
version: 1.0.0
---

## Workflow

### Step 1: Understand the Feature
- Ask user: "What feature are you handing over?"
- Read all related code files (routes, services, models, utils)
- Trace the full flow: entry point → business logic → DB → response
- Identify all models/collections involved

### Step 2: Map Hidden Logic
See `references/hidden-logic-guide.md`

Find and document:
- Conditional behavior (if user inactive → do X)
- Auto-assignment rules, fallback logic
- Time-based conditions (trial expired, subscription status)
- Feature flags, role-based access
- Side effects (triggers, webhooks, notifications)

### Step 3: Create Debug Runbook
See `references/debug-runbook-template.md`

For each common issue scenario:
- Symptoms (what the user/teammate sees)
- DB queries to check conditions
- What to look for in the result
- How to fix it

### Step 4: Write Handover Doc
Write to `docs/handover-{feature-name}.md` using template from `references/handover-template.md`

Sections:
1. Overview — what it does, who uses it
2. Architecture — flow diagram, key files
3. Hidden Logic — conditions, edge cases
4. Debug Runbook — symptoms → DB check → fix
5. DB Queries — ready-to-use queries for checking state
6. Common Issues — known gotchas

### Step 5: Review with User
Present the doc. Ask: "Anything missing? Any edge cases I didn't catch?"

## Rules
- Read ALL related code before writing — don't guess
- Include exact file paths and line references
- DB queries must be copy-paste ready
- Write for someone who has never seen this code
