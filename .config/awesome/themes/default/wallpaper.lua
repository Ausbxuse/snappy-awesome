local gears = require("gears")
local beautiful = require("beautiful")
local awful = require("awful")

screen.connect_signal("request::wallpaper", function(s)
    -- Wallpaper
    local wallscript = [[sh -c 'randombg -p']]
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        awful.spawn.easy_async(wallscript, function(stdout, stderr, reason, exit_code)
            gears.wallpaper.maximized(stdout:gsub('%\n', ''), s, true)
        end)
        --gears.wallpaper.maximized("/home/peter/.local/share/wallpapers/wall.jpg", s, true)
    end
end)
