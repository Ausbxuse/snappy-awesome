local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local bling = require("bling")
local dpi = beautiful.xresources.apply_dpi

local title_widget = wibox.widget {
    id = 'title',
    -- text = 'The song title is here asdfasdf',
    markup = '',
    font = 'Inter Bold 12',
    align  = 'center',
    valign = 'center',
    ellipsize = 'end',
    widget = wibox.widget.textbox
}

local wdg = wibox.widget {
  layout = wibox.layout.align.horizontal,
  expand = 'none',
  nil,
	{
    title_widget,
		id = 'scroll_container',
    max_size = 300,
    speed = 75,
    expand = true,
    direction = 'h',
    step_function = wibox.container.scroll
              .step_functions.waiting_nonlinear_back_and_forth,
    fps = 60,
    layout = wibox.container.scroll.horizontal
	},
	nil
}

bling.signal.playerctl.enable()

awesome.connect_signal("bling::playerctl::title_artist_album",
                       function(title, artist, art_path, player_name)
    -- Set art widget
    title_widget:set_markup_silently(title)
end)

-- awesome.connect_signal("bling::playerctl::status",
--                        function(playing, player_name)
--     if player_name == "mpd" then
--       if playing then
--         title_widget:set_markup_silently('')
--       else 
--         title_widget:set_markup_silently('')
--       end
--     end
--     -- Set art widget
-- end)


return wdg
