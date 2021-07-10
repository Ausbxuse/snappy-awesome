local naughty = require("naughty")
local awful = require("awful")
local gears = require("gears")

local return_tbl = {}
local create_notification = function(filename)
	local open_image = naughty.action {
		name = 'Open',
		icon_only = false,
	}

	local delete_image = naughty.action {
		name = 'Delete',
		icon_only = false,
	}

	open_image:connect_signal(
		'invoked',
		function()
			awful.spawn('xdg-open ' .. filename, false)
		end
	)

	delete_image:connect_signal(
		'invoked',
		function()
			awful.spawn('gio trash ' .. filename, false)
		end
	)

	naughty.notification ({
		app_name = 'Screen Shot',
		icon = filename,
		icon_size = 240/1.645,
		timeout = 60,
		title = 'Screen Shot!',
		-- message = 'Image('.. filename .. ') can now be viewed.',
		message = 'Image can now be viewed.',
		actions = { open_image, delete_image }
  })
end

local shot = function(filename)
	awful.spawn.easy_async_with_shell("maim " .. filename, function(stderr)
		if stderr == "" then
			awful.spawn("mpv /home/peter/.local/share/sounds/screen_shot.mp3")
			create_notification(filename)
		else
			print("screenshot fail")
		end
	end)
end

local create_filename = function()
	awful.spawn.easy_async_with_shell([[
		date '+%y%m%d-%H%M-%S'
		]],
	function(stdout)
		local filename = "/home/peter/Pictures/Screenshots/"..stdout:gsub('%\n', '')..".png"
		shot(filename)
	end)
end

return_tbl.scrshot = function()
	create_filename()
end

return return_tbl
