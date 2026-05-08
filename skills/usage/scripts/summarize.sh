#!/bin/bash
# Summarize ~/.claude/logs/usage.jsonl
#
# Usage:
#   summarize.sh today
#   summarize.sh yesterday
#   summarize.sh day YYYY-MM-DD
#   summarize.sh week                   # last 7 days
#   summarize.sh skill <name>           # all-time, scoped to one skill
#   summarize.sh cwd <path-prefix>      # all-time, scoped to one repo/dir
#   summarize.sh raw [N]                # tail N lines (default 50)

set -uo pipefail

LOG="${HOME}/.claude/logs/usage.jsonl"
MODE="${1:-today}"
ARG="${2:-}"

if [ ! -s "$LOG" ]; then
  echo "No usage logged at $LOG."
  echo "Install hooks: see ~/.claude/skills/usage/references/install-hooks.md"
  exit 0
fi

# ---- date helpers (mac-friendly) ----
today_iso() { date -u +%Y-%m-%d; }
ydate_iso() {
  if command -v gdate >/dev/null 2>&1; then gdate -u -d 'yesterday' +%Y-%m-%d
  else date -u -v-1d +%Y-%m-%d
  fi
}
days_ago_iso() {
  local n="$1"
  if command -v gdate >/dev/null 2>&1; then gdate -u -d "$n days ago" +%Y-%m-%d
  else date -u -v-"${n}"d +%Y-%m-%d
  fi
}

# ---- mode → date filter ----
case "$MODE" in
  today)     FROM=$(today_iso); TO="$FROM" ;;
  yesterday) FROM=$(ydate_iso); TO="$FROM" ;;
  day)       FROM="${ARG:-$(today_iso)}"; TO="$FROM" ;;
  week)      FROM=$(days_ago_iso 6); TO=$(today_iso) ;;
  skill)     FROM=""; TO=""; SKILL="$ARG" ;;
  cwd)       FROM=""; TO=""; CWDP="$ARG" ;;
  raw)
    tail -n "${ARG:-50}" "$LOG"
    exit 0
    ;;
  *) echo "Unknown mode: $MODE"; exit 2 ;;
esac

# ---- jq pipeline ----
# Apply filters and emit summary tables.
JQ_PRELUDE='
def in_range($from; $to):
  if ($from == "" or $to == "") then true
  else (.ts[0:10] >= $from) and (.ts[0:10] <= $to) end;
def matches_skill($s):
  if $s == "" then true
  else (.skill // "") == $s or (.tool_name == "Skill" and (.tool_input.skill // "") == $s)
  end;
def matches_cwd($p):
  if $p == "" then true else (.cwd // "") | startswith($p) end;
'

FROM_ARG="${FROM:-}"
TO_ARG="${TO:-}"
SKILL_ARG="${SKILL:-}"
CWD_ARG="${CWDP:-}"

FILTERED=$(jq -c \
  --arg from "$FROM_ARG" --arg to "$TO_ARG" \
  --arg skill "$SKILL_ARG" --arg cwdp "$CWD_ARG" \
  "$JQ_PRELUDE"' select(in_range($from; $to) and matches_skill($skill) and matches_cwd($cwdp))' \
  "$LOG")

if [ -z "$FILTERED" ]; then
  echo "No matching events for: mode=$MODE arg=$ARG"
  exit 0
fi

# ---- top-line counts ----
TOTAL=$(echo "$FILTERED" | wc -l | tr -d ' ')
PROMPTS=$(echo "$FILTERED" | jq -r 'select(.ev=="prompt") | .ts' | wc -l | tr -d ' ')
TOOLS=$(echo "$FILTERED" | jq -r 'select(.ev=="tool_pre") | .tool' | wc -l | tr -d ' ')
SKILLS_COUNT=$(echo "$FILTERED" | jq -r 'select(.ev=="tool_pre" and .tool=="Skill") | .skill' | wc -l | tr -d ' ')
SESSIONS=$(echo "$FILTERED" | jq -r '.sid // empty' | sort -u | wc -l | tr -d ' ')

# Compute durations: pair tool_pre with the next tool_post on same sid+tool
# (Claude doesn't run tools in parallel within one session, so this is safe.)
DURATIONS=$(echo "$FILTERED" | jq -r '
  select(.ev=="tool_pre" or .ev=="tool_post")
  | [.ts, .ev, (.sid // ""), (.tool // ""), (.skill // "")] | @tsv' \
  | awk -F'\t' '
    {
      key = $3 "|" $4
      if ($2 == "tool_pre") { pre[key] = $1; sk[key] = $5 }
      else if ($2 == "tool_post" && pre[key] != "") {
        # ms diff: convert ISO to epoch via date is slow; use string trick — fallback to 0
        cmd = "python3 -c \"from datetime import datetime as d;a=d.fromisoformat(\\\"" pre[key] "\\\".rstrip(\\\"Z\\\"));b=d.fromisoformat(\\\"" $1 "\\\".rstrip(\\\"Z\\\"));print(int((b-a).total_seconds()*1000))\""
        cmd | getline ms; close(cmd)
        printf "%s\t%s\t%d\n", $4, sk[key], ms
        pre[key] = ""
      }
    }')

# ---- pretty-print helpers ----
fmt_ms() {
  local ms="${1:-0}"
  [ -z "$ms" ] && ms=0
  awk -v ms="$ms" 'BEGIN{
    s = ms/1000
    if (s < 60) printf "%.1fs", s
    else if (s < 3600) printf "%dm %ds", int(s/60), int(s%60)
    else printf "%dh %dm", int(s/3600), int((s%3600)/60)
  }'
}

# ---- header ----
echo "==============================================================="
case "$MODE" in
  today|yesterday|day) echo "Claude Code usage — $FROM" ;;
  week)                echo "Claude Code usage — $FROM .. $TO" ;;
  skill)               echo "Claude Code usage — skill=$SKILL_ARG (all-time)" ;;
  cwd)                 echo "Claude Code usage — cwd=$CWD_ARG (all-time)" ;;
