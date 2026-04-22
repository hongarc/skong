---
name: gh-pages-publish
description: "Publish a local static site (HTML/CSS/JS) to GitHub Pages end-to-end: init repo, commit, create public repo, push, enable Pages. Triggers on: publish to github pages, gh pages, serve with github pages, host this html, publish this page. NOT for: deploying apps to Vercel/AWS (use /deploy), or existing repos already on Pages (just push)."
argument-hint: "[repo-name]"
version: 1.0.0
disable-model-invocation: true
---

Publish the current directory as a static GitHub Pages site. ALWAYS confirm before any push — public repo creation is visible to others and not auto-reversible.

## Step 1: Gather inputs (ASK — don't infer)

Confirm ALL of these with the user before touching anything remote:

1. **gh account** — run `gh auth status`; if multiple accounts, ask which to use.
2. **repo name** — default to current folder basename; let user override. Use `$ARGUMENTS` as default if provided.
3. **visibility** — default public (required for free Pages).
4. **commit author email** — ASK. Do NOT read from `git config user.email`. User has been burned by wrong inferred emails.
5. **commit author name** — default to gh account login; confirm.

## Step 2: Local git setup

```bash
# Init if needed (don't re-init an existing repo)
[ -d .git ] || git init -b main

# Stage and commit with per-command identity — do NOT mutate global git config
git add <files>   # prefer specific files; avoid `git add -A` if unsure about secrets
git -c user.name="<name>" -c user.email="<email>" commit -m "Initial commit"
```

If the user's first commit ended up with the wrong email (common), amend:
```bash
git -c user.name="<name>" -c user.email="<email>" commit --amend --reset-author --no-edit
```

## Step 3: Create repo and push

```bash
# Ensure correct active gh account
gh auth switch --user <account>   # only if currently wrong

gh repo create <name> --public --source=. --remote=origin --push
```

**Known pitfall**: if SSH is configured for a different GitHub user, the push step inside `gh repo create` fails with `Permission denied to <other-user>`. Fallback:
```bash
git remote set-url origin https://github.com/<user>/<repo>.git
gh auth setup-git
git push -u origin main
```

## Step 4: Enable Pages

```bash
gh api -X POST repos/<user>/<repo>/pages \
  -f "source[branch]=main" -f "source[path]=/"
```

Site URL: `https://<user>.github.io/<repo>/` (first build ~30–60s).

Check build:
```bash
gh api repos/<user>/<repo>/pages/builds/latest
```

## Step 5: Offer follow-ups

After reporting the live URL, offer optional settings. See `references/follow-ups.md`.

## Rules

- Never push or create a repo without explicit user approval in this turn.
- Never modify global git config; always use `-c user.name=... -c user.email=...`.
- Always ASK for commit email; never infer from existing git config.
- Keep updates terse — one sentence per step.
- Report the final live URL clearly.
