#!/bin/bash
set -euo pipefail

THEME_DIR="$HOME/.local/state/omarchy/current/theme"
YAZI_THEME_TARGET="$THEME_DIR/yazi-theme.toml"
YAZI_CFG_DIR="$HOME/.config/yazi"
YAZI_THEME_SYMLINK="$YAZI_CFG_DIR/theme.toml"

if [[ -f "$YAZI_THEME_TARGET" ]]; then
    mkdir -p "$YAZI_CFG_DIR"
    if [[ ! -L "$YAZI_THEME_SYMLINK" ]] || [[ "$(readlink "$YAZI_THEME_SYMLINK")" != "$YAZI_THEME_TARGET" ]]; then
        ln -sf "$YAZI_THEME_TARGET" "$YAZI_THEME_SYMLINK"
    fi
fi
