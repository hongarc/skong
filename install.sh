#!/bin/bash
# Install/uninstall skong skills to ~/.claude/
# Usage:
#   ./install.sh           Install (symlink to ~/.claude/)
#   ./install.sh --status  Check current symlink status
#   ./install.sh --unlink  Remove symlinks

set -e

SKONG_DIR="$(cd "$(dirname "$0")" && pwd)"
CLAUDE_DIR="$HOME/.claude"
ITEMS=(skills commands)

# --- Status ---
if [ "$1" = "--status" ]; then
  echo "=== Skong Link Status ==="
  for item in "${ITEMS[@]}"; do
    dest="$CLAUDE_DIR/$item"
    if [ -L "$dest" ]; then
      echo "✓ $item → $(readlink "$dest")"
    elif [ -d "$dest" ]; then
      echo "✗ $item (real directory, not linked)"
    else
      echo "- $item (not found)"
    fi
  done
  dest="$CLAUDE_DIR/settings.json"
  if [ -L "$dest" ]; then
    echo "✓ settings.json → $(readlink "$dest")"
  else
    echo "✗ settings.json (not linked)"
  fi
  exit 0
fi

# --- Unlink ---
if [ "$1" = "--unlink" ]; then
  echo "=== Removing Skong Symlinks ==="
  for item in "${ITEMS[@]}"; do
    dest="$CLAUDE_DIR/$item"
    if [ -L "$dest" ]; then
      rm "$dest"
      echo "✓ Removed $item"
    fi
  done
  dest="$CLAUDE_DIR/settings.json"
  if [ -L "$dest" ]; then
    rm "$dest"
    echo '{}' > "$CLAUDE_DIR/settings.json"
    echo "✓ Removed settings.json symlink, created empty settings.json"
  fi
  echo "Done."
  exit 0
fi

# --- Install ---
echo "=== Skong Skills Installer ==="
echo "Source: $SKONG_DIR"
echo "Target: $CLAUDE_DIR"
echo ""

for item in "${ITEMS[@]}"; do
  src="$SKONG_DIR/$item"
  dest="$CLAUDE_DIR/$item"

  if [ ! -d "$src" ]; then
    echo "⏭ Skip $item (not found)"
    continue
  fi

  if [ -L "$dest" ]; then
    rm "$dest"
  elif [ -d "$dest" ]; then
    echo "⚠ $dest is a real directory. Back up to ${dest}.bak"
    mv "$dest" "${dest}.bak"
  fi

  ln -sf "$src" "$dest"
  echo "✓ $item → $src"
done

# Settings: symlink if exists, otherwise copy example
src="$SKONG_DIR/settings.json"
example="$SKONG_DIR/settings.example.json"
dest="$CLAUDE_DIR/settings.json"

if [ -f "$src" ]; then
  # User has their own settings.json — symlink it
  if [ -L "$dest" ]; then
    rm "$dest"
  elif [ -f "$dest" ]; then
    echo "⚠ Backing up settings.json to settings.json.bak"
    mv "$dest" "${dest}.bak"
  fi
  ln -sf "$src" "$dest"
  echo "✓ settings.json → $src"
elif [ -f "$example" ] && [ ! -f "$dest" ]; then
  # No personal settings — copy example as starting point
  cp "$example" "$dest"
  echo "✓ settings.json copied from settings.example.json (edit to customize)"
else
  echo "⏭ settings.json already exists, skipping"
fi

echo ""
echo "=== Installed ==="
echo ""
"$SKONG_DIR/install.sh" --status
echo ""
echo "Or install via Claude plugin:"
echo "  /plugin marketplace add hongarc/skong"
echo "  /plugin install skong@hongarc-skong"
echo ""
echo "Edit skills: $SKONG_DIR/skills/"
