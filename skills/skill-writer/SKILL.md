---
name: skill-writer
description: "Create, edit, or optimize Claude Code skills. Triggers on: create skill, new skill, edit skill, write skill. NOT for: using existing skills or running workflows."
version: 3.0.0
---

# Skill Writer

## Creating a Skill

### Step 1: Interview (don't assume)
Before writing anything, ask:
- What task does this help with? Give 3 concrete examples.
- What should trigger it? (exact phrases a user would type)
- What should NOT trigger it? (avoid false positives)
- Is this related to an existing skill? → group instead of new skill

### Step 2: Check if it should be grouped
See `references/token-optimization.md` for cost math.
- Related to existing skill? → Add reference file, not new skill
- Each skill = ~100 tokens always. References = 0 until loaded.

### Step 3: Write SKILL.md (< 100 lines)
See `references/skill-template.md` for template.
See `references/validation-rules.md` for all rules.

Key rules:
- Frontmatter: name, description, version, `disable-model-invocation: true`
- Description: third-person, include trigger AND anti-trigger words
- Inline critical logic Claude must not skip
- Reference details to `references/` files

### Step 4: Create References (< 100 lines each)
- Practical instructions with code snippets
- Split large content across files
- Name files descriptively: `review-rules.md` not `ref1.md`

### Step 5: Validate
See `references/validation-rules.md` — run full checklist.

### Step 6: Test Triggers
Describe the task naturally in 3 different ways. Verify the description would trigger the skill. If not, adjust trigger keywords.

## Key Principles
- **Interview first** — understand before writing
- **Group related ops** — 1 skill with N references beats N skills
- **Inline critical logic** — Claude may skip reference files
- **Test triggers** — verify description actually matches user intent
