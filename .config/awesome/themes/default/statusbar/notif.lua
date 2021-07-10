local gears = require('gears')
local awful = require('awful')
local wibox = require('wibox')
local dpi = require('beautiful').xresources.apply_dpi
local config_dir = gears.filesystem.get_configuration_dir()
local widget_icon_dir = config_dir .. 'icons/widgets/'
local clickable_container = require('utils.clickable-container')

local return_button = function()
	local widget = wibox.widget {
		{
			id = 'icon',
			image = widget_icon_dir .. 'notification.svg',
			widget = wibox.widget.imagebox,
			resize = true
		},
		layout = wibox.layout.align.horizontal
	}

	local widget_button = wibox.widget {
		{
			widget,
			margins = dpi(7/1.645),
			widget = wibox.container.margin
		},
		widget = clickable_container
	}

	local notif_tooltip =  awful.tooltip
	{
		objects = {widget_button},
		text = 'None',
		mode = 'outside',
		margin_leftright = dpi(8/1.645),
		margin_topbottom = dpi(8/.1645),
		align = 'right',
		preferred_positions = {'right', 'left', 'top', 'bottom'}
	}

	widget_button:buttons(
		gears.table.join(
			awful.button(
				{},
				1,
				nil,
				function()
					notif_tooltip.visible = false
					--awesome.emit_signal("widgets::notif_center")
					awesome.emit_signal("widget::notif", true)
				end
			)
		)
	)

	widget_button:connect_signal(
		"mouse::enter",
		function()
			awful.spawn.easy_async_with_shell(
				'mpc status',
				function(stdout)
				notif_tooltip.text = string.gsub(stdout, '\n$', '')
				end
			)
		end
	)


	return widget_button

end

return return_button
