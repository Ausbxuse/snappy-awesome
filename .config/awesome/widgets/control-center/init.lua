local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local cairo = require("lgi").cairo

local control_center = wibox({visible = false, ontop = true, type = "dock", screen = screen.primary})
control_center.bg = "#00000000" -- For anti aliasing
control_center.fg = beautiful.control_center_fg or beautiful.wibar_fg or "#FFFFFF"
control_center.opacity = beautiful.control_center_opacity or 1
control_center.height = screen.primary.geometry.height
control_center.width = beautiful.control_center_width or dpi(250)
control_center.y = beautiful.control_center_y or 0

awful.placement.top_right(control_center)

awful.placement.maximize_vertically(control_center, { honor_workarea = true, margins = { top = beautiful.useless_gap * 2 } })

control_center:buttons(gears.table.join(
    -- Middle click - Hide control_center
    awful.button({ }, 2, function ()
        control_center.visible = false
    end)
))


local radius = dpi(5)
local surface = cairo.ImageSurface(cairo.Format.ARGB32,10,10)
local cr = cairo.Context(surface)
cr:set_source(gears.color("#00ffff"))
cr:paint()
cr:set_source(gears.color("#ff0000"))

-- cr:new_sub_path()
--cr:move_to(0,0)
-- cr:arc(radius, radius, radius, 3*(math.pi/2), math.pi*2)
cr:rectangle(0, 0, 10, 10)
cr:rectangle(10, 10, 10, 10)

cr:close_path()

local cal = wibox.widget {
    date         = os.date('*t'),
    font         = 'Monospace 8',
    spacing      = 2,
    week_numbers = false,
    start_sunday = false,
    widget       = wibox.widget.calendar.month
}

local test = wibox.widget.imagebox(surface)

local lyt = wibox.layout.fixed.vertical(
  {
    {
      widget = test
    },
    shape = function(cr, w, h)
      gears.shape.rounded_rect(cr, w, h, dpi(12))
    end,
    bg = beautiful.red,
    widget = wibox.container.background
  },
  {
    {
      widget = cal
    },
    shape = function(cr, w, h)
      gears.shape.rounded_rect(cr, w, h, dpi(12))
    end,
    bg = beautiful.yellow,
    widget = wibox.container.background
  },
  {
    {
      widget = cal,
    },
    shape = function(cr, w, h)
      gears.shape.rounded_rect(cr, w, h, dpi(12))
    end,
    bg = beautiful.blue,
    widget = wibox.container.background
  }
)

control_center:setup {
  {
    {
      layout = lyt,
    },
    top = dpi(20),
    left = dpi(20),
    right = dpi(20),
    widget = wibox.container.margin
  },
  shape = function(cr, w, h)
    gears.shape.partially_rounded_rect(cr, w, h, true, false, false, false, dpi(20))
  end,
  bg = beautiful.bg_default,
  widget = wibox.container.background
}

awesome.connect_signal("widgets::control_center", function()
  local all_clients = client.get()
  -- local icon = awful.widget.clienticon(c)
  lyt:set(1, require("widgets.newtasklist")(all_clients))
  control_center.visible = not control_center.visible
end)

control_center.visible = true
