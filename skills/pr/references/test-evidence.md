# Test Evidence — HTML Results

## When to Apply

After running E2E/unit tests for a PR, save HTML results locally (NEVER commit to git).
Use Catppuccin Frappé theme for consistent styling.

## How to Generate

The script lives at `~/.claude/skills/pr/references/save-test-html.sh`.

```bash
# Single test file
~/.claude/skills/pr/references/save-test-html.sh \
  "e2e/modules/<module>/<test>.test.js" \
  "UP-XXXXX description" \
  "e2e/modules/<module>/test-results-UP-XXXXX.html"

# Multiple test files
~/.claude/skills/pr/references/save-test-html.sh \
  "file1.test.js file2.test.js file3.test.js" \
  "UP-XXXXX All tests" \
  "e2e/modules/<module>/test-results-UP-XXXXX.html"
```

## Catppuccin Frappé HTML Template

```html
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<title>E2E Tests — TITLE_HERE</title>
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
  .results [style*="color:green"], .results [style*="color:lime"] {
    color: #a6d189 !important;
  }
  .results [style*="color:red"] {
    color: #e78284 !important;
  }
  .results [style*="color:yellow"], .results [style*="color:olive"] {
    color: #e5c890 !important;
  }
  .results [style*="color:aqua"], .results [style*="color:teal"] {
    color: #81c8be !important;
  }
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
</style>
</head>
<body>
<div class="header">
  <h1>E2E Tests — TITLE_HERE</h1>
  <div class="meta">Generated DATE · Node VERSION · mocha</div>
</div>
<div class="results">
AHA_BODY_HERE
</div>
<div class="footer">
  <span>Catppuccin Frappé · PROJECT_NAME</span>
  <span>Local test evidence — not committed to git</span>
</div>
</body>
</html>
```

## Catppuccin Frappé Palette Reference

| Role | Color | Hex |
|------|-------|-----|
| Base (background) | Base | `#303446` |
| Results box | Mantle | `#292c3c` |
| Borders | Surface 0 | `#414559` |
| Text | Text | `#c6d0f5` |
| Dim text | Subtext 0 | `#a5adce` |
| Footer text | Overlay 0 | `#737994` |
| Title / links | Blue | `#8caaee` |
| Passing tests | Green | `#a6d189` |
| Failing tests | Red | `#e78284` |
| Warnings | Yellow | `#e5c890` |
| Info | Teal | `#81c8be` |

## Test Naming Convention

Tests in `e2e/modules/` that mock repos (no DB/HTTP) should use:
```
/**
 * Service Test: <service-name> (real import with mocked repos)
 */
describe('Service: <service-name>', function () {
```

NOT "Unit Test" or "E2E Test" — these are **service tests** that import the real service but inject mock repos.

Real E2E tests (with app boot + DB + HTTP) use:
```
/**
 * E2E Test: <endpoint>
 */
describe('E2E: POST /api/auth/2fa/verify-otp', function () {
```

## Test Quality Checklist

When writing tests for a service:
- **Cover all branches**: every `if/throw/return` path should have a test
- **Verify repo call params**: don't just check the return value — assert what was passed to each repo call (`account_id`, `is_trainer`, etc.)
- **Test pluralization**: if messages include counts (e.g. "1 attempt" vs "2 attempts"), test both singular and plural
- **Test boundary conditions**: lock expired, cooldown passed, rate limit window edge
- **Test skip paths**: what happens when optional params are missing (e.g. no `device_token`)
- **Match contract**: test assertions must match the actual service return value. If service returns `{ success: true }`, don't assert `{ token, user }`

## Rules

- **NEVER** commit HTML test results to git — local only
- Name files: `test-results-UP-<ticket>.html`
- One HTML per PR/card that has tests
- Regenerate after test changes
- User captures screenshots from these for PR evidence
