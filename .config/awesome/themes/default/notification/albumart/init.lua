local naughty = require("naughty")
local awful = require("awful")
local gears = require('gears')
local config_dir = gears.filesystem.get_configuration_dir()
local widget_icon_dir = config_dir .. 'icons/mpd/'

local return_tbl = {}
local create_notification = function(icon_dir, song_info)
	naughty.notification ({
		app_name = 'Album Art',
		icon = icon_dir,
		icon_size = 240,
		timeout = 6,
		title = "Song Info",
		message = song_info,
  })
end

local update_notif = function()
	local extract_script = [=[
		#MUSIC_DIR="$(xdg-user-dir MUSIC)"
		MUSIC_DIR="/home/peter/Music"
		TMP_DIR="/tmp/awesomewm/${USER}/"
		TMP_COVER_PATH=${TMP_DIR}"cover.jpg"
		TMP_SONG="${TMP_DIR}current-song"

		CHECK_EXIFTOOL=$(command -v exiftool)

		if [ ! -d "${TMP_DIR}" ]; then
			mkdir -p "${TMP_DIR}";
		fi

		if [ ! -z "$CHECK_EXIFTOOL" ]; then

			SONG="$MUSIC_DIR/$(mpc -p 6600 --format "%file%" current)"
			PICTURE_TAG="-Picture"
			
			if [[ "$SONG" == *".m4a" ]]; then
				PICTURE_TAG="-CoverArt"
			fi

			# Extract album cover using perl-image-exiftool
			exiftool -b "$PICTURE_TAG" "$SONG"  > "$TMP_COVER_PATH"

		else

			#Extract image using ffmpeg
			cp "$MUSIC_DIR/$(mpc --format %file% current)" "$TMP_SONG"

			ffmpeg \
			-hide_banner \
			-loglevel 0 \
			-y \
			-i "$TMP_SONG" \
			-vf scale=300:-1 \
			"$TMP_COVER_PATH" > /dev/null 2>&1

			rm "$TMP_SONG"
		fi
			
		img_data=$(identify $TMP_COVER_PATH 2>&1)

		# Delete the cover.jpg if it's not a valid image
		if [[ $img_data == *"insufficient"* ]]; then
			rm $TMP_COVER_PATH
		fi

		if [ -f $TMP_COVER_PATH ]; then 
			echo $TMP_COVER_PATH; 
		fi
	]=]

	awful.spawn.easy_async_with_shell(
		extract_script,
		function(stdout)
			local album_icon = widget_icon_dir .. 'vinyl.svg'

			if not (stdout == nil or stdout == '') then
				album_icon = stdout:gsub('%\n', '')
			end
			awful.spawn.easy_async_with_shell([[
				mpc --format %album% current
				]],
			function(stdout2)
				local song_info = stdout2:gsub('%\n', '')
					create_notification(album_icon, song_info)
			end)
		end
	)

	-- create_notification(album_icon, song_info)

end

return_tbl.album_art = function()
	naughty.destroy_all_notifications()
	update_notif()
end

return return_tbl
