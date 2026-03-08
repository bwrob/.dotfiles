local wezterm = require 'wezterm'
local config = wezterm.config_builder()

-- THE BASICS
config.default_prog = { '/usr/bin/zsh', '-l' }
config.color_scheme = 'AdventureTime' -- Ghostty-like feel
config.font = wezterm.font('JetBrains Mono')
config.font_size = 12.0

-- TABS & PANES (NO TMUX NEEDED)
config.enable_tab_bar = true
config.hide_tab_bar_if_only_one_tab = false -- Set to true if you want it hidden when single
config.use_fancy_tab_bar = true

-- KEYBINDINGS (Better than defaults)
config.keys = {
  -- Split Panes using ALT + S (Vertical) and ALT + D (Horizontal)
  { key = 's', mods = 'ALT', action = wezterm.action.SplitVertical{ domain = 'CurrentPaneDomain' } },
  { key = 'd', mods = 'ALT', action = wezterm.action.SplitHorizontal{ domain = 'CurrentPaneDomain' } },

  -- Create New Tab with ALT + T
  { key = 't', mods = 'ALT', action = wezterm.action.SpawnTab 'CurrentPaneDomain' },

  -- Close Current Pane with ALT + W
  { key = 'w', mods = 'ALT', action = wezterm.action.CloseCurrentPane{ confirm = true } },
}

return config
