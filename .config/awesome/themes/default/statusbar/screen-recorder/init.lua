local recorder_table = require('themes.default.statusbar.screen-recorder.screen-recorder-ui')
require('themes.default.statusbar.screen-recorder.screen-recorder-ui-backend')
local screen_rec_toggle_button = recorder_table.screen_rec_toggle_button

local return_button = function()
	return screen_rec_toggle_button
end

return return_button
