# -- Aliases --

# better file view
alias cat='bat'

# better cd
alias dir.all="eza -l --group-directories-first --no-filesize --icons=always --no-time --no-user --git-ignore --all"
alias dir.git="eza -l --group-directories-first --no-filesize --icons=always --no-time --no-user --git "
alias dir.tree="eza -l --group-directories-first --no-filesize --icons=always --no-time --no-user --git-ignore --tree --level 2"
alias dir="eza -l --group-directories-first --no-filesize --icons=always --no-time --no-user --git-ignore"

# zsh settings
alias zsh.apply='source ~/.zshrc'
alias zsh.config='micro ~/.zshrc'

# startx
alias startx='sudo systemctl start lightdm'
