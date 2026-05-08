---
name: usage
description: "Show daily / weekly Claude Code usage report — which skills you ran, where (cwd / repo), how long each took, time spent thinking vs in tools. Reads from ~/.claude/logs/usage.jsonl populated automatically by hook scripts. Triggers on: usage report, claude usage, skill stats, time tracking, /usage, how much did I use claude, what skills did I run. NOT for: implementing skills (use skill-writer) or installing hooks (see references/install-hooks.md)."
argument-hint: "[today|day|week|skill <name>|cwd <path>|raw]  default: today"
version: 1.0.0
disable-model-invocation: true
---

Parse `$ARGUMENTS`:
- `today` / `day` / empty → today's report
- `yesterday` → yesterday
- `week` → last 7 days
- `skill <name>` → only entries for that skill (e.g. `skill release`)
- `cwd <path>` → only entries whose `cwd` starts with `<path>`
- `raw` → tail the last 50 raw JSONL lines

All reports run via `~/.claude/skills/usage/scripts/summarize.sh <mode> <args>`.

## Output sections (per period)

1. **Top-line**
   - Total user prompts, total tool calls, total skill invocations, total wall time, total tool time → derived "thinking time" (wall − tool).
2. **Skills** — table sorted by total duration:
   ```
   skill            count   total      avg       p95
   release          1       4m 12s     4m 12s    —
   pr               3       1m 45s     35s       58s
   ```
3. **Tools** — same shape, but for raw tool calls (Bash, Read, Edit, etc.).
4. **Per-cwd / repo** — breakdown of activity by working dir.
5. **Sessions** — count of distinct `session_id`s and average prompts per session.

If no log lines for the period → print "No usage logged. Did you install the hooks? See `references/install-hooks.md`."

## Files

- Log: `~/.claude/logs/usage.jsonl` (one JSON event per line, see `references/log-format.md`).
- Hook script: `~/.claude/skills/usage/scripts/log-hook.sh <event>` (called from settings.json).
- Summary script: `~/.claude/skills/usage/scripts/summarize.sh <mode> [args...]`.

## Anti-triggers

- "create a new skill" → `/skill-writer`.
- "review my recent code" → `/code-review` or `/pr`.
- "set up hooks" → see `references/install-hooks.md`, do NOT auto-edit settings.json without user OK.
