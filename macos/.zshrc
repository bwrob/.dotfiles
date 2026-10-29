# -- macOS Zsh Configuration --

BREW_PREFIX="/opt/homebrew"
eval "$($BREW_PREFIX/bin/brew shellenv zsh)"

# -- History & Shell Options --
export HISTSIZE=10000
export HISTFILE="$HOME/.histfile"
export SAVEHIST=10000
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS
setopt autocd

# -- Environment & Path --
export EDITOR="micro"
export HOMEBREW_NO_ENV_HINTS=1
export PATH="$HOME/.local/bin:$HOME/.opencode/bin:$BREW_PREFIX/opt/rustup/bin:$HOME/.cargo/bin:$PATH"
[[ -f "$HOME/.ghcup/env" ]] && source "$HOME/.ghcup/env"
[[ -s "$HOME/.config/envman/load.sh" ]] && source "$HOME/.config/envman/load.sh"

# -- Completions & Plugins --
mkdir -p "$HOME/.zfunc"
fpath=("$HOME/.zfunc" "$BREW_PREFIX/share/zsh/site-functions" $fpath)

command -v uv &>/dev/null && [[ ! -f "$HOME/.zfunc/_uv" ]] && uv generate-shell-completion zsh > "$HOME/.zfunc/_uv"
command -v uvx &>/dev/null && [[ ! -f "$HOME/.zfunc/_uvx" ]] && uvx --generate-shell-completion zsh > "$HOME/.zfunc/_uvx"

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*' menu select
autoload -Uz compinit && compinit

[[ -f "$BREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]] && source "$BREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
[[ -f "$BREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]] && source "$BREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

# -- Prompt & Navigation --
command -v starship &>/dev/null && eval "$(starship init zsh)"
command -v zoxide &>/dev/null && eval "$(zoxide init zsh)"

if command -v fzf &>/dev/null; then
    source <(fzf --zsh)
    export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border --margin=1 --padding=1 --color=fg:#f8f8f2,bg:#282a36,hl:#bd93f9 --color=fg+:#f8f8f2,bg+:#44475a,hl+:#bd93f9 --color=info:#ffb86c,prompt:#50fa7b,pointer:#ff79c6 --color=marker:#ff79c6,spinner:#ffb86c,header:#6272a4'
    if command -v fd &>/dev/null; then
        export FZF_DEFAULT_COMMAND='fd --type f --strip-cwd-prefix --hidden --follow --exclude .git'
        export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    fi
    export FZF_CTRL_T_OPTS="--preview 'bat -n --color=always --line-range :500 {}' --preview-window=right:60%"
    export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200' --preview-window=right:60%"
fi

# -- Aliases --
alias cat='bat'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias j='z'
alias ji='zi'
alias dot='cd ~/.dotfiles'
alias bundle='brew bundle --upgrade --file=~/.brewfile'
alias dotstow='stow -d ~/.dotfiles -t ~ -v -R common macos'
alias zsh.apply='source ~/.zshrc'
alias zsh.config='micro ~/.zshrc'
alias tc='textual-code .'

alias ls='eza --icons=always --group-directories-first'
alias ll='eza -l --icons=always --group-directories-first --git --time-style=long-iso'
alias la='eza -la --icons=always --group-directories-first --git'
alias lt='eza --tree --level=2 --icons=always --group-directories-first'
alias l.='eza -d .* --icons=always'

if command -v fastfetch &>/dev/null; then
    [[ -f "$HOME/.config/fastfetch/config.json" ]] && fastfetch -c "$HOME/.config/fastfetch/config.json" || fastfetch
fi
