#!/bin/bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "--- Stowing common & Omarchy dotfiles ---"
mkdir -p "$HOME/.config"
stow -d "$REPO_ROOT" -t "$HOME" -v -R common omarchy

if command -v omarchy &>/dev/null; then
    echo "--- Applying Almond Blossom theme ---"
    omarchy hyprland window transparency transparent || true
    omarchy theme set "Almond Blossom"
fi

echo "--- Omarchy Setup Complete ---"
