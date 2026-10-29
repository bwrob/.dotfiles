#!/bin/bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "--- Stowing common & Omarchy dotfiles ---"
mkdir -p "$HOME/.config/micro/colorschemes"
stow -d "$REPO_ROOT" -t "$HOME" -v -R common omarchy

ln -sf "$HOME/.local/state/omarchy/current/theme/micro.micro" "$HOME/.config/micro/colorschemes/omarchy.micro"

if command -v omarchy &>/dev/null; then
    echo "--- Applying Almond Blossom theme ---"
    omarchy hyprland window transparency transparent || true
    omarchy theme set "Almond Blossom"
fi

echo "--- Omarchy Setup Complete ---"
