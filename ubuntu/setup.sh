#!/bin/bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "--- Setting up Ubuntu Dotfiles ---"

sudo apt-get update && sudo apt-get upgrade -y
sudo apt-get install -y build-essential curl git zsh

if ! command -v brew &>/dev/null; then
    echo "--- Installing Linuxbrew ---"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

echo "--- Installing Homebrew bundle ---"
brew bundle --file="$REPO_ROOT/ubuntu/.brewfile"

if command -v uv &>/dev/null; then
    echo "--- Installing Python CLI tools via uv ---"
    uv tool install poethepoet pre-commit pytest ruff basedpyright hapless 'python-lsp-server[all]' --force
fi

echo "--- Stowing common & Ubuntu dotfiles ---"
mkdir -p "$HOME/.config/Code/User"
stow -d "$REPO_ROOT" -t "$HOME" -v -R common ubuntu

if [[ "$SHELL" != *"zsh"* ]]; then
    sudo chsh -s "$(command -v zsh)" "$USER"
fi

echo "--- Ubuntu Setup Complete ---"
