---
name: proposal
description: "Create technical proposals for lead/team decision-making. Triggers on: proposal, technical doc, RFC, architecture decision. NOT for: implementing code or researching without a proposal output."
version: 1.1.0
---

# Technical Proposal Creation

## When to Use
- User needs a technical proposal for lead approval
- Feature design that needs team buy-in
- Architecture decisions requiring evaluation
- Comparing approaches for a problem

## Workflow

### Step 1: Understand the Problem
- Clarify the goal, constraints, timeline
- Ask user for Jira ticket or context if not provided
- Read relevant codebase files to understand current state

### Step 2: Research
- Investigate existing patterns in the codebase
- Check for similar implementations
- Find ALL injection/integration points (grep for the function/pattern being changed)
- Research external solutions if needed
- See `references/research-checklist.md`

### Step 3: Draft Proposal
- Follow template in `references/proposal-template.md`
- Include trade-offs analysis
- Include risks with detail (likelihood, impact, mitigation)

### Step 4: Effort Estimate
- Use **points** (1 day = 1.5 points)
- Group by card/ticket — each card = dev points + test
- Test is **1 point for all cards** (not per card)
- Models, indexes, hygen scaffold are included per card — not separate line items
- Don't estimate hours/days — only points

### Step 5: API Contract
- If the proposal adds/changes API endpoints, include a full **API Contract** section
- Show request + response JSON for every endpoint (success + error cases)
- FE/Mobile can use this to implement in parallel
- Include validation rules (which fields are required, XOR logic, etc.)
- Include a summary table: endpoint, when to call, auth required

### Step 6: Flow Diagrams
- Create a **separate file** for flow diagrams: `proposals/{date}-{slug}-flows.md`
- Link from main proposal: `*See [flows.md](./file.md) for detailed flow diagrams.*`
- Column order for multi-party flows: **OS | Client (center) | Server**
- Client app is always in the center column
- 2-party flows (Client + Server): Client left, Server right
- Align arrows to column borders — request label above arrow, response label above return arrow
- Don't put long text on arrow lines — put labels on separate line above
- Include DB operations summary below each flow
- Include a Decision Tree for branching logic
- Include a Data Lifecycle overview showing all DB operations per endpoint

### Step 7: Open Questions
- Separate "Must Answer" vs "Nice to Clarify"
- Include default assumption for each question
- Don't ask questions you can answer from the codebase
- Don't ask questions the backend doesn't care about (e.g., "web + mobile timeline")
- If a question affects API design, say so
- Flag questions with multiple options — list the options

### Step 8: Output
- Write to `proposals/{date}-{slug}.md`
- Format for lead readability — concise, actionable
- Include a clear recommendation with reasoning

## Key Principles
- **Consistency first** — when changing a number, text, or term in one place, grep the entire document for all other occurrences and update them too. Never leave conflicting values (e.g., "80 GB" in one table and "120 GB" in another).
- **If not clear, ask** — don't guess or auto-fill. If the user gives incomplete info, ask before writing. Wrong assumptions waste more time than a question.
- Lead needs to make a decision — give them enough info, not too much
- Always include alternatives considered
- Be honest about trade-offs and risks
- Sacrifice grammar for concision
- Find ALL places that need change (grep the codebase), not just the obvious one
- Show data model field-by-field with WHY each field exists, WHEN it's written/read/deleted
- If proposing a new library, create a separate library request doc (see example)
