---
description: Auto research + proposal only (no implementation)
argument-hint: [topic or task]
---

**Think harder** and research + create proposal for:
<task>$ARGUMENTS</task>

**Use when you only need a proposal for lead review, not implementation yet.**

## Workflow

### Step 1: Research
- Activate `research` skill
- Multiple parallel searches (codebase + web)
- **Output:** `✓ Step 1: Research — [key findings]`

### Gate 1: Review Research
- Use `AskUserQuestion`: "Research done. Proceed to proposal?"

### Step 2: Proposal
- Activate `proposal` skill
- Write to `proposals/{date}-{slug}.md`
- **Output:** `✓ Step 2: Proposal — [file path]`

### Gate 2: Review Proposal
- Present proposal
- Use `AskUserQuestion`: "Proposal ready for lead. Any changes needed?"
- Fix if needed, then done

### Step 3: Learn & Improve Skills
**MANDATORY after every workflow.**
1. Reflect: better research sources, missing template sections, improved evaluation criteria
2. Summarize proposed skill updates
3. Use `AskUserQuestion`: "Found skill improvements. Approve updates? (yes/no/edit)"
4. Only update after user confirms

### Output
`✓ Complete: Proposal at [path] — ready for lead review — Skills: [updated/no updates]`
