# -- ZSH Configuration --

# -- Common Settings --
source ~/.sharedrc

# -- Performance: Cache Brew Prefix --
BREW_PREFIX=$(brew --prefix)

# -- Smart History --
setopt HIST_IGNORE_DUPS    # Don't record an entry that was just recorded.
setopt HIST_IGNORE_SPACE   # Don't record entries starting with a space.
setopt HIST_REDUCE_BLANKS  # Remove superfluous blanks from each command line being added to the history list.

# -- ZSH specific --
# Add Homebrew completion path to fpath
if [[ -d "$BREW_PREFIX/share/zsh/site-functions" ]]; then
    fpath=("$BREW_PREFIX/share/zsh/site-functions" $fpath)
fi

# -- oh-my-posh --
if command -v oh-my-posh &>/dev/null; then
    OH_MY_POSH_THEME="kali"
    eval "$(oh-my-posh init zsh --config $BREW_PREFIX/themes/$OH_MY_POSH_THEME.omp.json)"
fi

# -- Plugins (Hardcoded Paths for Speed) --
# Source brew installed plugins if they exist
[[ -f "$BREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]] && source "$BREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
[[ -f "$BREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]] && source "$BREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

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
# We will do a single compinit at the end
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
