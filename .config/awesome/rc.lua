-- awesome_mode: api-level=4:screen=on
-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")
require("awful.autofocus")
require("awful.hotkeys_popup.keys")

beautiful.init("/home/peter/.config/awesome/themes/default/theme.lua")

local bling = require("bling")
bling.widget.tag_preview.enable {
    show_client_content = true,  -- Whether or not to show the client content
    x = 10,                       -- The x-coord of the popup
    y = 10+beautiful.bar_height,                       -- The y-coord of the popup
    scale = 0.3,                 -- The scale of the previews compared to the screen
    honor_padding = false,        -- Honor padding when creating widget size
    honor_workarea = false        -- Honor work area when creating widget size
}
require("main")

require("themes.default")
-- require("widgets.dock")

require("widgets.brightness-slider")
-- require("widgets.volume-slider")
require("widgets.cat-volume-slider")
require("widgets.exit-screen")
-- require("widgets.dashboard")
-- require("evil")
-- require("widgets.sidebar")
-- require("widgets.panel")

-- local swallow = require("utils.window_swallowing")
-- swallow.start()


require("utils.float-ontop")
-- Enable sloppy focus, so that focus follows mouse.---

-- client.connect_signal("mouse::enter", function(c)
--     c:activate { context = "mouse_enter", raise = false }
-- end)
--
-- require("widgets.mydash")
require("widgets.layoutlist")
require("utils.savefloats")
require("utils.better-resize")
require("widgets.notif-center")
-- require("widgets.control-center")
-- fix no focus when startup
local screen = awful.screen.focused()
local tag = screen.tags[1]
if tag then awful.tag.viewtoggle(tag) end

require("utils.music-notif")
-- require("widgets.tasklist")
