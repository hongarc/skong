# Install hooks for usage tracking

`~/.claude/settings.json` needs four hook entries pointing at `log-hook.sh`. The script is fast (~1ms) and never blocks Claude.

## Hooks to add

Merge these into the existing `hooks` block in `~/.claude/settings.json`:

```json
"UserPromptSubmit": [
  {
    "matcher": "*",
    "hooks": [
      { "type": "command", "command": "~/.claude/skills/usage/scripts/log-hook.sh prompt" }
    ]
  }
],
"PreToolUse": [
  {
    "matcher": "*",
    "hooks": [
      { "type": "command", "command": "~/.claude/skills/usage/scripts/log-hook.sh tool_pre" }
    ]
  }
],
"PostToolUse": [
  {
    "matcher": "*",
    "hooks": [
      { "type": "command", "command": "~/.claude/skills/usage/scripts/log-hook.sh tool_post" }
    ]
  }
],
"Stop": [
  {
    "matcher": "*",
    "hooks": [
      { "type": "command", "command": "~/.claude/skills/usage/scripts/log-hook.sh stop" }
    ]
  }
]
```

## If `hooks` already has entries for those events

Don't replace them — **append** the usage hook to the existing `"hooks": [ ... ]` array. Each event can run multiple commands; Claude executes them all.

Example combining the existing terminal-title PreToolUse with the usage hook:

```json
"PreToolUse": [
  {
    "matcher": "*",
    "hooks": [
      { "type": "command", "command": "printf '\\033]2;⚙️ claude: running...\\033\\\\' > /dev/tty" },
      { "type": "command", "command": "~/.claude/skills/usage/scripts/log-hook.sh tool_pre" }
    ]
  }
]
```

## Verify

After saving settings.json:

1. Open a new Claude Code session (settings reload on session start).
2. Run any command (e.g. `ls`).
3. Check the log:
   ```bash
   tail -n 20 ~/.claude/logs/usage.jsonl
   ```
   You should see lines like:
   ```json
   {"ts":"...","ev":"prompt","sid":"abc","cwd":"...","tool":null,"skill":null,...}
   {"ts":"...","ev":"tool_pre","sid":"abc","cwd":"...","tool":"Bash","skill":null,...}
   {"ts":"...","ev":"tool_post","sid":"abc","cwd":"...","tool":"Bash","skill":null,...}
   ```

4. Run `/usage today` to see the report.

## Privacy

The log captures:
- timestamp
- session id
- working directory
- tool name (Bash / Skill / Read / etc.)
- skill name when applicable
- character lengths of args / prompts (NOT contents)

It does **NOT** capture:
- prompt text
- tool arguments / file contents
- code edits

If you ever want to wipe history:
```bash
rm ~/.claude/logs/usage.jsonl
```

## Disable

Remove the four `log-hook.sh` lines from settings.json. Existing log file stays; you can `rm` it manually.
