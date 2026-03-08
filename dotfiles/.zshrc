# -- ZSH Configuration --

# -- Common Settings --
source ~/.sharedrc

# -- ZSH specific --
autoload -Uz compinit
compinit

# -- oh-my-posh (Zsh specific) --
if command -v oh-my-posh &>/dev/null; then
    OH_MY_POSH_THEME="kali"
    eval "$(oh-my-posh init zsh --config $(brew --prefix oh-my-posh)/themes/$OH_MY_POSH_THEME.omp.json)"
fi

# -- Plugins --
# Source brew installed plugins if they exist
AUTOSUGGESTIONS="$(brew --prefix zsh-autosuggestions 2>/dev/null)"
[[ -n "$AUTOSUGGESTIONS" ]] && source "$AUTOSUGGESTIONS/share/zsh-autosuggestions/zsh-autosuggestions.zsh"

HIGHLIGHTING="$(brew --prefix zsh-syntax-highlighting 2>/dev/null)"
[[ -n "$HIGHLIGHTING" ]] && source "$HIGHLIGHTING/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

# -- fzf --
if command -v fzf &>/dev/null; then
    source <(fzf --zsh)
    export FZF_CTRL_T_OPTS="--preview 'bat -n --color=always --line-range :500 {}'"
    export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200'"
fi

# -- zoxide --
command -v zoxide &>/dev/null && eval "$(zoxide init zsh)"

# -- ghcup-env --
[[ -f ~/.ghcup/env ]] && . ~/.ghcup/env

# -- Tool Completions --
command -v uv &>/dev/null && eval "$(uv generate-shell-completion zsh)"
command -v uvx &>/dev/null && eval "$(uvx --generate-shell-completion zsh)"

fpath+=~/.zfunc; autoload -Uz compinit; compinit
zstyle ':completion:*' menu select

# -- Aliases (Apply & Config) --
alias zsh.apply='source ~/.zshrc'
alias zsh.config='micro ~/.zshrc'
alias startx='sudo systemctl start lightdm'
