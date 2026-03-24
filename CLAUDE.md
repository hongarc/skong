# Skong — Claude Code Skills Toolkit

## What Is This
Portable Claude Code skills. Install once, use in every repo.

## Install

**Option A: Symlink (personal)**
```bash
./install.sh
```

**Option B: Claude plugin (shareable)**
```
/plugin marketplace add hongarc/skong
/plugin install skong@hongarc-skong
```

## Skills (10 total — all ON)

| Skill | Usage |
|-------|-------|
| `setup` | `/setup` — set up skills for any repo |
| `auto` | `/auto [task]` `/auto:fast` `/auto:research-only` |
| `pr` | `/pr 123` `/pr 123 review` `/pr 123 fix` |
| `git` | `/git clean` `/git release` |
| `proposal` | `/proposal` |
| `implement` | `/implement` |
| `research` | `/research` |
| `deploy` | `/deploy` |
| `handover` | `/handover [feature]` |
| `skill-writer` | `/skill-writer` |

## Principles
- YAGNI, KISS, DRY
- Auto-fix on failure — retry up to 3x
- After any workflow → learn step
- No AI attribution
- Concise — no fluff

## Structure
```
skong/
├── .claude-plugin/         ← plugin marketplace manifest
├── skills/                 ← 10 skills
├── commands/               ← pr.md, git.md
├── settings.json           ← global permissions
├── install.sh              ← symlink installer
├── CLAUDE.md
└── README.md
```
