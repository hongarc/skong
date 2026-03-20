---
name: setup
description: "Set up Claude skills for current repo. Creates project-level .claude/ with selected skills enabled. Use /setup in any repo to get started."
version: 1.0.0
---

# Setup — Set Up Skills for This Repo

## Workflow — Only 1 Question

### Step 1: Auto-Detect (no questions)
- Detect stack from files: `package.json`, `go.mod`, `requirements.txt`, `Cargo.toml`, etc.
- Detect: language, framework, test command, build command, package manager
- Check for existing `.claude/` and `CLAUDE.md`

### Step 2: Present & Ask (1 question only)
Show detection results + skill menu in ONE message:

```
Detected: [language] / [framework] / [package-manager]
Test: [auto-detected command]
Build: [auto-detected command]

Available skills:
1. pr            — PR ops: auto review+fix+push, manual review, fix comments
2. git           — git ops: clean branches, create releases/tags
3. proposal      — technical proposals for lead
4. implement     — implement tasks
5. research      — research with reports
6. deploy        — local/vercel/aws
7. skill-writer  — create/edit skills

Which skills? (1,2,3 or all) [default: all]
```

Use `AskUserQuestion` with the above. **This is the ONLY question.**

### Step 3: Copy & Configure (no questions)
Based on answer + auto-detection, do everything silently:

**Copy skills** (selected only):
- Copy SKILL.md + references/ from `~/.claude/skills/<name>/`
- Remove `disable-model-invocation: true` from copies
- Auto-fill detected values (test command, build command, deploy target)

**Copy commands** (matching skills):
- Always: `learn.md`
- Per skill: matching command file (e.g., pr → no separate command, it's a skill)
- If 2+ skills: `auto.md`, `auto/fast.md`, `auto/research-only.md`

**Create `.claude/settings.json`** with empty object `{}`:
- Do NOT copy user settings (contains user-specific permissions)
- Target repo can add project-specific settings later

**Create CLAUDE.md** (if not exists):
- Auto-generate from detected stack + enabled skills
- If exists: append skills section

### Step 4: Done
Print summary, no more questions:
```
Setup complete:
- Skills: [list]
- Commands: [list]
- CLAUDE.md: [created/updated]
- Test: [command]  Build: [command]
```

## Rules
- **MAX 1 question** — detect everything else automatically
- COPY, never symlink into project repos
- Remove `disable-model-invocation: true` from project copies
- Auto-detect stack, test/build commands, deploy targets from project files
- Use sensible defaults — don't ask if detectable
