# Skong

Portable Claude Code toolkit: **18 skills · 53 quantum agents · workflow commands · usage tracking**. Install once, use in every repo.

## Install

**Option A: Symlink (personal)**
```bash
git clone git@github.com:hongarc/skong.git
cd skong
./scripts/install.sh
```

**Option B: Claude Plugin (shareable)**
```
/plugin marketplace add hongarc/skong
/plugin install skong@hongarc-skong
```

## Layout

```
skong/
├── .claude-plugin/      ← plugin.json + marketplace.json
├── agents/              ← 53 quantum agents (.md)
├── commands/            ← slash commands (/q, /pr, /git, ...)
├── skills/              ← 18 skills
├── hooks/               ← usage-log.sh + future hook scripts
├── docs/                ← agents-registry, design notes
├── examples/            ← settings.example.json, agent-template.md
├── scripts/             ← install.sh, verify.sh
├── README.md · CLAUDE.md
```

## Skills (18)

| Skill | What it does |
|-------|-------------|
| `auto` | Full workflow: research → propose → implement → review → commit |
| `aws` | SSM params, profile switching, secrets |
| `client-report` | Investigate client-reported issues end-to-end |
| `deploy` | Local dev, Vercel, AWS handoff |
| `gh-pages-publish` | Publish docs to GitHub Pages |
| `git` | Clean branches, releases, tags |
| `handover` | Feature handover docs with debug runbook |
| `implement` | Implement tasks following codebase patterns |
| `learn` | Distill lessons → skill updates |
| `pr` | PR auto-review + fix + push + resolve |
| `proposal` | Technical proposals for lead approval |
| `release` | Everfit release flow (master → tag → propagate) |
| `research` | Structured research reports |
| `review-inbox` | Manage PR review inbox |
| `security-review` | Security checklist for auth/OTP/crypto |
| `setup` | Set up skills in any repo |
| `skill-writer` | Create/edit Claude skills |
| `usage` | Daily/weekly usage report (skills · agents · tools · time) |

## Quantum agents (46)

Each agent is a single-purpose subagent named after a quantum particle, with restricted toolset and persistent memory at `~/.claude/agents-memory/<name>/MEMORY.md`.

See [`docs/agents-registry.md`](docs/agents-registry.md) for the full roster + `Loads` column. Highlights:

| Agent | Role |
|-------|------|
| `higgs` | Adversarial reviewer — finds blockers, security holes, edge cases |
| `neutrino` | Root-cause debugger — 4-phase investigation |
| `quark` | Implementer — RED→GREEN from approved plan |
| `boson` | Planner — phased plans with rollback |
| `photon` | Researcher — option comparisons with citations |
| `antiquark` | Security auditor — OWASP/STRIDE adversarial |
| `pion` | Performance profiler |
| `electron` | Git manager (conventional commits) |
| `tachyon` | Scout — fastest read-only search |
| `gluon` | Issue/PR triager |
| `chronon` | Meeting notetaker |
| `theta` | Incident reporter — postmortems |
| `sigma` | Status reporter — weekly/monthly |
| `plasmon` | Scrum master |
| `meson` | Business analyst |
| `anyon` | Skill designer — extends this toolkit |

## Workflows — `/q`

Chains of agents, end-to-end:

| Command | Chain |
|---------|------|
| `/q feature` | boson → quark → muon → higgs → electron |
| `/q bug` | neutrino → muon → quark → higgs |
| `/q release` | wino → spinor → electron → lepton |
| `/q incident` | theta → neutrino → instanton → delta |
| `/q research` | photon → graviton → boson |
| `/q pr` | higgs ‖ antiquark ‖ pion ‖ muon (parallel) |
| `/q onboard` | glueball → chi → tailored path |

## Commands

| Command | What it does |
|---------|-------------|
| `/auto [task]` | Full: research → proposal → implement → review → commit |
| `/q <workflow>` | Quantum agent workflow (see above) |
| `/pr <#>` | PR auto-review + fix + push + resolve |
| `/git clean \| release` | Branch + release ops |
| `/usage [today\|week\|agent <n>]` | Usage report |
| `/daily-pr-review` | Auto-review unreviewed teammate PRs |
| `/release` | Everfit release flow |
| `/demo` | Record demo GIF |

## Manage

```bash
./scripts/install.sh            # Symlink install
./scripts/install.sh --status   # Check links
./scripts/install.sh --unlink   # Remove links
./scripts/verify.sh             # Health check (frontmatter, refs, syntax)
```

## Hooks (optional, for usage tracking)

Copy `examples/settings.example.json` → `~/.claude/settings.json` (or merge). The hooks call `~/.claude/hooks/usage-log.sh` on every prompt + tool event, then `/usage` reports against `~/.claude/logs/usage.jsonl`.

## Adding skills

```
skills/my-skill/
├── SKILL.md             ← under 100 lines
└── references/          ← detail docs, each under 100 lines
```

Edit `skills/` directly — changes apply everywhere via symlink, or commit + reinstall via plugin.

## Adding agents

Copy `examples/agent-template.md` to `agents/<new-particle>.md`, fill in frontmatter + body. Run `./scripts/verify.sh` before commit.
