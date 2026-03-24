# Git Clean

## Step 1: Analyze

```bash
git fetch --all --prune
git branch
git branch -r
du -sh .git
git count-objects -vH
```

## Step 2: Check Protected Branch Sync

For main/master, develop — check local vs remote:
```bash
git rev-list --left-right --count origin/<branch>...<branch>
```
- Behind only → will auto-pull
- Diverged → flag for user
- Up to date → skip

For release branches — only keep and pull the **latest** one. Delete older local.

## Step 3: Present Plan (1 question)

```
Git Cleanup Plan for [repo]
.git size: [size]

Protected branches:
  ✓ main       — up to date
  ↓ develop    — 12 behind → will pull

Release branches:
  ↓ release_v3.86.2 — latest, will pull
  ✗ release_v3.84.0, ... — 22 older → will delete local

Local (non-release): keeping all

Proceed? (yes / no / let me pick)
```

## Step 4: Execute

1. Pull develop (`--ff-only`)
2. Pull latest release branch (`--ff-only`)
3. Delete older local release branches (`git branch -D`)
4. `git gc --prune=now --aggressive`
5. `git repack -a -d --depth=250 --window=250`
6. `git reflog expire --expire=now --all`

## Step 5: Summary

```
- Synced: develop (+12), release_v3.86.2 (+52)
- Deleted local: 22 older release branches
- .git: 182M → 105M
```

## Rules
- NEVER delete remote branches
- NEVER delete non-release local branches
- Only delete older local release branches — keep latest
- Diverged → skip, warn user
