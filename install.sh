#!/bin/bash
# Install/uninstall skong skills to ~/.claude/
# Usage:
#   ./install.sh           Install (symlink to ~/.claude/)
#   ./install.sh --status  Check current symlink status
#   ./install.sh --unlink  Remove symlinks (restore ~/.claude/ to empty)

set -e

SKONG_DIR="$(cd "$(dirname "$0")" && pwd)"
CLAUDE_DIR="$HOME/.claude"
FOLDERS=(skills commands)

# --- Status ---
if [ "$1" = "--status" ]; then
  echo "=== Skong Link Status ==="
  for folder in "${FOLDERS[@]}"; do
    dest="$CLAUDE_DIR/$folder"
    if [ -L "$dest" ]; then
      target=$(readlink "$dest")
      echo "✓ $folder → $target"
    elif [ -d "$dest" ]; then
      echo "✗ $folder (real directory, not linked)"
    else
      echo "- $folder (not found)"
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
  for folder in "${FOLDERS[@]}"; do
    dest="$CLAUDE_DIR/$folder"
    if [ -L "$dest" ]; then
      rm "$dest"
      echo "✓ Removed $folder"
    fi
  done
  dest="$CLAUDE_DIR/settings.json"
  if [ -L "$dest" ]; then
    rm "$dest"
    echo '{}' > "$CLAUDE_DIR/settings.json"
    echo "✓ Removed settings.json symlink, created empty settings.json"
  fi
  echo "Done. ~/.claude/ is clean."
  exit 0
fi

# --- Install ---
echo "=== Skong Skills Installer ==="
echo "Source: $SKONG_DIR/.claude"
echo "Target: $CLAUDE_DIR"
echo ""

for folder in "${FOLDERS[@]}"; do
  src="$SKONG_DIR/.claude/$folder"
  dest="$CLAUDE_DIR/$folder"

  if [ ! -d "$src" ]; then
    echo "⏭ Skip $folder (not found in source)"
    continue
  fi

  if [ -L "$dest" ]; then
    rm "$dest"
  elif [ -d "$dest" ]; then
    echo "⚠ $dest is a real directory. Back up to ${dest}.bak"
    mv "$dest" "${dest}.bak"
  fi

  ln -sf "$src" "$dest"
  echo "✓ $folder → $src"
done

# Symlink settings.json
SETTINGS_SRC="$SKONG_DIR/.claude/settings.json"
SETTINGS_DEST="$CLAUDE_DIR/settings.json"

if [ -f "$SETTINGS_SRC" ]; then
  if [ -L "$SETTINGS_DEST" ]; then
    rm "$SETTINGS_DEST"
  elif [ -f "$SETTINGS_DEST" ]; then
    echo "⚠ Backing up existing settings.json to settings.json.bak"
    mv "$SETTINGS_DEST" "${SETTINGS_DEST}.bak"
  fi
  ln -sf "$SETTINGS_SRC" "$SETTINGS_DEST"
  echo "✓ settings.json → $SETTINGS_SRC"
fi

echo ""
echo "=== Installed ==="
echo ""

# Show status
$0 --status

echo ""
echo "Commands available in all repos:"
echo "  /setup            — set up skills for a repo"
echo "  /pr 123           — full auto PR flow"
echo "  /pr 123 review    — review a PR"
echo "  /pr 123 fix       — fix review comments"
echo "  /git clean        — clean branches"
echo "  /git release      — create release"
echo "  /auto             — full dev workflow"
echo "  /learn            — reflect and improve skills"
echo ""
echo "Edit skills: $SKONG_DIR/.claude/skills/"
