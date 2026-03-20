---
name: proposal
description: "Use when creating technical proposals or technical docs for lead/team decision-making. Triggers on: proposal creation, technical doc, RFC, architecture decision, feature proposal, solution design."
version: 1.0.0
disable-model-invocation: true
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
- Research external solutions if needed
- See `references/research-checklist.md`

### Step 3: Draft Proposal
- Follow template in `references/proposal-template.md`
- Include trade-offs analysis
- Be specific about effort estimates (S/M/L, not hours)
- Include risks and mitigation

### Step 4: Output
- Write to `proposals/{date}-{slug}.md`
- Format for lead readability — concise, actionable
- Include a clear recommendation with reasoning

## Key Principles
- Lead needs to make a decision — give them enough info, not too much
- Always include alternatives considered
- Be honest about trade-offs and risks
- Sacrifice grammar for concision
