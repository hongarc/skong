# Git Release

## Step 1: Detect Version

Check in order:
1. If version passed as arg (e.g., `/git release v1.2.3`) → use it
2. If bump keyword (`patch`, `minor`, `major`) → read current + bump
3. Otherwise → read from project files:

```bash
# package.json (Node.js)
node -e "console.log(require('./package.json').version)"

# Or check other files:
# - version.txt
# - pyproject.toml: grep 'version =' pyproject.toml
# - Cargo.toml: grep '^version' Cargo.toml
```

## Step 2: Verify State

```bash
# Must be on main/master with clean state
BRANCH=$(git branch --show-current)
# Verify branch is main or master
git status --porcelain  # must be empty
git fetch origin
git rev-list --left-right --count origin/$BRANCH...$BRANCH
# Must be up to date (0 behind, 0 ahead)
```

If not on main/master: ask user to confirm.
If dirty working tree: ask user to commit or stash first.
If behind remote: pull first.

## Step 3: Present Plan (1 question)

```
Release Plan:
  Version: v1.2.3
  Branch: main (up to date with remote)
  Tag: v1.2.3
  GitHub Release: v1.2.3

  Changelog (commits since last tag):
    - feat: add user export endpoint
    - fix: pagination off-by-one
    - chore: update dependencies

Proceed? (yes / no)
```

## Step 4: Create Tag

```bash
# Prefix with v if not already
TAG="v${VERSION#v}"

git tag -a "$TAG" -m "Release $TAG"
git push origin "$TAG"
```

## Step 5: Create GitHub Release

```bash
# Get commits since last tag for changelog
LAST_TAG=$(git describe --tags --abbrev=0 HEAD^ 2>/dev/null || echo "")

if [ -n "$LAST_TAG" ]; then
  CHANGELOG=$(git log --oneline "$LAST_TAG"..HEAD)
else
  CHANGELOG=$(git log --oneline -20)
fi

gh release create "$TAG" \
  --title "$TAG" \
  --notes "$(cat <<EOF
## What's Changed

$CHANGELOG

**Full Changelog**: https://github.com/{owner}/{repo}/compare/${LAST_TAG}...${TAG}
EOF
)"
```

## Step 6: Summary

```
Release complete:
  Tag: v1.2.3 → pushed
  Release: https://github.com/{owner}/{repo}/releases/tag/v1.2.3
  Commits: [count] since last release
```

## Bump Helpers

If user says `patch`, `minor`, `major`:
```bash
# Current: 1.2.3
# patch → 1.2.4
# minor → 1.3.0
# major → 2.0.0

# For Node.js projects:
npm version patch --no-git-tag-version  # updates package.json
# Then commit, tag, push
```

## Rules
- Always from main/master unless user specifies
- Always show plan with changelog before creating
- Always push tag before creating GitHub release
- Never release from dirty working tree
- Tag format: `v1.2.3` (always prefix with v)
