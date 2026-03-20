# Skong — Claude Code Skills Toolkit

## What Is This
Portable Claude Code skills, commands, and workflows. Install once, use in every repo.

## Install
```bash
./install.sh
```
Symlinks `.claude/` folders to `~/.claude/` — skills available globally.

## How It Works

All skills are **OFF by default** (`disable-model-invocation: true`) to save tokens.
Only `/setup` is always active.

**In any repo:**
```
/setup          → pick which skills to enable, copies to that repo's .claude/
```

## Skills (8 total — 7 OFF + setup ON)

| Skill | What it does |
|-------|-------------|
| `setup` | Set up skills for any repo (always ON) |
| `pr` | PR ops: auto review+fix+push+resolve, manual review, fix comments |
| `git` | Git ops: clean branches + sync, create releases/tags |
| `proposal` | Technical proposals for lead approval |
| `implement` | Implement tasks following codebase patterns |
| `research` | Research with structured reports |
| `deploy` | Local dev, Vercel, AWS handoff |
| `skill-writer` | Create/edit Claude skills |

## Commands

| Command | When |
|---------|------|
| `/setup` | First time in a repo |
| `/pr 123` or `/pr 123 auto` | Full auto: worktree → review → fix → test → push → reply → resolve |
| `/pr 123 review` | Review PR, present findings |
| `/pr 123 review comment` | Review PR and post inline comments |
| `/pr 123 fix` | Fix existing review comments, push, reply, resolve |
| `/git clean` | Sync branches, delete old local releases, reduce .git |
| `/git release` | Create tag + GitHub release from package.json version |
| `/git release v1.2.3` | Release specific version |
| `/git release patch` | Bump patch, tag, release |
| `/auto` | Full feature workflow with approval gates |
| `/auto:fast` | Small tasks, skip proposal |
| `/auto:research-only` | Research + proposal, no code |
| `/proposal` | Write a proposal |
| `/implement` | Code a task |
| `/research` | Research a topic |
| `/deploy` | Deploy |
| `/skill` | Create/edit a skill |
| `/learn` | Reflect and improve skills after any work |

## Principles
- YAGNI, KISS, DRY
- All skills OFF globally — enable per repo via `/setup`
- Auto-fix on failure — retry up to 3x before asking user
- After any workflow → learn step: summarize, propose skill updates, apply only after user confirms
- No AI attribution in code or commits
- Concise reports — no fluff

## Structure
```
skong/
├── install.sh              ← symlinks to ~/.claude/
├── CLAUDE.md               ← this file
├── .claude/
│   ├── settings.json       ← global permissions (symlinked)
│   ├── skills/             ← all skill definitions (symlinked)
│   └── commands/           ← slash commands (symlinked)
└── .gitignore
```

## Edit Skills
Edit files in `.claude/skills/` — changes apply everywhere (symlinked).
Add new skills → they appear in `/setup` menu automatically.
