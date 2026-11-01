local active_border_color = { colors = { "rgba(ffffffee)", "rgba(c89b6dee)" }, angle = 45 }
local inactive_border_color = "rgb(1a1715)"

hl.config({
  general = {
    col = {
      active_border = active_border_color,
      inactive_border = inactive_border_color,
    },
  },

  group = {
    col = {
      border_active = active_border_color,
      border_inactive = inactive_border_color,
    },
  },

  decoration = {
    rounding = 6,
    rounding_power = 3,
  },
})

-- High-contrast window opacity (94% active / 89% inactive) over deep warm charcoal
o.window({ tag = "transparent-window" }, { opacity = "0.94 0.89" })
