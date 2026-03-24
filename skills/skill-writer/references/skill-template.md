# Skill Template

```markdown
---
name: skill-name
description: "What this does. Triggers on: keyword1, keyword2. NOT for: anti-trigger1."
argument-hint: "[args]"
version: 1.0.0
disable-model-invocation: true
---

Parse `$ARGUMENTS` to determine mode (if multi-mode):
- `/skill-name foo` → Mode A
- `/skill-name bar` → Mode B

## Mode A
See `references/mode-a.md` for details.
[Brief inline summary — critical logic here, not in reference]

## Mode B
See `references/mode-b.md` for details.

## Rules
- Key constraints
```

## Frontmatter Fields

| Field | Required | Notes |
|-------|----------|-------|
| `name` | Yes | kebab-case, matches folder, max 64 chars |
| `description` | Yes | Third-person + trigger keywords + anti-triggers |
| `version` | Yes | semver |
| `disable-model-invocation` | Yes | Always `true` |
| `argument-hint` | No | Shows in autocomplete |

## Description Pattern

```
"[1-sentence what]. Triggers on: [words]. NOT for: [anti-words]."
```

Good:
- "PR ops: auto review+fix+push, manual review, fix comments. Triggers on: pr, review pr, fix pr. NOT for: general code review without a PR."
- "Git ops: clean branches, create releases. Triggers on: git clean, git release. NOT for: regular git commits."

## Multi-Mode Pattern

One skill, multiple operations via args:
- `/pr 123 auto` vs `/pr 123 review` vs `/pr 123 fix`
- `/git clean` vs `/git release`

Saves ~100 tokens per operation vs separate skills.

## Inline vs Reference

| Where | When |
|-------|------|
| Inline in SKILL.md | Logic Claude MUST NOT skip (worktree setup, arg parsing) |
| Reference file | Checklists, API commands, templates, detailed flows |

**Rule of thumb**: If skipping it breaks the skill → inline it.
