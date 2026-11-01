#!/bin/bash
# Omarchy theme-set hook: sync theme to Antigravity CLI (agy)
set -euo pipefail

THEME_NAME="${1:-}"
AGY_SETTINGS="$HOME/.gemini/antigravity-cli/settings.json"

[[ -f "$AGY_SETTINGS" ]] || exit 0

# Valid agy colorScheme values:
# "terminal", "dark", "tokyo night", "solarized dark", "solarized light", "light", "colorblind-friendly dark", "colorblind-friendly light"

case "$THEME_NAME" in
  almond-blossom-mono)
    SCHEME="terminal"
    ;;
  almond-blossom)
    SCHEME="terminal"
    ;;
  tokyo-night)
    SCHEME="tokyo night"
    ;;
  solarized-light | flexoki-light | catppuccin-latte)
    SCHEME="solarized light"
    ;;
  white | *-light)
    SCHEME="light"
    ;;
  *)
    THEME_DIR="$HOME/.config/omarchy/themes/$THEME_NAME"
    [[ -d "$THEME_DIR" ]] || THEME_DIR="${OMARCHY_PATH:-/usr/share/omarchy}/themes/$THEME_NAME"
    MODE=$(omarchy-theme-color --file "$THEME_DIR/colors.toml" mode 2>/dev/null || echo "dark")
    if [[ "$MODE" == "light" ]]; then
      SCHEME="light"
    else
      SCHEME="terminal"
    fi
    ;;
esac

tmp=$(mktemp)
if jq --arg scheme "$SCHEME" '.colorScheme = $scheme' "$AGY_SETTINGS" > "$tmp"; then
  mv "$tmp" "$AGY_SETTINGS"
else
  rm -f "$tmp"
fi
