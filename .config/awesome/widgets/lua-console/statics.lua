local statics = {}

-- This is used later as the default terminal and editor to run.
-- statics.terminal = "tilix"
statics.terminal = "alacritty"
statics.editor = os.getenv("EDITOR") or "sh -c 'MAGICK_OCL_DEVICE=OFF emacs'"
statics.editor_cmd = statics.terminal .. " -e " .. statics.editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
statics.modkey = "Mod4"

-- Refresh rate
statics.refresh_rate = 60
statics.refresh_delta = 1 / statics.refresh_rate

-- Fonts
statics.font_name = "Ubuntu"
statics.font_size = 8
statics.font_size_title = 18
statics.font_size_subtitle = 14
statics.font = statics.font_name .. " " .. statics.font_size
statics.font_bold = statics.font_name .. " Bold " .. statics.font_size
statics.font_title = statics.font_name .. " Light " .. statics.font_size_title
statics.font_subtitle = statics.font_name .. " Light " .. statics.font_size_subtitle

statics.mono_font_name = "Terminus (TTF)"
statics.mono_font_size = 9
statics.mono_font = statics.mono_font_name .. " " .. statics.mono_font_size

return statics
