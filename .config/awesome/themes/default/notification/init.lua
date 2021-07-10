local gears = require('gears')
local wibox = require('wibox')
local awful = require('awful')
local ruled = require('ruled')
local naughty = require('naughty')
local menubar = require('menubar')
local beautiful = require('beautiful')
local dpi = beautiful.xresources.apply_dpi
local clickable_container = require('utils.clickable-container')

-- Defaults
naughty.config.defaults.ontop = true
naughty.config.defaults.icon_size = dpi(72/1.645)
naughty.config.defaults.timeout = 10
naughty.config.defaults.title = ''
naughty.config.defaults.margin = dpi(16/1.645)
naughty.config.defaults.border_width = 0
naughty.config.defaults.position = 'top_right'
-- naughty.config.defaults.shape = function(cr, w, h)
-- 	gears.shape.rounded_rect(cr, w, h, dpi(6))
-- end

-- Apply theme variables
naughty.config.padding = dpi(8/1.645)
naughty.config.spacing = dpi(8/1.645)
naughty.config.icon_dirs = {
	'/usr/share/icons/Papirus-Dark-Custom/',
	'/usr/share/icons/Adwaita/',
	'/usr/share/icons/hicolor/',
	'/usr/share/icons/locolor/',
	'/usr/share/icons/gnome/'
}
naughty.config.icon_formats = { 'svg', 'png', 'jpg', 'gif' }


-- Presets / rules

ruled.notification.connect_signal(
	'request::rules',
	function()

		-- Critical notifs
		ruled.notification.append_rule {
			rule       = { urgency = 'critical' },
			properties = {
				font        	= 'Fira Code Mono 10',
				bg 						= '#ff0000',
				fg 						= '#ffffff',
				margin 				= dpi(16/1.645),
				position 			= 'top_right',
				implicit_timeout	= 0
			}
		}

		-- Normal notifs
		ruled.notification.append_rule {
			rule       = { urgency = 'normal' },
			properties = {
				font        	= 'Fira Code Mono 10',
				bg      			= beautiful.transparent,
				fg 						= beautiful.fg_normal,
				margin 				= dpi(16/1.645),
				position 			= 'top_right',
				implicit_timeout 	= 20
			}
		}

		-- Low notifs
		ruled.notification.append_rule {
			rule       = { urgency = 'low' },
			properties = {
				font        		= 'Fira Code Mono 10',
				bg     				= beautiful.transparent,
				fg 						= beautiful.fg_normal,
				margin 				= dpi(16/1.645),
				position 			= 'top_right',
				implicit_timeout	= 10
			}
		}
	end
	)

-- Error handling
naughty.connect_signal(
	'request::display_error',
	function(message, startup)
		naughty.notification {
			urgency = 'critical',
			title   = 'Oops, an error happened'..(startup and ' during startup!' or '!'),
			message = message,
			app_name = 'System Notification',
			icon = beautiful.awesome_icon
		}
	end
)

-- XDG icon lookup
naughty.connect_signal(
	'request::icon',
	function(n, context, hints)
		if context ~= 'app_icon' then return end

		local path = menubar.utils.lookup_icon(hints.app_icon) or
		menubar.utils.lookup_icon(hints.app_icon:lower())

		if path then
			n.icon = path
		end
	end
)

-- Connect to naughty on display signal
naughty.connect_signal(
	'request::display',
	function(n)
		local dont_disturb = true

		if not dont_disturb then
			awful.spawn.with_shell('canberra-gtk-play -i message')
		end
		-- Actions Blueprint
		local actions_template = wibox.widget {
			notification = n,
			base_layout = wibox.widget {
				spacing        = dpi(0),
				layout         = wibox.layout.flex.horizontal
			},
			widget_template = {
				{
					{
						{
							{
								id     = 'text_role',
								font   = 'Fira Code Mono 10',
								widget = wibox.widget.textbox
							},
							widget = wibox.container.place
						},
						widget = clickable_container
					},
					bg                 = beautiful.groups_bg,
					shape              = gears.shape.rounded_rect,
					forced_height      = dpi(30/1.645),
					widget             = wibox.container.background
				},
				margins = dpi(4/1.645),
				widget  = wibox.container.margin
			},
			style = { underline_normal = false, underline_selected = true },
			widget = naughty.list.actions
		}

		-- Notifbox Blueprint
		naughty.layout.box {
			notification = n,
			type = 'notification',
			screen = awful.screen.preferred(),
			shape = gears.shape.rectangle,
			widget_template = {
				{
					{
						{
							{
								{
									{
										{
											{
												{
													{
															resize_strategy = 'center',
														-- shape = gears.shape.rounded_rect,
															widget = naughty.widget.icon,
													},
													shape = gears.shape.rounded_rect,
													widget = wibox.container.background
												},
												{
													{
														layout = wibox.layout.align.vertical,
														expand = 'none',
														nil,
														{
															{
                                text = n.title,
                                font = "Fira Code Mono Bold 11",
                                align = "center",
                                --visible = title_visible,
                                widget = wibox.widget.textbox,
															},
															{
                                text = n.message,
                                font = "Fira Code Mono 10",
                                align = "left",
                                -- wrap = "char",
                                widget = wibox.widget.textbox,
															},
															layout = wibox.layout.fixed.vertical
														},
														nil
													},
													margins = beautiful.notification_margin,
													widget  = wibox.container.margin,
												},
												layout = wibox.layout.fixed.horizontal,
											},
											fill_space = true,
											spacing = dpi(0),
											layout  = wibox.layout.fixed.vertical,
										},
										-- Margin between the fake background
										-- Set to 0 to preserve the 'titlebar' effect
										margins = dpi(0),
										widget  = wibox.container.margin,
									},
									bg = beautiful.transparent,
									widget  = wibox.container.background,
								},
								-- Actions
								actions_template,
								spacing = dpi(0),
								layout  = wibox.layout.fixed.vertical,
							},
							bg     = beautiful.transparent,
							id     = 'background_role',
							widget = naughty.container.background,
						},
						strategy = 'min',
						width    = dpi(160/1.645),
						widget   = wibox.container.constraint,
					},
					strategy = 'max',
					width    = beautiful.notification_max_width or dpi(600/1.645),
					widget   = wibox.container.constraint
				},
				bg = beautiful.background,
				shape = gears.shape.rounded_rect,
				widget = wibox.container.background
			}
		}
		-- Destroy popups if dont_disturb mode is on
		-- Or if the central_panel is visible
		local focused = awful.screen.focused()
		if _G.dont_disturb or
			(focused.central_panel and focused.central_panel.visible) then
			naughty.destroy_all_notifications(nil, 1)
		end

	end
)


