#!/bin/bash

set -e # Exit on error

echo "--- Starting Dotfiles Setup ---"

# -- OS Detection --
OS="$(uname -s)"
case "$OS" in
    Linux*)     DISTRO="Linux";;
    Darwin*)    DISTRO="macOS";;
    *)          DISTRO="UNKNOWN";;
esac

echo "Detected OS: $DISTRO"

# -- System Package Updates (Ubuntu Only) --
if [[ "$DISTRO" == "Linux" ]] && command -v apt-get &>/dev/null; then
    echo "--- Updating Ubuntu Packages ---"
    sudo apt-get update && sudo apt-get upgrade -y
    sudo apt-get install -y build-essential curl git zsh
fi

# -- Homebrew Installation --
if ! command -v brew &>/dev/null; then
    echo "--- Installing Homebrew ---"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Setup shellenv based on OS
    if [[ "$DISTRO" == "Linux" ]]; then
        eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    else
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
else
    echo "Homebrew already installed, skipping..."
fi

# -- Brew Bundle (Standardized Setup) --
echo "--- Installing Tools via Brewfile ---"
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
brew bundle --file="$REPO_ROOT/homebrew/.brewfile"

# -- Python Tools (uv) --
if command -v uv &>/dev/null; then
    echo "--- Installing Python Tools ---"
    uv tool install poethepoet pre-commit pytest ruff basedpyright hapless 'python-lsp-server[all]' --force
fi

# -- Quarto Extras (Linux Only - Cask handles macOS) --
if [[ "$DISTRO" == "Linux" ]]; then
    if command -v quarto &>/dev/null; then
        echo "--- Setting up Quarto ---"
        quarto install tinytex || true
        quarto install chromium || true
    fi
fi

# -- Shell Setup --
# Only change shell if it's not already zsh
if [[ "$SHELL" != *"zsh"* ]]; then
    echo "--- Changing Shell to Zsh ---"
    sudo chsh -s "$(which zsh)" "$USER"
fi

# Ensure Zsh config exists and source brew
ZSHRC="$HOME/.zshrc"
BREW_INIT='eval "$($(brew --prefix)/bin/brew shellenv)"'
if ! grep -q "brew shellenv" "$ZSHRC" 2>/dev/null; then
    echo "--- Adding Homebrew to $ZSHRC ---"
    echo "$BREW_INIT" >> "$ZSHRC"
fi

echo "--- Setup Complete! Please restart your terminal. ---"
