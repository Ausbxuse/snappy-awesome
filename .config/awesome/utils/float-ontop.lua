local awful = require("awful")
local gears = require("gears")
client.connect_signal("manage", function(c)
  local layout_is_floating = (awful.layout.get(mouse.screen) ==
                               awful.layout.suit.floating)
  if layout_is_floating then
    c.ontop = false
  elseif c.floating then
    c.above = true
    c:raise()
  end

  c.shape_clip = function(cr, w, h) gears.shape.rounded_rect(cr, w, h, 12) end
  c.client_shape_clip = gears.shape.rounded_rect
end)

