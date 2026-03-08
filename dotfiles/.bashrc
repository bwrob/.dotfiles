#!/bin/bash

# -- Cross-Platform Configuration --

# Detect Windows/Git Bash
if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" ]]; then
    if [[ -f ~/.gitbashrc ]]; then
        source ~/.gitbashrc
    fi
    return
fi

# -- Linux/macOS --

# Ensure common environment (including Homebrew) is available
source ~/.sharedrc

# Check if the zsh shell is available and we aren't already in zsh
if [[ -z "$ZSH_VERSION" ]] && command -v zsh &> /dev/null; then
    exec zsh
fi

# Fallback to Bash (if Zsh is not available)
# (sharedrc is already sourced above)
