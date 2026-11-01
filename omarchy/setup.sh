#!/bin/bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "--- Ensuring required packages are installed ---"
PKGS_FILE="$REPO_ROOT/omarchy/packages.txt"
if [[ -f "$PKGS_FILE" ]]; then
    mapfile -t PKGS < <(grep -vE '^\s*(#|$)' "$PKGS_FILE")
else
    PKGS=(
        bat
        benchmark
        btop
        clang
        eza
        fastfetch
        fd
        fzf
        git
        git-lfs
        github-cli
        helix
        imagemagick
        just
        lazydocker
        lazygit
        micro
        mise
        obsidian-appimage
        ollama
        omarchy-steam-fex
        snap-pac
        snapper
        starship
        steam
        stow
        tailscale
        taplo-cli
        tmux
        uv
        watchexec
        yazi
        zellij
        zoxide
    )
fi

if command -v omarchy &>/dev/null; then
    omarchy pkg add "${PKGS[@]}"
    if ! command -v zen-browser &>/dev/null; then
        echo "--- Installing Zen Browser ---"
        omarchy install browser zen || true
    fi
    omarchy default browser zen || true
elif command -v pacman &>/dev/null; then
    sudo pacman -S --needed --noconfirm "${PKGS[@]}"
fi

if command -v tailscale &>/dev/null && command -v systemctl &>/dev/null; then
    echo "--- Ensuring tailscaled service is enabled ---"
    sudo systemctl enable --now tailscaled.service 2>/dev/null || true
fi

echo "--- Stowing common & Omarchy dotfiles ---"
mkdir -p "$HOME/.config/micro/colorschemes"
stow -d "$REPO_ROOT" -t "$HOME" -v -R common omarchy

ln -sf "$HOME/.local/state/omarchy/current/theme/micro.micro" "$HOME/.config/micro/colorschemes/omarchy.micro"
ln -sf "$HOME/.local/state/omarchy/current/theme/starship.toml" "$HOME/.config/starship.toml"
ln -sf "$HOME/.local/state/omarchy/current/theme/yazi-theme.toml" "$HOME/.config/yazi/theme.toml"
mkdir -p "$HOME/.config/zellij/themes"
ln -sf "$HOME/.local/state/omarchy/current/theme/zellij.kdl" "$HOME/.config/zellij/themes/omarchy.kdl"

if command -v mise &>/dev/null; then
    echo "--- Installing mise-managed tools (rust, just, taplo) ---"
    mise install
fi

if command -v omarchy &>/dev/null; then
    echo "--- Applying Almond Blossom theme & transparency ---"
    omarchy hyprland window transparency glassy || true
    omarchy theme set "Almond Blossom"
fi

if command -v systemctl &>/dev/null; then
    echo "--- Enabling user services & theme timers ---"
    systemctl --user daemon-reload
    systemctl --user enable --now almond-theme-day.timer almond-theme-night.timer hyprsunset.service
fi

echo "--- Omarchy Setup Complete ---"
