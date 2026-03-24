#!/bin/bash
# Validate all skills in a directory
# Usage: ./validate.sh [skills-dir]
# Default: ~/.claude/skills/

SKILLS_DIR="${1:-$HOME/.claude/skills}"
ERRORS=0
WARNINGS=0

echo "=== Skill Validator ==="
echo "Scanning: $SKILLS_DIR"
echo ""

for skill_dir in "$SKILLS_DIR"/*/; do
  [ ! -d "$skill_dir" ] && continue
  name=$(basename "$skill_dir")
  skill_file="$skill_dir/SKILL.md"

  # Check SKILL.md exists
  if [ ! -f "$skill_file" ]; then
    echo "✗ $name — missing SKILL.md"
    ERRORS=$((ERRORS + 1))
    continue
  fi

  lines=$(wc -l < "$skill_file")
  has_name=$(grep -c "^name:" "$skill_file" 2>/dev/null)
  has_desc=$(grep -c "^description:" "$skill_file" 2>/dev/null)
  has_version=$(grep -c "^version:" "$skill_file" 2>/dev/null)
  has_disable=$(grep -c "disable-model-invocation:" "$skill_file" 2>/dev/null)
  refs=$(find "$skill_dir/references" -type f 2>/dev/null | wc -l | tr -d ' ')

  # Line count
  if [ "$lines" -gt 100 ]; then
    line_status="⚠ ${lines} lines (over 100)"
    WARNINGS=$((WARNINGS + 1))
  else
    line_status="${lines} lines"
  fi

  # Frontmatter checks
  issues=""
  [ "$has_name" -eq 0 ] && issues="${issues} no-name" && ERRORS=$((ERRORS + 1))
  [ "$has_desc" -eq 0 ] && issues="${issues} no-description" && ERRORS=$((ERRORS + 1))
  [ "$has_version" -eq 0 ] && issues="${issues} no-version" && ERRORS=$((ERRORS + 1))

  # disable-model-invocation is optional — skills can be always-on

  # Check referenced files exist
  while IFS= read -r ref; do
    ref_path="$skill_dir/$ref"
    if [ ! -f "$ref_path" ]; then
      issues="${issues} missing:$ref"
      ERRORS=$((ERRORS + 1))
    fi
  done < <(grep -oE 'references/[a-z0-9_-]+\.md' "$skill_file" 2>/dev/null | sort -u)

  # Check reference file line counts
  if [ -d "$skill_dir/references" ]; then
    for ref_file in "$skill_dir"/references/*.md; do
      [ ! -f "$ref_file" ] && continue
      ref_lines=$(wc -l < "$ref_file")
      if [ "$ref_lines" -gt 100 ]; then
        ref_name=$(basename "$ref_file")
        issues="${issues} $ref_name:${ref_lines}lines"
        WARNINGS=$((WARNINGS + 1))
      fi
    done
  fi

  # Output
  if [ -n "$issues" ]; then
    echo "⚠ $name — $line_status, $refs refs —$issues"
  else
    echo "✓ $name — $line_status, $refs refs"
  fi
done

echo ""
echo "=== Results: $ERRORS errors, $WARNINGS warnings ==="
[ "$ERRORS" -gt 0 ] && exit 1
exit 0
