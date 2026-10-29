# ~/.zshrc

eval "$(starship init zsh)"

export HISTSIZE=1000
export HISTFILE=~/.histfile
export SAVEHIST=1000
setopt HIST_IGNORE_DUPS    # Don't record an entry that was just recorded.
setopt HIST_IGNORE_SPACE   # Don't record entries starting with a space.
setopt HIST_REDUCE_BLANKS  # Remove superfluous blanks from each command line being added to the history list.
setopt autocd		

export EDITOR='micro'
export HOMEBREW_NO_ENV_HINTS=1

alias cat='bat'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias dot='cd ~/dev/.dotfiles'
alias dotstow='stow -d ~/dev/.dotfiles -t ~ -v -R common omarchy'
alias ls='eza --icons=always --group-directories-first'
alias ll='eza -l --icons=always --group-directories-first --git --time-style=long-iso'
alias la='eza -la --icons=always --group-directories-first --git'
alias lt='eza --tree --level=2 --icons=always --group-directories-first'
alias tc='textual-code .'

# -- fzf --
if command -v fzf &>/dev/null; then
    source <(fzf --zsh)

    # Dracula-inspired colors for fzf
    export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border --margin=1 --padding=1 --color=fg:#f8f8f2,bg:#282a36,hl:#bd93f9 --color=fg+:#f8f8f2,bg+:#44475a,hl+:#bd93f9 --color=info:#ffb86c,prompt:#50fa7b,pointer:#ff79c6 --color=marker:#ff79c6,spinner:#ffb86c,header:#6272a4'

    # Use fd (if available) for faster searching and to respect .gitignore
    if command -v fd &>/dev/null; then
        export FZF_DEFAULT_COMMAND='fd --type f --strip-cwd-prefix --hidden --follow --exclude .git'
        export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    fi

    # Enhanced Previews
    export FZF_CTRL_T_OPTS="--preview 'bat -n --color=always --line-range :500 {}' --preview-window=right:60%"
    export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200' --preview-window=right:60%"
fi

# -- zoxide --
command -v zoxide &>/dev/null && eval "$(zoxide init zsh)"

# -- ghcup-env --
[[ -f ~/.ghcup/env ]] && . ~/.ghcup/env
export PATH="/opt/homebrew/opt/rustup/bin:$HOME/.cargo/bin:$PATH"

# -- Tool Completions --
# Ensure the directory exists
mkdir -p ~/.zfunc

# These generate files that compinit will find
command -v uv &>/dev/null && [[ ! -f ~/.zfunc/_uv ]] && uv generate-shell-completion zsh > ~/.zfunc/_uv
command -v uvx &>/dev/null && [[ ! -f ~/.zfunc/_uvx ]] && uvx --generate-shell-completion zsh > ~/.zfunc/_uvx

fpath+=(~/.zfunc)

# -- Case-Insensitive Completion --
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*' menu select

# -- Single Consolidated compinit --
autoload -Uz compinit
compinit

# -- Aliases (Apply & Config) --
alias zsh.apply='source ~/.zshrc'
alias zsh.config='micro ~/.zshrc'
alias startx='sudo systemctl start lightdm'

if command -v fastfetch &>/dev/null; then
    FASTFETCH_CONFIG="$HOME/.config/fastfetch/config.json"
    if [[ -f "$FASTFETCH_CONFIG" ]]; then
        fastfetch -c "$FASTFETCH_CONFIG"
    else
        fastfetch
    fi
fi


# Added by Antigravity CLI installer
export PATH="/Users/bwrob/.local/bin:$PATH"

# opencode
export PATH=/Users/bwrob/.opencode/bin:$PATH

# Generated for envman. Do not edit.
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"

