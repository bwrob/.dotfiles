#!/bin/bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "--- Setting up Windows WSL (Ubuntu) Dotfiles ---"

sudo apt-get update && sudo apt-get upgrade -y
sudo apt-get install -y build-essential curl git zsh wslu

if ! command -v brew &>/dev/null; then
    echo "--- Installing Linuxbrew ---"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

echo "--- Installing Homebrew bundle ---"
brew bundle --file="$REPO_ROOT/win-wsl/.brewfile"

if command -v uv &>/dev/null; then
    echo "--- Installing Python CLI tools via uv ---"
    uv tool install poethepoet pre-commit pytest ruff basedpyright hapless 'python-lsp-server[all]' --force
fi

echo "--- Stowing common & WSL dotfiles ---"
mkdir -p "$HOME/.config"
stow -d "$REPO_ROOT" -t "$HOME" -v -R common win-wsl

# Sync Windows-side host configs (WezTerm, VS Code, Git Bash) if /mnt/c/Users/<user> is accessible
if command -v cmd.exe &>/dev/null; then
    WIN_USER="$(cmd.exe /c "echo %USERNAME%" 2>/dev/null | tr -d '\r')"
    WIN_HOME="/mnt/c/Users/$WIN_USER"
    if [[ -d "$WIN_HOME" ]]; then
        echo "--- Syncing Windows host configs to $WIN_HOME ---"
        mkdir -p "$WIN_HOME/.config/wezterm" "$WIN_HOME/AppData/Roaming/Code/User"
        cp "$REPO_ROOT/win-wsl/windows/wezterm.lua" "$WIN_HOME/.config/wezterm/wezterm.lua"
        cp "$REPO_ROOT/win-wsl/windows/.gitbashrc" "$WIN_HOME/.gitbashrc"
        cp "$REPO_ROOT/common/.config/Code/User/"{settings.json,extensions.json,launch.json} "$WIN_HOME/AppData/Roaming/Code/User/"
    fi
fi

if [[ "$SHELL" != *"zsh"* ]]; then
    sudo chsh -s "$(command -v zsh)" "$USER"
fi

echo "--- WSL Setup Complete ---"
