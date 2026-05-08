# Sync master + tag + GitHub release

## §1 — Pre-flight

```bash
# Verify gh account
gh auth status 2>&1 | grep -q "hongarc" || { echo "Switch gh: gh auth switch -u hongarc"; exit 1; }

# Working tree must be clean
DIRTY=$(git status --porcelain)
[ -n "$DIRTY" ] && { echo "Dirty tree, commit/stash first"; exit 1; }

git fetch origin --tags --prune --force
```

Show plan:

```
Release plan
  Version  : v<X.Y.Z>
  Source   : origin/master @ <sha>
  Tag      : v<X.Y.Z>  (will overwrite if exists)
  Targets  : develop, releasing_staging, master-debugging
Proceed? (yes / no)
```

Use AskUserQuestion. On `no` → stop.

## §2 — Reset local master

```bash
# Detach if currently on master so we can delete it
[ "$(git branch --show-current)" = "master" ] && git checkout --detach
git branch -D master 2>/dev/null || true
git checkout -B master origin/master
```

Confirm: `git rev-parse HEAD` should equal `git rev-parse origin/master`.

## §3 — Tag

```bash
TAG="v${VERSION#v}"

# Local tag — delete if exists
git tag -d "$TAG" 2>/dev/null || true

# Remote tag — delete if exists (this overwrites GitHub-side too)
git ls-remote --tags origin "refs/tags/$TAG" | grep -q . \
  && git push origin ":refs/tags/$TAG"

# Create + push (annotated)
git tag -a "$TAG" -m "Release $TAG"
git push origin "$TAG"
```

If a release already exists for that tag, GitHub may keep it pointing at a stale commit. Step §4 will overwrite via `gh release edit` or delete-then-create.

## §4 — GitHub release

```bash
# Previous tag for changelog range
PREV=$(git describe --tags --abbrev=0 "$TAG^" 2>/dev/null || true)

# Build changelog (no merge commits)
RANGE="${PREV:+$PREV..}$TAG"
CHANGELOG=$(git log "$RANGE" --pretty='- %s (%h)' --no-merges)

NOTES_FILE=$(mktemp)
{
  echo "## What's Changed"
  echo
  echo "$CHANGELOG"
  echo
  [ -n "$PREV" ] && echo "**Full Changelog**: https://github.com/Everfit-io/everfit-api/compare/$PREV...$TAG"
} > "$NOTES_FILE"

# Delete existing release if present, then create fresh
gh release view "$TAG" --repo Everfit-io/everfit-api >/dev/null 2>&1 \
  && gh release delete "$TAG" --repo Everfit-io/everfit-api --yes

gh release create "$TAG" \
  --repo Everfit-io/everfit-api \
  --target master \
  --title "$TAG" \
  --notes-file "$NOTES_FILE"

rm -f "$NOTES_FILE"
```

## Outputs to capture

- Tag URL: `https://github.com/Everfit-io/everfit-api/releases/tag/$TAG`
- Release URL: from `gh release create` stdout
