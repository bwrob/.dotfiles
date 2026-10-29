#!/bin/bash

THEME_NAME="${1:-}"
ALMOND_DIR="$HOME/.config/omarchy/themes/almond-blossom"
BRANDING_ABOUT="$HOME/.config/omarchy/branding/about.txt"
FASTFETCH_CFG="$HOME/.config/fastfetch/config.jsonc"

if [[ "$THEME_NAME" == "almond-blossom" ]]; then
  [[ -f "$ALMOND_DIR/about.txt" ]] && cp "$ALMOND_DIR/about.txt" "$BRANDING_ABOUT"
  if [[ -f "$ALMOND_DIR/fastfetch.jsonc" ]]; then
    mkdir -p "$(dirname "$FASTFETCH_CFG")"
    cp "$ALMOND_DIR/fastfetch.jsonc" "$FASTFETCH_CFG"
  fi
  # Ensure running foot PTYs (including redirected ones) get the updated palette
  if [[ -f "$ALMOND_DIR/colors.toml" ]]; then
    osc="$(omarchy-theme-osc "$ALMOND_DIR/colors.toml")$(printf '\033]11;[94]#111317\007')"
    for pts in /dev/pts/[0-9]*; do
      [[ -w "$pts" ]] && printf '%b' "$osc" >"$pts" 2>/dev/null || true
    done
  fi
else
  [[ -f "${OMARCHY_PATH:-/usr/share/omarchy}/icon.txt" ]] && cp "${OMARCHY_PATH:-/usr/share/omarchy}/icon.txt" "$BRANDING_ABOUT"
  rm -f "$FASTFETCH_CFG"
fi
