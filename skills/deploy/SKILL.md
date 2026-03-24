---
name: deploy
description: "Deploy projects: local dev, Vercel, AWS handoff. Triggers on: deploy, ship, vercel, local dev. NOT for: git releases (use /git release) or CI/CD pipeline changes."
version: 1.0.0
---

# Deploy Skill

## When to Use
- Starting local development server
- Deploying to Vercel
- Preparing AWS deployment handoff

## Local Development
```bash
npm install
npm run dev
```
- Check `package.json` for available scripts
- Verify `.env` or `.env.local` exists

## Vercel Deployment
1. Ensure `vercel` CLI available: `npx vercel --version`
2. Preview deploy: `npx vercel`
3. Production deploy: `npx vercel --prod`
4. Check deployment: `npx vercel ls`
- See `references/vercel-checklist.md`

## AWS Handoff
When deployment needs AWS:
1. Document what needs to be deployed
2. List environment variables needed
3. Note any infrastructure changes
4. Create a handoff doc for AWS team
- See `references/aws-handoff-template.md`

## Key Rules
- Never deploy to production without testing preview first
- Check environment variables are set correctly
- Verify build succeeds locally before deploying
- No secrets in deployment configs
