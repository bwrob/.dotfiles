#!/bin/bash

THEME_NAME="${1:-}"
BRANDING_ABOUT="$HOME/.config/omarchy/branding/about.txt"
FASTFETCH_CFG="$HOME/.config/fastfetch/config.jsonc"

if [[ "$THEME_NAME" == "almond-blossom" || "$THEME_NAME" == "almond-blossom-mono" ]]; then
  THEME_DIR="$HOME/.config/omarchy/themes/$THEME_NAME"
  mkdir -p "$(dirname "$BRANDING_ABOUT")"
  [[ -f "${OMARCHY_PATH:-/usr/share/omarchy}/icon.txt" ]] && cp "${OMARCHY_PATH:-/usr/share/omarchy}/icon.txt" "$BRANDING_ABOUT"
  if [[ -f "$THEME_DIR/fastfetch.jsonc" ]]; then
    mkdir -p "$(dirname "$FASTFETCH_CFG")"
    cp "$THEME_DIR/fastfetch.jsonc" "$FASTFETCH_CFG"
  fi
  # Ensure running foot PTYs (including redirected ones) get the updated palette
  if [[ -f "$THEME_DIR/colors.toml" ]]; then
    bg_color="$(omarchy-theme-color --file "$THEME_DIR/colors.toml" background 2>/dev/null || echo "#12100e")"
    osc="$(omarchy-theme-osc "$THEME_DIR/colors.toml")$(printf '\033]11;[94]%s\007' "$bg_color")"
    for pts in /dev/pts/[0-9]*; do
      [[ -w "$pts" ]] && printf '%b' "$osc" >"$pts" 2>/dev/null || true
    done
  fi
else
  [[ -f "${OMARCHY_PATH:-/usr/share/omarchy}/icon.txt" ]] && cp "${OMARCHY_PATH:-/usr/share/omarchy}/icon.txt" "$BRANDING_ABOUT"
  rm -f "$FASTFETCH_CFG"
fi
