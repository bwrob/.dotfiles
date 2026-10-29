local active_border_color = { colors = { "rgba(f7f5f0ee)", "rgba(7eb8daee)" }, angle = 45 }
local inactive_border_color = "rgba(2b333dcc)"

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
})

-- High-contrast window opacity (93% active / 88% inactive) over deep charcoal
o.window({ tag = "transparent-window" }, { opacity = "0.93 0.88" })
