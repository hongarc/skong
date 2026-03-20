Deploy the project: $ARGUMENTS

Activate the `deploy` skill.

If argument is "local" or empty:
- Start local dev server

If argument is "vercel" or "preview":
- Run Vercel preview deployment

If argument is "prod" or "production":
- Run Vercel production deployment (confirm with user first)

If argument is "aws":
- Generate AWS handoff document for the AWS team

Always verify build succeeds before deploying.
