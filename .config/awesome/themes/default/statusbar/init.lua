local gears = require("gears")
local awful = require("awful")
local beautiful = require("beautiful")
local wibox = require("wibox")

local dpi = require("beautiful.xresources").apply_dpi

local build_widget = function(widget)
  return wibox.widget {
    {
      widget,
      bg = {type = "linear", from = {0,0}, to = {0, beautiful.bar_height/24 * 17}, stops = {{0, "#1daed4"},{0.5, "#6f86c9"},{1, "#e379d8"}}},
      --bg = "ffffff22",
      shape = function(cr, w, h) gears.shape.rounded_rect(cr, w, h, dpi(6/1.645)) end,
      widget = wibox.container.background
    },
    top = dpi(4/1.645),
    bottom = dpi(4/1.645),
    left = dpi(5/1.645),
    right = dpi(5/1.645),
    widget = wibox.container.margin
  }
end

-- Keyboard map indicator and switcher
local mykeyboardlayout = awful.widget.keyboardlayout()

-- Create a textclock widget

beautiful.systray_icon_spacing = dpi(8/1.645)


screen.connect_signal("request::desktop_decoration", function(s)
  s.mpd = require('themes.default.statusbar.mpd')()
  local clock = require("themes.default.statusbar.clock")(s)
  local layout_box = require("themes.default.statusbar.layoutbox")(s)
  -- local cpu_widget = require(
  --                     "themes.default.stausbar.cpu-widget.cpu-widget")
  local oldtasklist = require('themes.default.statusbar.tasklist')
  local notif = require("themes.default.statusbar.notif")()
  -- local notif_center = require('widgets.notification-panel-toggler')
  s.screen_rec = require('themes.default.statusbar.screen-recorder')()
    -- Each screen has its own tag table.
  --awful.tag({"󱍤", "󰪷", "󰅺", "󰋋", "󱉺", "󰥟"},
  --            s, awful.layout.layouts[1])

  awful.tag.add("󱍤", {
      layout = awful.layout.suit.tile,
      screen = s,
  })
  awful.tag.add("󰪷", {
      layout = awful.layout.suit.tile,
      screen = s,
  })
  awful.tag.add("󰅺", {
      layout = awful.layout.suit.tile,
      screen = s,
  })
  awful.tag.add("󰍳", {
      layout = awful.layout.suit.tile,
      screen = s,
  })
  awful.tag.add("󰋋", {
      layout = awful.layout.suit.tile,
      screen = s,
  })
  awful.tag.add("󱉺", {
      layout = awful.layout.suit.tile,
      screen = s,
  })
  awful.tag.add("󰥟", {
      layout = awful.layout.suit.tile,
      screen = s,
  })
  -- Create an imagebox widget which will contain an icon indicating which layout we're using.
  -- We need one layoutbox per screen.
  s.mylayoutbox = awful.widget.layoutbox {
    screen = s,
    buttons = {
      awful.button({}, 1, function() awful.layout.inc(1) end),
      awful.button({}, 3, function() awful.layout.inc(-1) end),
      awful.button({}, 4, function() awful.layout.inc(-1) end),
      awful.button({}, 5, function() awful.layout.inc(1) end)
    }
  }

  -- -- Create the wibox
  s.statusbar = awful.wibar({
    position = beautiful.bar_position,
    screen = s,
    height = beautiful.bar_height
  })

  local mytasklist = require("widgets.tasklist.newtasklist")
  local systray = wibox.widget {
    widget = wibox.container.margin,
    margins = dpi(4/1.645),
    {
      widget = wibox.container.background,
      shape = function(cr, w, h) gears.shape.squircle(cr, w, h, dpi(4)) end,
      bg = beautiful.bg_systray,
      {
        widget = wibox.container.margin,
        margins = dpi(1.01),
        wibox.widget.systray()
      }
    }
  }

  -- Add widgets to the wibox
  s.statusbar.widget = {
    layout = wibox.layout.align.horizontal,
    expand = "none",
    { -- Left widgets
      layout = wibox.layout.fixed.horizontal,
      wibox.widget {
        {
          require("themes.default.statusbar.taglist")(s),
          --bg = beautiful.bg_default,
          --  shape = function(cr, w, h)
          --    gears.shape.rounded_rect(cr, w, h, dpi(12/1.645))
          --  end,
          widget = wibox.container.background
        },
        top = dpi(4/1.645),
        bottom = dpi(4/1.645),
        left = dpi(5/1.645),
        right = dpi(5/1.645),
        widget = wibox.container.margin
      }

    },
    -- build_widget(tasklist(s)),
    {
      layout = wibox.layout.fixed.horizontal,
      spacing = dpi(4/1.645),
      mytasklist,
      --tasklist1,
      -- oldtasklist(s, awful.widget.tasklist.filter.currenttags),
      -- require("redflat.widget.tasklist")
    },
    { -- Right widgets
      layout = wibox.layout.fixed.horizontal,
      -- require("widgets.song-title"),
      -- systray,
      clock, -- Middle widget
      -- build_widget(cpu_widget({
      --     width = 40,
      --     step_width = 2,
      --     step_spacing = 0,
      --     color = '#ffffff'
      -- })),
      build_widget(require("themes.default.statusbar.battery")()),
      build_widget(require("themes.default.statusbar.network")()),
      s.screen_rec,
      -- widget(s.mylayoutbox),
      build_widget(s.mpd),
      -- build_widget(notif),
      build_widget(layout_box),
    }
  }

end)

