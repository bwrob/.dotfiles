#!/bin/bash
set -euo pipefail

THEME_DIR="$HOME/.local/state/omarchy/current/theme"
ZELLIJ_THEME_TARGET="$THEME_DIR/zellij.kdl"
ZELLIJ_THEMES_DIR="$HOME/.config/zellij/themes"
ZELLIJ_THEME_SYMLINK="$ZELLIJ_THEMES_DIR/omarchy.kdl"

if [[ -f "$ZELLIJ_THEME_TARGET" ]]; then
    mkdir -p "$ZELLIJ_THEMES_DIR"
    if [[ ! -L "$ZELLIJ_THEME_SYMLINK" ]] || [[ "$(readlink "$ZELLIJ_THEME_SYMLINK")" != "$ZELLIJ_THEME_TARGET" ]]; then
        ln -sf "$ZELLIJ_THEME_TARGET" "$ZELLIJ_THEME_SYMLINK"
    fi
fi
