# Auto-resolve merge conflicts (think, don't blindly take a side)

Called from `merge-targets.md` after `git merge origin/master --no-ff --no-commit` produced conflicts. Goal: resolve trivially-decidable conflicts; escalate the rest.

## 1 — Enumerate conflicts

```bash
mapfile -t CONFLICTS < <(git diff --name-only --diff-filter=U)
```

For each `$file`, classify with the rules below. Track:
- `RESOLVED+=("$file: $reason")` when auto-fixed
- `MANUAL+=("$file: $reason")` when escalated

## 2 — Per-file rules (apply first match)

### Rule A — Generated lockfiles
Files: `package-lock.json`, `yarn.lock`, `pnpm-lock.yaml`, `Cargo.lock`, `go.sum`.

```bash
git checkout --theirs "$file"   # take the master side as a base
case "$file" in
  package-lock.json) npm install --package-lock-only --ignore-scripts ;;
  yarn.lock)         yarn install --mode update-lockfile ;;
  pnpm-lock.yaml)    pnpm install --lockfile-only ;;
  Cargo.lock)        cargo generate-lockfile ;;
  go.sum)            go mod tidy ;;
esac
git add "$file"
```

### Rule B — `package.json` `version` field
If the only conflict hunk is on the `"version":` line → take master's version (releases bump version on master):

```bash
git checkout --theirs -- "$file"      # master side
git add "$file"
```

If `package.json` has OTHER conflicts (deps, scripts) → fall through to Rule E.

### Rule C — Purely additive on one side (one side empty / only comments)
For each conflict marker block, parse `<<<<<<<` / `=======` / `>>>>>>>`:

- If one side is empty / only blank lines → take the non-empty side.
- If one side contains only `//`, `#`, or `/* */` comments and the other has real code → take the real-code side.

Apply with `git merge-file -p` strategies or hand-edit. Always reread the file after editing.

### Rule D — Whitespace / formatting only
If `git diff --check` flags the hunk as whitespace-only OR `git diff -w` shows zero functional difference → take the side closer to master (HEAD-of-master changes typically reflect intentional reformatting).

```bash
git checkout --theirs -- "$file"
git add "$file"
```

### Rule E — Semantic conflict (real code on both sides)
Do NOT auto-resolve. Add to `MANUAL` with one-line summary of what each side does. Example summary:

```
modules/macro/service.js: HEAD adds `getReportV2`; master adds `getReportV3` exporting from same line.
```

User must hand-resolve. After they confirm, continue to the commit/push step.

## 3 — Sanity gate before committing

After all rules applied, re-check:

```bash
git diff --name-only --diff-filter=U   # should be empty
```

If not empty → there are still markers; loop back or escalate.

Optional safety:

```bash
# Catch leftover conflict markers that slipped through
grep -RIn '^<<<<<<< \|^======= $\|^>>>>>>> ' --include='*.{js,ts,json,md,yml,yaml}' . \
  && { echo "Leftover markers"; exit 1; }
```

## 4 — Output to caller

Pass back two lists:

```
RESOLVED:
  - package-lock.json: regenerated via npm install
  - package.json: kept master version 3.92.6
  - workers/handler/macro/x.js: comment-only on develop side, kept master code

MANUAL:
  - modules/macro/service.js: both sides add new exported functions; needs human review
```

Caller decides whether to STOP (manual list non-empty) or proceed.

## Principles

- **Think before picking a side.** "Take theirs" without reasoning is how regressions ship.
- **Lockfiles regenerate, never hand-merge.**
- **Version field always follows master** in a release flow.
- **Comments lose to code** when the other side has real changes.
- **When in doubt, escalate.** A 2-minute human review beats a 2-day production fire.
