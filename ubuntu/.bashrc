#!/bin/bash
# -- Ubuntu Bash Entrypoint --
[[ $- != *i* ]] && return

if [[ -x /home/linuxbrew/.linuxbrew/bin/zsh ]]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    exec /home/linuxbrew/.linuxbrew/bin/zsh -l
elif command -v zsh &>/dev/null; then
    exec zsh -l
fi
