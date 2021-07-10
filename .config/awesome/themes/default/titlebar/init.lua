local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

-- Add a titlebar if titlebars_enabled is set to true in the rules.
--
local border_width = dpi(4/1.645)
beautiful.border_width = dpi(0)
local color_normal = "#56666f"
client.connect_signal("request::geometry", function(c)
    awful.titlebar(c, {
        position = "left",
        -- size = beautiful.titlebar_height * (3 / 5),
        size = border_width,
        bg_focus = {type = "linear", from = {0,0}, to = {0, c.height}, stops = {{0, "#1daed4"},{0.5, "#6f86c9"},{1, "#e379d8"}}},
        bg_normal = color_normal
    })

    awful.titlebar(c, {
        position = "right",
        -- size = beautiful.titlebar_height * (3 / 5),
        size = border_width,
        bg_focus = {type = "linear", from = {0,0}, to = {0, c.height}, stops = {{0, "#1daed4"},{0.5, "#6f86c9"},{1, "#e379d8"}}},
        bg_normal = color_normal
    })
    awful.titlebar(c, {
        position = "top",
        size = border_width,
        bg_focus = "#1daed4",
        bg_normal = color_normal,
    }):setup {
        {
            bg = "#242d35",
            -- The real, anti-aliased shape
            shape = function(cr, w, h)
                gears.shape.partially_rounded_rect(cr, w, h, true, true, false, false, dpi(9))
            end,
            widget = wibox.container.background()
        },
        top = border_width,
        left = border_width,
        right = border_width,
            bg = "#242d35",
        widget = wibox.container.margin
    }

    awful.titlebar(c, {
        position = "bottom",
        size = border_width,
        --size = beautiful.oof_border_width,
        bg_focus = "#e379d8",
        bg_normal = color_normal,
    })
end)

client.connect_signal("focus", function(c)

    local buttons = gears.table.join(
        awful.button({ }, 1, function()
            client.focus = c
            c:raise()
            awful.mouse.client.move(c)
        end),
        awful.button({ }, 3, function()
            client.focus = c
            c:raise()
            awful.mouse.client.resize(c)
        end)
    )

    awful.titlebar(c, {
        position = "top",
        size = border_width,
        bg_focus = "#1daed4",
        bg_normal = color_normal
    }):setup {
        {
            bg = "#242d35",
            -- The real, anti-aliased shape
            shape = function(cr, w, h)
                gears.shape.partially_rounded_rect(cr, w, h, true, true, false, false, dpi(9))
            end,
            widget = wibox.container.background()
        },
        top = border_width,
        left = border_width,
        right = border_width,
        widget = wibox.container.margin
    }

    awful.titlebar(c, {
        position = "bottom",
        size = border_width,
        --size = beautiful.oof_border_width,
        bg_focus = "#e379d8",
        bg_normal = color_normal,
    }):setup {
        {
            bg = "#111111",
            -- The real, anti-aliased shape
            shape = function(cr, w, h)
                gears.shape.partially_rounded_rect(cr, w, h, false, false, true, true, dpi(12))
            end,
            widget = wibox.container.background()
        },
        bottom = border_width,
        left = border_width,
        right = border_width,
        widget = wibox.container.margin
    }


    awful.titlebar(c, {
        position = "left",
        -- size = beautiful.titlebar_height * (3 / 5),
        size = border_width,
        bg_focus = {type = "linear", from = {0,0}, to = {0, c.height}, stops = {{0, "#1daed4"},{0.5, "#6f86c9"},{1, "#e379d8"}}},
        bg_normal = color_normal
    })

    awful.titlebar(c, {
        position = "right",
        -- size = beautiful.titlebar_height * (3 / 5),
        size = border_width,
        bg_focus = {type = "linear", from = {0,0}, to = {0, c.height}, stops = {{0, "#1daed4"},{0.5, "#6f86c9"},{1, "#e379d8"}}},
        bg_normal = color_normal
    })
end)

-- client.connect_signal("focus", function(c) awful.titlebar.show(c) end)
-- client.connect_signal("unfocus", function(c) awful.titlebar.hide(c) end)
