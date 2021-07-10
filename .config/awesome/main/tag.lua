-- Table of layouts to cover with awful.layout.inc, order matters.
local awful = require("awful")
local gears = require("gears")
local machi = require("widgets.layout-machi")
require("beautiful").layout_machi = machi.get_icon()

tag.connect_signal("request::default_layouts", function()
  awful.layout.append_default_layouts({
    awful.layout.suit.tile, awful.layout.suit.floating, machi.default_layout,
    awful.layout.suit.tile.left, awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top, awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal, awful.layout.suit.spiral,
    awful.layout.suit.spiral.dwindle, awful.layout.suit.max,
    awful.layout.suit.max.fullscreen, awful.layout.suit.magnifier,
    awful.layout.suit.corner.nw
  })
end)

tag.connect_signal("property::selected", function(t)
    for _, c in ipairs(t:clients()) do
        c.prev_content = gears.surface.duplicate_surface(c.content)
    end
end)
