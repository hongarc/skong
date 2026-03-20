# Skong

Portable Claude Code skills toolkit. Install once, use in every repo.

## Quick Start

```bash
git clone <repo-url>
cd skong
./install.sh
```

Then in any project:
```
/setup
```

## What's Included

**8 skills** (7 OFF by default + setup always ON, zero token cost):

| Skill | What it does |
|-------|-------------|
| `setup` | Set up skills for any repo (always ON) |
| `pr` | PR: auto review+fix+push+resolve, manual review, fix comments |
| `git` | Git: clean branches, create releases/tags |
| `proposal` | Technical proposals for lead approval |
| `implement` | Implement tasks following codebase patterns |
| `research` | Research with structured reports |
| `deploy` | Local dev, Vercel, AWS handoff |
| `skill-writer` | Create/edit Claude skills |

**Auto workflows**: `/auto`, `/auto:fast`, `/auto:research-only`

**Self-improving**: `/learn` reflects on work and proposes skill updates

## Install / Uninstall

```bash
./install.sh             # Install (symlink to ~/.claude/)
./install.sh --status    # Check what's linked
./install.sh --unlink    # Remove all symlinks
```

## How It Works

1. `install.sh` symlinks `skong/.claude/` → `~/.claude/` (skills, commands, workflows, settings)
2. All skills OFF by default — only `/setup` is active
3. `/setup` in any repo → pick skills → copies + enables them for that repo
4. Copies go into the target repo's `.claude/` (committable to git, team can use)
5. After every workflow → `/learn` suggests skill improvements

## Adding a New Skill

```
.claude/skills/my-skill/
├── SKILL.md           ← under 100 lines, include: disable-model-invocation: true
└── references/        ← detailed docs, each under 100 lines
```

Appears in `/setup` menu automatically.

## Editing Skills

Edit in `skong/.claude/skills/`. Changes apply everywhere instantly (symlinked).
Per-repo copies are independent — won't be affected.
