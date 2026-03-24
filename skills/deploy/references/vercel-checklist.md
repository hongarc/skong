# Vercel Deployment Checklist

## Pre-Deploy
- [ ] `npm run build` succeeds locally
- [ ] Environment variables set in Vercel dashboard
- [ ] No hardcoded URLs (use env vars)
- [ ] Node.js version matches Vercel runtime

## Deploy Steps
1. Preview: `npx vercel` — get preview URL
2. Test preview URL manually
3. Production: `npx vercel --prod`
4. Verify production URL

## Post-Deploy
- [ ] Check Vercel dashboard for errors
- [ ] Test key functionality on production
- [ ] Notify team on Slack if needed

## Rollback
- `npx vercel rollback` — reverts to previous deployment
- Or redeploy specific commit from Vercel dashboard

## Environment Variables
- Set via `npx vercel env add NAME`
- Or Vercel dashboard → Settings → Environment Variables
- Separate values for Preview/Production/Development
