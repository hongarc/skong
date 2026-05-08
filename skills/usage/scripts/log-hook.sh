#!/bin/bash
# Claude Code usage-tracking hook.
#
# Called from ~/.claude/settings.json on UserPromptSubmit / PreToolUse / PostToolUse / Stop.
# Reads the hook payload from stdin, prepends timestamp + event name, appends a JSON line to:
#   ~/.claude/logs/usage.jsonl
#
# Usage in settings.json:
#   "hooks": {
#     "PreToolUse":  [{"hooks":[{"type":"command","command":"~/.claude/skills/usage/scripts/log-hook.sh tool_pre"}]}],
#     "PostToolUse": [{"hooks":[{"type":"command","command":"~/.claude/skills/usage/scripts/log-hook.sh tool_post"}]}],
#     "UserPromptSubmit": [{"hooks":[{"type":"command","command":"~/.claude/skills/usage/scripts/log-hook.sh prompt"}]}],
#     "Stop": [{"hooks":[{"type":"command","command":"~/.claude/skills/usage/scripts/log-hook.sh stop"}]}]
#   }
#
# Designed to be FAST and never block Claude:
#   - reads stdin once
#   - single jq invocation
#   - returns 0 even if write fails (we don't want to break the user's flow)

set -uo pipefail

LOG="${HOME}/.claude/logs/usage.jsonl"
EVENT="${1:-unknown}"
mkdir -p "$(dirname "$LOG")" 2>/dev/null || true

# Capture payload (may be empty for Stop)
PAYLOAD=$(cat 2>/dev/null || true)
[ -z "$PAYLOAD" ] && PAYLOAD='{}'

# Timestamp with ms precision (gdate on macOS via coreutils; fallback to second precision)
if command -v gdate >/dev/null 2>&1; then
  TS=$(gdate -u +%Y-%m-%dT%H:%M:%S.%3NZ)
else
  TS=$(date -u +%Y-%m-%dT%H:%M:%SZ)
fi

# Build a compact line: pull the few high-value fields, drop large blobs
if command -v jq >/dev/null 2>&1; then
  echo "$PAYLOAD" | jq -c \
    --arg ts "$TS" \
    --arg ev "$EVENT" \
    '{
      ts: $ts,
      ev: $ev,
      sid: (.session_id // null),
      cwd: (.cwd // null),
      tool: (.tool_name // null),
      skill: (.tool_input.skill // .skill // null),
      args_chars: ((.tool_input | tostring | length) // 0),
      prompt_chars: ((.prompt | tostring | length) // 0)
    }' >> "$LOG" 2>/dev/null || true
else
  # No jq → at least record event + timestamp so we don't lose data
  printf '{"ts":"%s","ev":"%s"}\n' "$TS" "$EVENT" >> "$LOG" 2>/dev/null || true
fi

exit 0
