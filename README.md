# Skong

Portable Claude Code skills toolkit. Install once, use in every repo.

## Install

**Option A: Symlink**
```bash
git clone git@github.com:hongarc/skong.git
cd skong
./install.sh
```

**Option B: Claude Plugin**
```
/plugin marketplace add hongarc/skong
/plugin install skong@hongarc-skong
```

## Skills

**10 skills** (all ON, auto-activate based on context):

| Skill | What it does |
|-------|-------------|
| `setup` | Set up skills for any repo |
| `auto` | Full workflow: research → propose → implement → review → commit |
| `pr` | PR: auto review+fix+push+resolve, manual review, fix comments |
| `git` | Clean branches, create releases/tags |
| `proposal` | Technical proposals for lead approval |
| `implement` | Implement tasks following codebase patterns |
| `research` | Research with structured reports |
| `deploy` | Local dev, Vercel, AWS handoff |
| `handover` | Feature handover docs: hidden logic, debug runbook, DB queries |
| `skill-writer` | Create/edit Claude skills |

## Commands

| Command | What it does |
|---------|-------------|
| `/auto [task]` | Full: research → proposal → implement → review → commit |
| `/auto:fast [task]` | Skip proposal, quick implement + review |
| `/auto:research-only` | Research + proposal only |
| `/pr 123` | Full auto PR: worktree → review → fix → push → resolve |
| `/pr 123 review` | Review PR, present findings |
| `/pr 123 fix` | Fix review comments, push, reply, resolve |
| `/git clean` | Sync branches, delete old local releases, reduce .git |
| `/git release` | Create tag + GitHub release from package.json |
| `/handover [feature]` | Generate handover doc with debug runbook |

## Manage

```bash
./install.sh             # Install
./install.sh --status    # Check links
./install.sh --unlink    # Remove links
```

## Adding Skills

```
skills/my-skill/
├── SKILL.md           ← under 100 lines
└── references/        ← detailed docs, each under 100 lines
```

Edit `skills/` directly — changes apply everywhere.
