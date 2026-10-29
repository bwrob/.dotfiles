# Omarchy environment (OMARCHY_PATH + PATH), needed even for non-interactive shells
[[ -r /usr/share/omarchy/default/bash/env-bootstrap ]] && source /usr/share/omarchy/default/bash/env-bootstrap

# If not running interactively, don't do anything else (leave this above the rc source)
[[ $- != *i* ]] && return

# All the default Omarchy aliases and functions
# (don't mess with these directly, just overwrite them here!)
source "$OMARCHY_PATH/default/bash/rc"

# Add your own exports, aliases, and functions here.

# Shell options (from .zshrc)
shopt -s autocd

# Default editor
export EDITOR='micro'
export SUDO_EDITOR="$EDITOR"

# Aliases
alias cat='bat'
alias .....='cd ../../../..'
alias dot='cd ~/dev/.dotfiles'
alias ll='eza -l --icons=always --group-directories-first --git --time-style=long-iso'
alias la='eza -la --icons=always --group-directories-first --git'
alias l.='eza -d .* --icons=always'
alias dir='eza -l --group-directories-first --no-filesize --icons=always --no-time --no-user --git-ignore'
alias dir.all='eza -l --group-directories-first --no-filesize --icons=always --no-time --no-user --git-ignore --all'
alias dir.git='eza -l --group-directories-first --no-filesize --icons=always --no-time --no-user --git'
alias dir.tree='eza -l --group-directories-first --no-filesize --icons=always --no-time --no-user --git-ignore --tree --level 2'
alias tc='textual-code .'
alias hx='helix'
alias bash.apply='source ~/.bashrc'
alias bash.config='micro ~/.bashrc'

if command -v zoxide &>/dev/null; then
  alias j='z'
  alias ji='zi'
fi

# Yazi wrapper: press 'q' to cd into the last directory on exit, 'Q' to stay put
y() {
  local tmp
  tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
  yazi "$@" --cwd-file="$tmp"
  if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
    builtin cd -- "$cwd" || return
  fi
  rm -f -- "$tmp"
}

# fzf options, fd search, and previews
if command -v fzf &>/dev/null; then
  export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border --margin=1 --padding=1 --color=fg:#f8f8f2,bg:#282a36,hl:#bd93f9 --color=fg+:#f8f8f2,bg+:#44475a,hl+:#bd93f9 --color=info:#ffb86c,prompt:#50fa7b,pointer:#ff79c6 --color=marker:#ff79c6,spinner:#ffb86c,header:#6272a4'

  if command -v fd &>/dev/null; then
    export FZF_DEFAULT_COMMAND='fd --type f --strip-cwd-prefix --hidden --follow --exclude .git'
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  fi

  export FZF_CTRL_T_OPTS="--preview 'bat -n --color=always --line-range :500 {}' --preview-window=right:60%"
  export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200' --preview-window=right:60%"
fi

# Language / tool environments
[[ -f ~/.ghcup/env ]] && source ~/.ghcup/env
[[ -d "$HOME/.cargo/bin" ]] && export PATH="$HOME/.cargo/bin:$PATH"
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"

# uv / uvx Bash completions
command -v uv &>/dev/null && eval "$(uv generate-shell-completion bash)"
command -v uvx &>/dev/null && eval "$(uvx --generate-shell-completion bash)"
export UV_PROJECT_ENVIRONMENT=".venv-omarchy"

# Run fastfetch on interactive shell startup
if command -v fastfetch &>/dev/null; then
  if [[ -f "$HOME/.config/fastfetch/config.jsonc" ]]; then
    fastfetch -c "$HOME/.config/fastfetch/config.jsonc"
  elif [[ -f "$HOME/.config/fastfetch/config.json" ]]; then
    fastfetch -c "$HOME/.config/fastfetch/config.json"
  else
    fastfetch
  fi
fi
