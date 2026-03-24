# Skill Validation Rules

Run this checklist before finalizing any skill.

## Frontmatter

- [ ] `name` — kebab-case, matches folder name, max 64 chars
- [ ] `description` — third-person ("Use when..."), includes trigger keywords
- [ ] `version` — semver format (1.0.0)
- [ ] `disable-model-invocation: true` — set for all skills except setup
- [ ] No extra/unknown frontmatter fields

## SKILL.md Content

- [ ] Under 100 lines total
- [ ] Has clear "when to use" / mode parsing
- [ ] Critical logic is inlined (not just referenced)
- [ ] References use `See references/file.md` pattern
- [ ] No generic filler — every line is actionable

## References

- [ ] Each file under 100 lines
- [ ] File names are descriptive (not `ref1.md`)
- [ ] Start with a heading
- [ ] Include code snippets where helpful
- [ ] All files referenced in SKILL.md actually exist

## Description Quality

Good description pattern:
```
"[What it does]. Triggers on: [keyword1], [keyword2], [keyword3]."
```

- [ ] Includes 3+ trigger keywords
- [ ] Specific enough to avoid false triggers
- [ ] Mentions what NOT to trigger on if ambiguous

Examples:
- Good: "Git operations: clean branches, create releases/tags. Triggers on: git clean, git release, create tag, release version."
- Bad: "A skill for git stuff."
- Good: "Review GitHub PRs with inline comments. For full auto flow use /pr auto instead."
- Bad: "Code review skill."

## Trigger Test

Mentally test with 3 phrases:
1. A phrase that SHOULD trigger → does description match?
2. A phrase that SHOULD NOT trigger → does description exclude it?
3. An ambiguous phrase → is the boundary clear?

## Common Mistakes

- SKILL.md over 100 lines (move content to references)
- Missing `disable-model-invocation: true`
- Description too vague (no trigger keywords)
- Critical logic in reference file only (Claude may not read it)
- Duplicate functionality with existing skill (should be grouped)
- Creating a command file that just says "Activate X skill" — redundant, skill is callable directly via `/skill-name`
- Only create command files when they add logic beyond what the skill provides (mode parsing, workflow orchestration)
