---
name: release
description: "End-to-end release flow for everfit-api: sync master, tag vX.Y.Z, create GitHub release, then merge master into develop / releasing_staging / master-debugging with auto-resolved or PR-mediated conflicts. Triggers on: release, /release, ship version, cut release, tag and propagate. NOT for: simple commits, single-branch tagging (use /git release instead), or PR review."
argument-hint: "<version>  e.g.  /release 3.92.6"
version: 1.0.0
disable-model-invocation: true
---

Parse `$ARGUMENTS` as the version (e.g. `3.92.6`). If absent → use AskUserQuestion to ask before starting. Strip a leading `v` if present.

Defaults (everfit-api):
- Repo: `Everfit-io/everfit-api`
- gh account: `hongarc` (verify with `gh auth status`)
- Release source: `master`
- Merge targets: `develop`, `releasing_staging`, `master-debugging`
- Branch shortnames for merge branches: develop→`dev`, releasing_staging→`staging`, master-debugging→`debug`

## Pipeline (run sequentially, abort on first failure)

1. **Pre-flight** — see `references/sync-and-tag.md` §1
   - `git status --porcelain` must be empty (or stash with user OK)
   - `git fetch origin --tags --prune --force`
   - Show plan (version, target tag, 3 merge targets) and ask one yes/no.

2. **Reset local master** — `references/sync-and-tag.md` §2
   - `git checkout --detach 2>/dev/null` if currently on master
   - `git branch -D master 2>/dev/null || true`
   - `git checkout -B master origin/master`

3. **Tag `v<version>`** — `references/sync-and-tag.md` §3
   - Delete local tag if exists, delete remote tag if exists (`git push origin :refs/tags/vX.Y.Z`)
   - `git tag -a vX.Y.Z -m "Release vX.Y.Z"` → `git push origin vX.Y.Z`

4. **GitHub release** — `references/sync-and-tag.md` §4
   - Detect previous tag: `git describe --tags --abbrev=0 vX.Y.Z^`
   - Build changelog: `git log <prev>..vX.Y.Z --oneline --no-merges`
   - `gh release create vX.Y.Z --target master --title vX.Y.Z --notes-file <tmp>`

5. **Propagate to each merge target** — `references/merge-targets.md`
   - For each target in [develop, releasing_staging, master-debugging]:
     - Mergeability check via `git merge-tree --write-tree origin/<target> origin/master`
     - **CLEAN** → open PR `master → <target>` directly
     - **CONFLICT** → create branch `merge_master_to_<short>` off `origin/<target>`, merge `origin/master`, auto-resolve per `references/conflict-resolution.md`, push, open PR

6. **Summary** — print: tag URL, release URL, 3 PR URLs, per-target conflict report (clean / auto-resolved files / manual files).

## Hard Safety Rules

- **Never** force-push to `master`, `develop`, `releasing_staging`, `master-debugging`.
- **Never** `git reset --hard` on those branches.
- **Never** use `--no-verify` unless user explicitly opts in.
- Always confirm before destructive ops (branch deletion, tag overwrite).
- Memory hooks: respect `feedback_gh_account_everfit` (use `hongarc`) and `feedback_fetch_before_branching` (always `git fetch` first).

## Anti-triggers

- "commit and push my changes" → use `/git` or plain commit, not `/release`.
- "create just a tag" → `/git release` does that without the merge propagation.
- "review this PR" → use `/pr`.
