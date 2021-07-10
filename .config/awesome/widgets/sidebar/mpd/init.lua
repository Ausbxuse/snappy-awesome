local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi


local album_cover = wibox.widget {
    {
        {
            image = "/tmp/mpd_cover.jpg",
            widget = wibox.widget.imagebox
        },
        shape = function(cr, w, h)
            gears.shape.squircle(cr, w, h, 2)
        end,
        widget = wibox.container.background()
    },
    margins = dpi(4),
    widget = wibox.container.margin
}

local progress = wibox.widget {
    {
        max_value     = 100,
        value         = 6,
        forced_height = dpi(6),
        forced_width  = dpi(100),
        bar_shape     = gears.shape.rounded_bar,
        shape       = gears.shape.rounded_bar,
        color         = beautiful.fg_focus,
        background_color = "#ffffff20",
        widget        = wibox.widget.progressbar,
    },
    margins = dpi(4),
    widget = wibox.container.margin
}

local widget = wibox.widget {
    album_cover,
    progress,
    layout = wibox.layout.align.vertical
}

return widget
