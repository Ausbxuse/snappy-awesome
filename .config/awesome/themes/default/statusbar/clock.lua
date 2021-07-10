local wibox = require('wibox')
local awful = require('awful')
local gears = require('gears')
local beautiful = require('beautiful')
local dpi = beautiful.xresources.apply_dpi
local clickable_container = require('utils.clickable-container')

local create_clock = function(s)

    --clock_format = '<span font="Inter Bold 11">%I:%M %p</span>'
  local clock_format = '<span font="JetBrainsMono Nerd Font 9">%H:%M:%S</span>'
	local	date_format = '<span font="JetBrainsMono Nerd Font 6" foreground="#fefefe">%Y/%m/%d</span>'

	s.clock = wibox.widget.textclock(
		clock_format,
		1
	)

	s.date_widget = wibox.widget.textclock(
		date_format,
		1
	)

	s.clock_widget = wibox.widget {
		{
			{
				-- {
					-- 	wibox.container.place(wibox.container.margin(s.clock, 2, 2, 0)),
					-- 	wibox.container.place(s.date_widget),
					-- 	layout = wibox.layout.fixed.vertical
					-- },
				{
					s.clock,
					top = dpi(4/1.645),
					bottom = dpi(4/1.645),
					left = dpi(5/1.645),
					right = dpi(5/1.645),
					widget = wibox.container.margin
				},
				widget = clickable_container
			},
			shape = function(cr, w, h) gears.shape.rounded_rect(cr, w, h, dpi(6/1.645)) end,
      bg = {type = "linear", from = {0,0}, to = {0, dpi(17)}, stops = {{0, "#1daed4"},{0.5, "#6f86c9"},{1, "#e379d8"}}},
			widget = wibox.container.background
		},
		top = dpi(4/1.645),
		bottom = dpi(4/1.645),
		left = dpi(5/1.645),
		right = dpi(5/1.645),
		widget = wibox.container.margin
	}

	s.clock_widget:connect_signal(
		'mouse::enter',
		function()
			local w = mouse.current_wibox
			if w then
				old_cursor, old_wibox = w.cursor, w
				-- w.cursor = 'hand1'
			end
		end
	)

	s.clock_widget:connect_signal(
		'mouse::leave',
		function()
			if old_wibox then
				old_wibox.cursor = old_cursor
				old_wibox = nil
			end
		end
	)

	s.clock_tooltip = awful.tooltip
	{
		objects = {s.clock_widget},
		mode = 'outside',
		delay_show = 0,
		preferred_positions = {'right', 'left', 'top', 'bottom'},
		preferred_alignments = {'middle', 'front', 'back'},
		margin_leftright = dpi(8/1.645),
		margin_topbottom = dpi(8/1.645),
		timer_function = function()
			local ordinal = nil

			local day = os.date('%d')
			local month = os.date('%B')

			local first_digit = string.sub(day, 0, 1) 
			local last_digit = string.sub(day, -1) 

			if first_digit == '0' then
				day = last_digit
			end

			if last_digit == '1' and day ~= '11' then
				ordinal = 'st'
			elseif last_digit == '2' and day ~= '12' then
				ordinal = 'nd'
			elseif last_digit == '3' and day ~= '13' then
				ordinal = 'rd'
			else
				ordinal = 'th'
			end

			local date_str = '<b>' .. month .. ' '.. day .. ordinal .. 
			'</b>, ' ..
			'' .. os.date('%A')

			return date_str
		end,
	}

	s.clock_widget:connect_signal(
		'button::press',
		function(self, lx, ly, button)
			-- Hide the tooltip when you press the clock widget
			if s.clock_tooltip.visible and button == 1 then
				s.clock_tooltip.visible = false
			end
		end
	)

	s.clock_widget:buttons(
		gears.table.join(
			awful.button(
				{},
				1,
				nil,
				function()
					awesome.emit_signal("widget::calendar_osd:toggle")
				end
			)
		)
	)

	return s.clock_widget
end

return create_clock
