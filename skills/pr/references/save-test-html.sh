#!/bin/bash
# Usage: ./save-test-html.sh <test-file-or-glob> <title> <output-file>
# Example: ./save-test-html.sh "e2e/modules/two-factor-auth/check-and-trigger-2fa/*.test.js" "UP-68776" "test-results-UP-68776.html"

TEST_FILES="$1"
TITLE="$2"
OUTPUT="$3"

if [ -z "$TEST_FILES" ] || [ -z "$TITLE" ] || [ -z "$OUTPUT" ]; then
  echo "Usage: $0 <test-files> <title> <output-file>"
  exit 1
fi

# Run tests, capture raw ANSI output
RAW=$(npx mocha $TEST_FILES --timeout=15000 --exit --color 2>&1)

# Convert ANSI to HTML body
BODY=$(echo "$RAW" | aha --no-header)

# Wrap in Catppuccin Frappé themed HTML
cat > "$OUTPUT" << 'HEADER'
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
HEADER

echo "<title>E2E Tests — $TITLE</title>" >> "$OUTPUT"

cat >> "$OUTPUT" << 'STYLE'
<style>
  * { margin: 0; padding: 0; box-sizing: border-box; }
  body {
    background: #303446;
    color: #c6d0f5;
    font-family: 'Menlo', 'Monaco', 'Cascadia Code', 'Fira Code', 'Consolas', monospace;
    font-size: 13px;
    line-height: 1.7;
    padding: 32px 40px;
    min-height: 100vh;
  }
  .header {
    border-bottom: 1px solid #414559;
    padding-bottom: 16px;
    margin-bottom: 24px;
  }
  .header h1 {
    font-size: 16px;
    font-weight: 600;
    color: #8caaee;
    margin-bottom: 4px;
  }
  .header .meta {
    font-size: 11px;
    color: #a5adce;
  }
  .results {
    background: #292c3c;
    border: 1px solid #414559;
    border-radius: 8px;
    padding: 24px 28px;
    overflow-x: auto;
    white-space: pre-wrap;
    word-wrap: break-word;
  }
  /* Catppuccin Frappé overrides for ANSI colors */
  .results .bold { font-weight: 600; }
  /* Green (passing) */
  .results [style*="color:green"], .results [style*="color:lime"] {
    color: #a6d189 !important;
  }
  /* Red (failing) */
  .results [style*="color:red"] {
    color: #e78284 !important;
  }
  /* Yellow */
  .results [style*="color:yellow"], .results [style*="color:olive"] {
    color: #e5c890 !important;
  }
  /* Cyan */
  .results [style*="color:aqua"], .results [style*="color:teal"] {
    color: #81c8be !important;
  }
  /* Dim / gray text */
  .results [style*="color:gray"], .results [style*="color:dimgray"] {
    color: #a5adce !important;
  }
  .footer {
    margin-top: 24px;
    padding-top: 16px;
    border-top: 1px solid #414559;
    font-size: 11px;
    color: #737994;
    display: flex;
    justify-content: space-between;
  }
  .badge {
    display: inline-block;
    padding: 2px 8px;
    border-radius: 4px;
    font-size: 11px;
    font-weight: 600;
  }
  .badge-pass { background: rgba(166,209,137,0.15); color: #a6d189; }
  .badge-fail { background: rgba(231,130,132,0.15); color: #e78284; }
</style>
</head>
<body>
<div class="header">
STYLE

echo "  <h1>E2E Tests — $TITLE</h1>" >> "$OUTPUT"
echo "  <div class=\"meta\">Generated $(date '+%Y-%m-%d %H:%M:%S') · Node $(node -v) · mocha</div>" >> "$OUTPUT"

cat >> "$OUTPUT" << 'MID'
</div>
<div class="results">
MID

echo "$BODY" >> "$OUTPUT"

cat >> "$OUTPUT" << 'FOOTER'
</div>
<div class="footer">
  <span>Catppuccin Frappé · Everfit API</span>
  <span>Local test evidence — not committed to git</span>
</div>
</body>
</html>
FOOTER

echo "✓ Saved: $OUTPUT"
