# Token Optimization for Skills

## How Skills Use Tokens

| Level | When Loaded | Cost |
|-------|-------------|------|
| `name` + `description` | Always (every conversation) | ~100 tokens per skill |
| SKILL.md body | When skill activates | ~500-2000 tokens |
| references/ | When Claude reads them | On demand, 0 until used |

## Optimization Strategies

### 1. Group related skills (biggest win)
Before: 4 skills (auto-pr, review-pr, fix-pr, review-code) = 400 tokens always
After: 1 skill (pr) with 4 references = 100 tokens always
**Saved: 300 tokens**

### 2. Use `disable-model-invocation: true`
Prevents auto-loading. Only loads when user calls `/skill-name`.
Without: all skills load metadata + may auto-activate
With: only metadata loaded (~100 tokens), body never loads unless called

### 3. Move details to references/
SKILL.md = router (< 100 lines, ~500 tokens when active)
references/ = content (0 tokens until needed)

Bad: 200-line SKILL.md with all logic inlined
Good: 50-line SKILL.md + 3 reference files

### 4. Keep descriptions short
Description is always in context. Every word costs.
Bad: "This comprehensive skill handles all aspects of..."
Good: "PR ops: auto review+fix+push. Triggers on: pr, review pr."

## When NOT to optimize
- Critical logic that Claude must not skip → inline in SKILL.md
- Example: worktree setup logic must be inlined because Claude may not read referenced file

## Cost Calculator
```
Total always-on cost = (number of skills) × ~100 tokens
Target: under 1000 tokens (10 skills max)
Current: 8 skills × 100 = 800 tokens
```
