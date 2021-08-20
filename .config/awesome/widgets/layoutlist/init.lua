local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")

local ll = awful.widget.layoutlist {
  base_layout = wibox.widget {
    spacing = 10,
    forced_num_cols = 4,
    layout = wibox.layout.grid.vertical
  },
  widget_template = {
    {
      {
        id = 'icon_role',
        forced_height = 44,
        forced_width = 44,
        widget = wibox.widget.imagebox
      },
      margins = 4,
      widget = wibox.container.margin
    },
    id = 'background_role',
    forced_width = 48,
    forced_height = 48,
    widget = wibox.container.background
  }
}

local layout_popup = awful.popup {
  widget = wibox.widget {},
  border_color = beautiful.border_color,
  border_width = beautiful.border_width,
  placement = awful.placement.centered,
  ontop = true,
  visible = false,
  type = "dock"
}

layout_popup.bg = beautiful.transparent

layout_popup:setup{
  widget = wibox.container.background,
  shape = gears.shape.rounded_rect,
  bg = {
    type = "linear",
    from = {0, 0},
    to = {0, 48},
    stops = {{0, "#1daed4"}, {0.5, "#6f86c9"}, {1, "#e379d8"}}
  },
  {ll, margins = 4, widget = wibox.container.margin}
}

-- Make sure you remove the default Mod4+Space and Mod4+Shift+Space
-- keybindings before adding this.
awful.keygrabber {
  start_callback = function() layout_popup.visible = true end,
  stop_callback = function() layout_popup.visible = false end,
  export_keybindings = true,
  stop_event = 'release',
  stop_key = {'Escape', 'Super_L', 'Super_R'},
  keybindings = {
    {{"Mod4"}, ' ', function() awful.layout.inc(1) end},
    {{"Mod4", 'Shift'}, ' ', function() awful.layout.inc(-1) end}
  }
}
