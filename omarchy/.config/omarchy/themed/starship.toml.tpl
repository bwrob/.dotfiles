"$schema" = 'https://starship.rs/config-schema.json'

add_newline = true
command_timeout = 200

format = """
$directory\
$git_branch\
$git_commit\
$git_state\
$git_status\
$package\
$c\
$cpp\
$cmake\
$golang\
$java\
$kotlin\
$lua\
$nodejs\
$python\
$rust\
$docker_context\
$jobs\
$cmd_duration\
$line_break\
$character"""

[character]
success_symbol = "[❯](bold {{ accent }})"
error_symbol = "[✗](bold {{ red }})"

[directory]
truncation_length = 3
truncation_symbol = "…/"
style = "bold {{ accent }}"
repo_root_style = "bold {{ accent }}"
repo_root_format = "[$repo_root]($repo_root_style)[$path]($style)[$read_only]($read_only_style) "
read_only = " 󰌾"
read_only_style = "{{ red }}"

[git_branch]
symbol = " "
style = "bold {{ green }}"
format = "[$symbol$branch]($style) "

[git_commit]
tag_symbol = "  "
style = "{{ muted }}"

[git_state]
style = "{{ yellow }}"
format = "[$state( $progress_current/$progress_total)]($style) "

[git_status]
style = "{{ yellow }}"
format = "[$all_status]($style) "
ahead = "⇡${count} "
behind = "⇣${count} "
diverged = "⇕⇡${ahead_count}⇣${behind_count} "
conflicted = " "
up_to_date = " "
untracked = "? "
modified = " "
stashed = " "
staged = "+ "
renamed = "» "
deleted = "✘ "

[cmd_duration]
min_time = 2_000
style = "bold {{ muted }}"
format = "[󱎫 $duration]($style) "

[c]
symbol = " "
style = "bold {{ blue }}"
format = "[$symbol($version )]($style)"

[cpp]
symbol = " "
style = "bold {{ blue }}"
format = "[$symbol($version )]($style)"

[cmake]
symbol = " "
style = "bold {{ blue }}"
format = "[$symbol($version )]($style)"

[docker_context]
symbol = " "
style = "bold {{ cyan }}"
format = "[$symbol$context]($style) "

[golang]
symbol = " "
style = "bold {{ cyan }}"
format = "[$symbol($version )]($style)"

[java]
symbol = " "
style = "bold {{ orange }}"
format = "[$symbol($version )]($style)"

[kotlin]
symbol = " "
style = "bold {{ magenta }}"
format = "[$symbol($version )]($style)"

[lua]
symbol = " "
style = "bold {{ blue }}"
format = "[$symbol($version )]($style)"

[nodejs]
symbol = " "
style = "bold {{ green }}"
format = "[$symbol($version )]($style)"

[package]
symbol = "󰏗 "
style = "{{ muted }}"
format = "[$symbol$version]($style) "

[python]
symbol = " "
style = "bold {{ yellow }}"
format = "[$symbol($version )]($style)"

[rust]
symbol = "󱘗 "
style = "bold {{ orange }}"
format = "[$symbol($version )]($style)"

[jobs]
symbol = " "
style = "bold {{ muted }}"
format = "[$symbol$number]($style) "

[sudo]
symbol = " "
style = "bold {{ red }}"
format = "[$symbol]($style) "
