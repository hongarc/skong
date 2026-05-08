---
description: Daily / weekly Claude Code usage report — skills, tools, time, repos
argument-hint: "[today|day|yesterday|week|skill <name>|cwd <path>|raw]"
---

Activate the `usage` skill: $ARGUMENTS

Examples:
- `/usage` or `/usage today` → today's report
- `/usage yesterday` → yesterday
- `/usage week` → last 7 days
- `/usage skill release` → all `release` invocations
- `/usage cwd ~/project/api/everfit-api` → activity in that repo
- `/usage raw 100` → tail last 100 raw events

Reads `~/.claude/logs/usage.jsonl`, populated by hooks in settings.json.
First-time setup: see `~/.claude/skills/usage/references/install-hooks.md`.
