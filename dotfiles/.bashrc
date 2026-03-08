#!/bin/bash

# Check if the zsh shell is available
if command -v zsh &> /dev/null; then
    exec zsh
else
    # Check if the Linuxbrew directory exists
    if [ -d "/home/linuxbrew/" ]; then
        export XDG_DATA_DIRS="/home/linuxbrew/.linuxbrew/share:$XDG_DATA_DIRS"
        # Source the Linuxbrew initialization script
        eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
        exec zsh
    fi
fi
