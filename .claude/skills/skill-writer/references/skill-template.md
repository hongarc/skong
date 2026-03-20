# Skill Template

```markdown
---
name: skill-name
description: "What this does and when. Triggers on: keyword1, keyword2."
argument-hint: "[args description]"
version: 1.0.0
disable-model-invocation: true
---

Parse `$ARGUMENTS` to determine mode (if multi-mode skill):
- `/skill-name foo` → Mode A
- `/skill-name bar` → Mode B

## Mode A
See `references/mode-a.md` for details.
[Brief inline summary of what happens]

## Mode B
See `references/mode-b.md` for details.
[Brief inline summary]

## Rules
- Key constraints
- Never do X
```

## Frontmatter Fields

| Field | Required | Notes |
|-------|----------|-------|
| `name` | Yes | kebab-case, matches folder |
| `description` | Yes | Third-person, include trigger keywords |
| `version` | Yes | semver |
| `disable-model-invocation` | Yes | Always `true` for OFF by default |
| `argument-hint` | No | Shows in autocomplete |

## Description — Good vs Bad
Good: "Git operations: clean branches, create releases/tags. Triggers on: git clean, git release, create tag."
Bad: "A skill for git stuff."

## Multi-Mode Pattern
One skill handles multiple related operations via argument parsing:
- `/pr 123 auto` vs `/pr 123 review` vs `/pr 123 fix`
- `/git clean` vs `/git release`

This saves ~100 tokens per operation that would otherwise be a separate skill.

## When to Inline vs Reference
- **Inline in SKILL.md**: Logic Claude MUST NOT skip (worktree setup, argument parsing)
- **Reference file**: Detailed checklists, API commands, templates