esac
echo "==============================================================="
printf "Prompts: %s   Tools: %s   Skills: %s   Sessions: %s   Total events: %s\n" \
  "$PROMPTS" "$TOOLS" "$SKILLS_COUNT" "$SESSIONS" "$TOTAL"
echo

# ---- skills table ----
echo "── Skills (by total time) ─────────────────────────────────────"
SKILLS_TABLE=$(echo "$DURATIONS" | awk -F'\t' '$1=="Skill" && $2!=""{
  c[$2]++; t[$2]+=$3; if($3>m[$2]) m[$2]=$3
} END {
  for (s in c) printf "%s\t%d\t%d\t%d\t%d\n", s, c[s], t[s], int(t[s]/c[s]), m[s]
}' | sort -t$'\t' -k3 -n -r)

if [ -z "$SKILLS_TABLE" ]; then
  echo "  (no skill invocations)"
else
  printf "  %-18s %5s  %10s  %10s  %10s\n" "skill" "count" "total" "avg" "max"
  while IFS=$'\t' read -r s c t a m; do
    [ -z "${s:-}" ] && continue
    printf "  %-18s %5d  %10s  %10s  %10s\n" "$s" "$c" "$(fmt_ms ${t:-0})" "$(fmt_ms ${a:-0})" "$(fmt_ms ${m:-0})"
  done <<< "$SKILLS_TABLE"
fi
echo

# ---- tools table ----
echo "── Tools (by total time) ──────────────────────────────────────"
TOOLS_TABLE=$(echo "$DURATIONS" | awk -F'\t' '$1!="Skill" && $1!=""{
  c[$1]++; t[$1]+=$3; if($3>m[$1]) m[$1]=$3
} END {
  for (s in c) printf "%s\t%d\t%d\t%d\t%d\n", s, c[s], t[s], int(t[s]/c[s]), m[s]
}' | sort -t$'\t' -k3 -n -r | head -10)

printf "  %-18s %5s  %10s  %10s  %10s\n" "tool" "count" "total" "avg" "max"
if [ -n "$TOOLS_TABLE" ]; then
  while IFS=$'\t' read -r s c t a m; do
    [ -z "${s:-}" ] && continue
    printf "  %-18s %5d  %10s  %10s  %10s\n" "$s" "$c" "$(fmt_ms ${t:-0})" "$(fmt_ms ${a:-0})" "$(fmt_ms ${m:-0})"
  done <<< "$TOOLS_TABLE"
else
  echo "  (no tool calls with paired pre/post events)"
fi
echo

# ---- cwd breakdown ----
echo "── Activity by cwd (top 5) ────────────────────────────────────"
echo "$FILTERED" | jq -r '.cwd // empty' | sort | uniq -c | sort -rn | head -5 \
  | awk '{ count=$1; $1=""; sub(/^ /,""); printf "  %5d  %s\n", count, $0 }'
