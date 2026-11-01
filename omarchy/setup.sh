#!/bin/bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "--- Ensuring required packages are installed ---"
PKGS=(
    bat
    btop
    eza
    fastfetch
    fd
    fzf
    git
    git-lfs
    github-cli
    helix
    imagemagick
    lazygit
    micro
    starship
    stow
    tmux
    uv
    yazi
    zellij
    zoxide
)

if command -v omarchy &>/dev/null; then
    omarchy pkg add "${PKGS[@]}"
elif command -v pacman &>/dev/null; then
    sudo pacman -S --needed --noconfirm "${PKGS[@]}"
fi

echo "--- Stowing common & Omarchy dotfiles ---"
mkdir -p "$HOME/.config/micro/colorschemes"
stow -d "$REPO_ROOT" -t "$HOME" -v -R common omarchy

ln -sf "$HOME/.local/state/omarchy/current/theme/micro.micro" "$HOME/.config/micro/colorschemes/omarchy.micro"
ln -sf "$HOME/.local/state/omarchy/current/theme/starship.toml" "$HOME/.config/starship.toml"
ln -sf "$HOME/.local/state/omarchy/current/theme/yazi-theme.toml" "$HOME/.config/yazi/theme.toml"
mkdir -p "$HOME/.config/zellij/themes"
ln -sf "$HOME/.local/state/omarchy/current/theme/zellij.kdl" "$HOME/.config/zellij/themes/omarchy.kdl"

if command -v omarchy &>/dev/null; then
    echo "--- Applying Almond Blossom theme ---"
    omarchy hyprland window transparency transparent || true
    omarchy theme set "Almond Blossom"
fi

echo "--- Omarchy Setup Complete ---"
