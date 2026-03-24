# Git Release

## Step 1: Detect Version

1. If arg provided (`/git release v1.2.3`) → use it
2. If bump keyword (`patch`, `minor`, `major`) → `npm version <keyword> --no-git-tag-version`
3. Otherwise → `node -e "console.log(require('./package.json').version)"`

## Step 2: Verify State

```bash
BRANCH=$(git branch --show-current)
git status --porcelain       # must be empty
git fetch origin
git rev-list --left-right --count origin/$BRANCH...$BRANCH  # must be 0/0
```

Not on main/master → ask. Dirty → ask to commit. Behind → pull first.

## Step 3: Present Plan (1 question)

```
Release Plan:
  Version: v1.2.3
  Branch: main (up to date)
  Changelog (since last tag):
    - feat: add user export endpoint
    - fix: pagination off-by-one
Proceed? (yes / no)
```

## Step 4: Tag + Push + Release

```bash
TAG="v${VERSION#v}"
LAST_TAG=$(git describe --tags --abbrev=0 HEAD^ 2>/dev/null || echo "")
CHANGELOG=$(git log --oneline "${LAST_TAG:+$LAST_TAG..}HEAD" | head -30)

git tag -a "$TAG" -m "Release $TAG"
git push origin "$TAG"

gh release create "$TAG" --title "$TAG" \
  --notes "## What's Changed
$CHANGELOG
**Full Changelog**: https://github.com/{owner}/{repo}/compare/${LAST_TAG}...${TAG}"
```

## Step 5: Summary

```
Tag: v1.2.3 → pushed
Release: [URL]
Commits: [count] since last release
```

## Rules
- Always from main/master unless user specifies
- Always show plan with changelog before creating
- Push tag before creating GitHub release
- Never release from dirty working tree
- Tag format: `v1.2.3` (always prefix v)
