local wezterm = require 'wezterm'
local config = wezterm.config_builder()

-- OS Detection for Shell
local function get_default_prog()
  if wezterm.target_triple:find("windows") then
    return { "pwsh.exe", "-NoLogo" }
  end
  return { "zsh", "-l" } -- Assumes zsh is in PATH for macOS/Linux
end

-- THE BASICS
config.default_prog = get_default_prog()
config.color_scheme = 'AdventureTime'
config.font = wezterm.font('JetBrains Mono')
config.font_size = 12.0
config.front_end = "WebGpu"

-- VISUALS
config.window_decorations = "RESIZE"
config.window_background_opacity = 0.95
config.macos_window_background_blur = 20
config.default_cursor_style = "BlinkingBar"
config.scrollback_lines = 10000

-- TABS & PANES
config.enable_tab_bar = true
config.hide_tab_bar_if_only_one_tab = false
config.use_fancy_tab_bar = true

-- KEYBINDINGS
config.keys = {
  -- Split Panes
  { key = 's', mods = 'ALT', action = wezterm.action.SplitVertical{ domain = 'CurrentPaneDomain' } },
  { key = 'd', mods = 'ALT', action = wezterm.action.SplitHorizontal{ domain = 'CurrentPaneDomain' } },

  -- Pane Navigation (ALT + Arrow Keys)
  { key = 'LeftArrow', mods = 'ALT', action = wezterm.action.ActivatePaneDirection 'Left' },
  { key = 'RightArrow', mods = 'ALT', action = wezterm.action.ActivatePaneDirection 'Right' },
  { key = 'UpArrow', mods = 'ALT', action = wezterm.action.ActivatePaneDirection 'Up' },
  { key = 'DownArrow', mods = 'ALT', action = wezterm.action.ActivatePaneDirection 'Down' },

  -- Tabs
  { key = 't', mods = 'ALT', action = wezterm.action.SpawnTab 'CurrentPaneDomain' },
  { key = 'w', mods = 'ALT', action = wezterm.action.CloseCurrentPane{ confirm = true } },
  { key = '[', mods = 'ALT', action = wezterm.action.ActivateTabRelative(-1) },
  { key = ']', mods = 'ALT', action = wezterm.action.ActivateTabRelative(1) },
}

return config
