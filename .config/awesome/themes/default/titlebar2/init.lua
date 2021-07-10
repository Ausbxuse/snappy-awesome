local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
  local top_titlebar = awful.titlebar(c, {size = beautiful.titlebar_height})
  -- buttons for the titlebar
  local buttons = gears.table.join(awful.button({}, 1, function()
    client.focus = c
    c:raise()
    awful.mouse.client.move(c)
  end), awful.button({}, 3, function()
    client.focus = c
    c:raise()
    awful.mouse.client.resize(c)
  end))

  top_titlebar:setup{
    {
      awful.titlebar.widget.maximizedbutton(c),
      awful.titlebar.widget.minimizebutton(c),
      awful.titlebar.widget.closebutton(c),
      layout = wibox.layout.fixed.horizontal()
    },
    { -- Middle
      { -- Title
        align = "center",
        widget = awful.titlebar.widget.titlewidget(c)
      },
      buttons = buttons,
      layout = wibox.layout.flex.horizontal
    },
    nil,
    layout = wibox.layout.align.horizontal
  }
end)
