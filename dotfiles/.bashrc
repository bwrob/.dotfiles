#!/bin/bash

# -- Cross-Platform Configuration --

# Detect Windows/Git Bash
if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" ]]; then
    [[ -f ~/.gitbashrc ]] && source ~/.gitbashrc
    return
fi

# -- Linux/macOS --

# 1. Try to switch to Zsh if available
if command -v zsh &>/dev/null; then
    exec zsh
elif [[ -x /opt/homebrew/bin/zsh ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
    exec zsh
elif [[ -x /home/linuxbrew/.linuxbrew/bin/zsh ]]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    exec zsh
fi

# 2. Fallback to Bash
# This only runs if Zsh was not found or couldn't be executed
[[ -f ~/.sharedrc ]] && source ~/.sharedrc
