#!/bin/bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "--- Setting up macOS Dotfiles ---"

if ! command -v brew &>/dev/null; then
    echo "--- Installing Homebrew ---"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

echo "--- Installing Homebrew bundle ---"
brew bundle --file="$REPO_ROOT/macos/.brewfile"

if command -v uv &>/dev/null; then
    echo "--- Installing Python CLI tools via uv ---"
    uv tool install poethepoet pre-commit pytest ruff basedpyright hapless 'python-lsp-server[all]' --force
fi

echo "--- Stowing common & macOS dotfiles ---"
mkdir -p "$HOME/.config" "$HOME/Library/Application Support/Code/User"
stow -d "$REPO_ROOT" -t "$HOME" -v -R common macos

for f in settings.json extensions.json launch.json; do
    ln -sf "$REPO_ROOT/common/.config/Code/User/$f" "$HOME/Library/Application Support/Code/User/$f"
done

echo "--- macOS Setup Complete ---"
