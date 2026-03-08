# -- ZSH Configuration --
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt autocd

autoload -Uz compinit
compinit``

export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# --  homebrew --
# Needs to be done before sourcing oh-my-posh and others
if [[ $(uname) == "Darwin" ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
else
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

# -- rust --
# source "$HOME/.cargo/env"


# -- oh-my-posh --
OH_MY_POSH=$(brew --prefix oh-my-posh)
OH_MY_POSH_THEME="kali"
eval "$(oh-my-posh init zsh --config $OH_MY_POSH/themes/$OH_MY_POSH_THEME.omp.json)"

# -- zsh-autosuggestions --
AUTOSUGGESTIONS=$(brew --prefix zsh-autosuggestions)
source "$AUTOSUGGESTIONS/share/zsh-autosuggestions/zsh-autosuggestions.zsh"

# -- zsh-syntax-highlighting --
HIGHLIGHTING=$(brew --prefix zsh-syntax-highlighting)
source "$HIGHLIGHTING/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

# -- fzf --
source <(fzf --zsh)
export FZF_CTRL_T_OPTS="--preview 'bat -n --color=always --line-range :500 {}'"
export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200'"

# -- zoxide --
eval "$(zoxide init zsh)"

# -- Custom ZSH Aliases --
source ~/.aliases.zsh

# -- ghcup-env --
[ -f ~/.ghcup/env ] && . ~/.ghcup/env # ghcup-env

# -- Fastfetch   --
fastfetch -c ~/.fastfetch_config.json

# -- Python project executes --
if [[ -d .venv ]]; then
    source .venv/bin/activate
fi

eval "$(uv generate-shell-completion zsh)"
eval "$(uvx --generate-shell-completion zsh)"

fpath+=~/.zfunc; autoload -Uz compinit; compinit

zstyle ':completion:*' menu select


export HOMEBREW_NO_ENV_HINTS=1
export EDITOR='micro'
