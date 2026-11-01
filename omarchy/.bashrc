# Omarchy environment (OMARCHY_PATH + PATH), needed even for non-interactive shells
[[ -r /usr/share/omarchy/default/bash/env-bootstrap ]] && source /usr/share/omarchy/default/bash/env-bootstrap

# If not running interactively, don't do anything else (leave this above the rc source)
[[ $- != *i* ]] && return

# All the default Omarchy aliases and functions
# (don't mess with these directly, just overwrite them here!)
source "$OMARCHY_PATH/default/bash/rc"

# ------------------------------------------------------------------------------
# 1. Dotfiles & System Management Aliases
# ------------------------------------------------------------------------------
alias dot='cd ~/dev/.dotfiles'
alias dotstow='stow -d ~/dev/.dotfiles -t ~ -v -R common omarchy'
alias bash.apply='source ~/.bashrc'
alias bash.config='micro ~/.bashrc'
alias .....='cd ../../../..'
alias tc='textual-code .'
alias hx='helix'

# ------------------------------------------------------------------------------
# 2. Editor & CLI Tooling Defaults
# ------------------------------------------------------------------------------
export EDITOR='micro'
export SUDO_EDITOR="$EDITOR"
alias cat='bat'
alias agy='agy --mode auto --dangerously-skip-permissions'

# ------------------------------------------------------------------------------
# 3. Yazi Directory Hopping Wrapper
# ------------------------------------------------------------------------------
y() {
  local tmp
  tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
  yazi "$@" --cwd-file="$tmp"
  if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
    builtin cd -- "$cwd" || return
  fi
  rm -f -- "$tmp"
}

# ------------------------------------------------------------------------------
# 4. High-Performance FZF Search & Previews (Theme-Adaptive)
# ------------------------------------------------------------------------------
if command -v fzf &>/dev/null; then
  export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border --margin=1 --padding=1'
  if command -v fd &>/dev/null; then
    export FZF_DEFAULT_COMMAND='fd --type f --strip-cwd-prefix --hidden --follow --exclude .git'
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  fi
  export FZF_CTRL_T_OPTS="--preview 'bat -n --color=always --line-range :500 {}' --preview-window=right:60%"
  export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200' --preview-window=right:60%"
fi

# ------------------------------------------------------------------------------
# 5. Developer Environments & Completions
# ------------------------------------------------------------------------------
[[ -d "$HOME/.cargo/bin" ]] && export PATH="$HOME/.cargo/bin:$PATH"
[[ -f "$HOME/.ghcup/env" ]] && source "$HOME/.ghcup/env"
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"

command -v uv &>/dev/null && eval "$(uv generate-shell-completion bash)"
command -v uvx &>/dev/null && eval "$(uvx --generate-shell-completion bash)"
export UV_PROJECT_ENVIRONMENT=".venv-omarchy"

# ------------------------------------------------------------------------------
# 6. Interactive Fastfetch Startup
# ------------------------------------------------------------------------------
if command -v fastfetch &>/dev/null; then
  if [[ -f "$HOME/.config/fastfetch/config.jsonc" ]]; then
    fastfetch -c "$HOME/.config/fastfetch/config.jsonc"
  else
    fastfetch
  fi
fi
