#!/bin/bash

# This script is a quick and dirty hack to get Linux in Windows and WSL. It's not meant to be a full setup.
# I just wanted to get some experience with WSL and Homebrew.
sudo apt-get upgrade -y
sudo apt-get install -y \
   build-essential \
   git \
   zsh \
   curl \
   wezterm \

# Install Homebrew

echo "--- Installing Homebrew ---"
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)" && brew doctor
echo 'export XDG_DATA_DIRS="/home/linuxbrew/.linuxbrew/share:$XDG_DATA_DIRS"' >> ~/.profile

(echo; echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"') >> /home/bwrob/.zshrc
echo $SHELL &&  sudo chsh -s $(which zsh) &&  echo $SHELL

echo 'autoload -U compinit && compinit' >> ~/.zshrc

# Install other tools
echo "--- Installing other tools ---"

brew install \
    bat \
    cmake \
    fzf \
    neovim \
    fastfetch  \
    oh-my-posh \
    tmux \
    zoxide \
    zsh-autosuggestions \
    zsh-syntax-highlighting \
    gh \
    yazi \
    uv \
    helix \
    eza \
    gemini-cli \
    lynx \
    stow \
    zellij \
    micro \

# Python tools managed by uv

uv tool install poethepoet pre-commit pytest ruff basedpyright hapless 'python-lsp-server[all]'

gh auth login

# Install Quarto and 
quarto install tinytex
quarto install chromium
quarto check
