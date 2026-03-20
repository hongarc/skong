---
description: Review what was learned and propose skill improvements
argument-hint: [optional: specific skill to improve]
---

Reflect on the current conversation and propose improvements to skills.
<context>$ARGUMENTS</context>

## Workflow

### Step 1: Analyze What Happened
Review the conversation for:
- Problems encountered and how they were solved
- Patterns discovered in the codebase
- Edge cases or gotchas that weren't covered by checklists
- Steps that were missing or unnecessary in workflows
- New tools, libraries, or approaches learned
- Consistency rules observed in the codebase
- Mistakes made that a checklist could prevent

### Step 2: Map Learnings to Skills
Read current skill files in `.claude/skills/*/SKILL.md` and `references/`.
For each learning, identify which skill file should be updated.

### Step 3: Present Summary
Format as:
```
## Skill Improvements Found

### 1. [skill-name] — [references/file.md]
- **Current**: [what exists now, or "missing"]
- **Suggested**: [specific addition or change]
- **Why**: [what happened that taught us this]

### 2. [skill-name] — [references/file.md]
- ...
```

If no improvements found:
"No skill improvements identified from this session."

### Step 4: Confirm with User
Use `AskUserQuestion`: "Here are the proposed skill updates. Approve all / pick specific ones / skip?"

### Step 5: Apply
- **Approve all** → update all listed files
- **Pick specific** → ask which numbers to apply
- **Skip** → do nothing

After applying, show `git diff --stat` of skill files changed.

## Rules
- **Never update skill files without user confirmation**
- Keep changes minimal and focused
- Don't bloat checklists — only add items that would have prevented a real issue
- Remove outdated items if found
- Each reference file stays under 100 lines
