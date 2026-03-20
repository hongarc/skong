---
name: skill-writer
description: "Use when creating, editing, or optimizing Claude Code skills. Triggers on: create skill, new skill, edit skill, skill template, write skill."
version: 2.0.0
disable-model-invocation: true
---

# Skill Writer

## When to Use
- Creating a new Claude Code skill
- Editing or grouping existing skills
- Optimizing for token cost

## Skill Structure
```
.claude/skills/{skill-name}/
├── SKILL.md              # Required, < 100 lines
└── references/           # Detailed docs, each < 100 lines
```

## Creating a Skill

See `references/skill-template.md` for template.
See `references/token-optimization.md` for cost patterns.

### Step 1: Check if it should be grouped
- Related to existing skill? → Add as a reference file instead
- Example: git-clean + git-release → one `git` skill with `references/clean.md` + `references/release.md`
- Each skill costs ~100 tokens always in context. References cost 0 until loaded.

### Step 2: Write SKILL.md (< 100 lines)
- Frontmatter: name, description, version, `disable-model-invocation: true`
- Description: third-person, include trigger words
- Inline critical logic (Claude may skip references)
- Reference details: `See references/detail.md`

### Step 3: Create References (< 100 lines each)
- Practical instructions, not theory
- Include code snippets and exact commands
- Split large content across multiple files

### Step 4: Verify
- SKILL.md under 100 lines?
- All referenced files exist?
- `disable-model-invocation: true` set?

## Key Rules
- **Group related ops into 1 skill** (pr, git, etc.)
- **Use references for details** — SKILL.md is the router, references are the content
- **Inline critical logic** that Claude must not skip (e.g., worktree setup)
- **Progressive disclosure**: metadata (~100 tokens) → SKILL.md → references (on demand, free)
