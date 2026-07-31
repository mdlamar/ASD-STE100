#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_NAME="ste-writing"
SKILL_SRC="$REPO_DIR/skill/$SKILL_NAME/SKILL.md"
LINT_SRC="$REPO_DIR/scripts/ste-lint.py"

CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/opencode"
SKILL_DEST_DIR="$CONFIG_DIR/skill/$SKILL_NAME"
SKILL_DEST="$SKILL_DEST_DIR/SKILL.md"
BIN_DIR="${HOME}/.local/bin"
LINT_DEST="$BIN_DIR/ste-lint"

MODE="link"

usage() {
    cat <<'EOF'
Install the ASD-STE100 anti-slop kit for opencode.

Usage:
  ./install.sh                install (symlink) the skill + linter globally
  ./install.sh --copy         install by copying instead of symlinking
  ./install.sh --uninstall    remove the skill and linter from this machine
  ./install.sh --help         show this help

Installs:
  ~/.config/opencode/skill/ste-writing/SKILL.md   (global opencode skill)
  ~/.local/bin/ste-lint                            (linter, on PATH)

The skill is on-demand: it triggers when you ask for writing that does not
sound like AI. After installing, quit and restart opencode.
EOF
}

case "${1:-}" in
    --help|-h) usage; exit 0 ;;
    --copy)    MODE="copy" ;;
    --uninstall|-u)
        rm -f "$SKILL_DEST"
        rmdir "$SKILL_DEST_DIR" 2>/dev/null || true
        rm -f "$LINT_DEST"
        echo "Removed $SKILL_DEST"
        echo "Removed $LINT_DEST"
        echo "Restart opencode to unload the skill."
        exit 0
        ;;
esac

if [[ ! -f "$SKILL_SRC" || ! -f "$LINT_SRC" ]]; then
    echo "error: source files not found in $REPO_DIR" >&2
    exit 1
fi

mkdir -p "$SKILL_DEST_DIR" "$BIN_DIR"

if [[ "$MODE" == "link" ]]; then
    ln -sfn "$SKILL_SRC" "$SKILL_DEST"
    ln -sfn "$LINT_SRC" "$LINT_DEST"
    echo "Linked:"
else
    cp "$SKILL_SRC" "$SKILL_DEST"
    cp "$LINT_SRC" "$LINT_DEST"
    chmod +x "$LINT_DEST"
    echo "Copied:"
fi

echo "  $SKILL_SRC  ->  $SKILL_DEST"
echo "  $LINT_SRC   ->  $LINT_DEST"
echo
echo "Done. Restart opencode, then ask something like:"
echo "  \"Rewrite this README so it does not sound like AI\""
echo
if [[ "$MODE" == "link" ]]; then
    echo "Note: symlinked, so a 'git pull' in $REPO_DIR updates the install."
fi
