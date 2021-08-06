---------------------------
-- Default awesome theme --
---------------------------
-- LuaFormatter off
local theme_name                                        = "default"
local theme_assets                                      = require("beautiful.theme_assets")
local xresources                                        = require("beautiful.xresources")
local rnotification                                     = require("ruled.notification")
local dpi                                               = xresources.apply_dpi

local icon_path                                         = os.getenv("HOME") .. "/.config/awesome/icons/"

local theme = {}

theme.font                                              = "sans 10"
theme.font_bold                                         = "Fira Code Mono Bold 10"

theme.transparent                                       = "#00000000"
theme.semitrans                                         = "#1c1e2677"
theme.groups_bg                                         = "#ffffff10"

theme.groups_radius                                         = dpi(6/1.645)
theme.bg_normal                                         = "#242d35dd"
-- theme.bg_normal                                         = "#1c1e2600"
--theme.bg_default                                        = "#1c1e26"
theme.bg_default                                        = "#242d35"
theme.bg_focus                                          = "#00000099"
theme.background                                        = '#00000099'
theme.bg_urgent                                         = "#ff0000"
theme.bg_minimize                                       = "#ffffff00"
theme.bg_systray                                        = "#f9f9f9"
-- theme.bg_light                                          = "#282c34"
theme.bg_light                                          = "#1c1e26"

theme.fg_normal                                         = "#f9f9f9"
theme.fg_focus                                          = "#ffffff"
theme.fg_urgent                                         = "#ffffff"
theme.fg_minimize                                       = "#ffffff"

theme.useless_gap                                       = dpi(4)
-- theme.border_width                                      = dpi(4/1.645)
--theme.border_width                                      = dpi(0)
--theme.border_radius                                     = dpi(9/1.645)
theme.border_color_normal                               = "#56666f"
theme.border_color_active                               = "#1daed4"
theme.border_color_marked                               = "#91231c"

theme.deep_blue                                         = "#1e88e5"
theme.blue                                              = "#7bc6fa"
theme.blue_light                                        = "#3FC6DE"
theme.cyan                                              = "#6ffaed"
theme.cyan_light                                        = "#6BE6E6"
theme.green                                             = "#b7fd4b"
theme.green_light                                       = "#3FDAA4"
theme.purple                                            = "#bd93f9"
theme.purple_light                                      = "#F075B7"
theme.red                                               = "#ff2740"
theme.orange                                            = "#ffdd00"
theme.red_light                                         = "#EC6A88"
theme.yellow                                            = "#fde83f"
theme.yellow_light                                      = "#FBC3A7"

theme.dont_swallow_classname_list = {"Gimp",  "Brave", "Chromium", "Chromium-browser", "Brave-browser", "libreoffice-writer", "libreoffice", "Zathura" }

theme.sidebar_position                                  = "left"

theme.bar_position                                      = "top"
theme.bar_height                                        = dpi(24)
theme.bar_item_radius                                   = dpi(10/1.645)
theme.bar_item_padding                                  = dpi(3/1.645)
-- There are other variable sets
-- overriding the default one when
-- defined, the sets are:
-- taglist_[bg|fg]_[focus|urgent|occupied|empty|volatile]
-- tasklist_[bg|fg]_[focus|urgent]
-- titlebar_[bg|fg]_[normal|focus]
-- theme.tasklist_bg_focus = theme.bg_normal
theme.titlebar_bg_normal                                = theme.bg_default
theme.titlebar_bg_focus                                 = theme.bg_default
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- mouse_finder_[color|timeout|animate_timeout|radius|factor]
-- prompt_[fg|bg|fg_cursor|bg_cursor|font]
-- hotkeys_[bg|fg|border_width|border_color|shape|opacity|modifiers_fg|label_bg|label_fg|group_margin|font|description_font]

-- theme.prompt_bg="#444444"
theme.prompt_bg_cursor = "#ffffff"
theme.hotkeys_font = 'JetBrainsMono Nerd Font Bold'
theme.hotkeys_modifiers_fg = "#444444"
theme.hotkeys_description_font = 'JetBrainsMono Nerd Font Regular'
theme.hotkeys_bg = theme.background
theme.hotkeys_group_margin = dpi(20/1.645)
-- Example:
theme.mouse_finder_color = "#ff0000"
theme.mouse_finder_timeout = 3
theme.mouse_finder_radius = 10
--theme.taglist_fg_focus = theme.red
--theme.taglist_fg_occupied = theme.blue
--theme.taglist_fg_urgent = theme.green
--theme.taglist_fg_empty = theme.yellow
theme.taglist_font                                      = "JetBrainsMono Nerd Font 9"

-- Generate taglist squares:
-- local taglist_square_size                               = dpi(4/1.645)
-- theme.taglist_squares_sel                               = theme_assets.taglist_squares_sel(
--     taglist_square_size, theme.blue
-- )
-- theme.taglist_squares_unsel                             = theme_assets.taglist_squares_unsel(
--     taglist_square_size, theme.blue
-- )

-- theme.tasklist_icon_size = dpi(5/1.645)
theme.tasklist_plain_task_name                          = true
theme.tasklist_bg_normal = "#ffffff11"
theme.tasklist_bg_focus = "#ffffff33"
--     'linear:0,0:0,' ..
--     dpi(38/1.645) ..
--       ':0,' ..
--         "#ffffff33" ..
--           ':0.95,' .. "#ffffff33" .. ':0.95,' .. theme.deep_blue .. ':1,' .. theme.deep_blue

theme.taglist_spacing                                   = dpi(10/1.645)
--theme.taglist_bg_focus                                  = "#63c5ea"
theme.taglist_bg_focus                                  = {type = "linear", from = {0,0}, to = {0, theme.bar_height / 24 * 17.5}, stops = {{0, theme.fg_normal}, {0.9, theme.fg_normal}, {1, "#fc1a70"}}}
theme.taglist_fg_focus                                  = "#fc1a70"
theme.taglist_bg_occupied                               = theme.transparent
theme.taglist_fg_occupied                               = "#fc1a70"
theme.taglist_bg_empty                                  = theme.transparent
theme.taglist_fg_empty                                  = "#63c5ea"
theme.taglist_bg_urgent                                 = theme.transparent
theme.taglist_fg_urgent                                 = theme.red

-- Variables set for theming notifications:
-- notification_font
-- notification_[bg|fg]
-- notification_[width|height|margin]
-- notification_[border_color|border_width|shape|opacity]
theme.notification_font                                 = "JetBrainsMono Nerd Font Bold 14"
theme.notification_opacity                              = 1
theme.notification_position                             = 'top_right'
theme.notification_bg                                   = theme.transparent
theme.notification_margin                               = dpi(5/1.645)
theme.notification_border_width                         = dpi(0)
theme.notification_border_color                         = theme.transparent
theme.notification_spacing                              = dpi(5/1.645)
theme.notification_icon_resize_strategy                 = 'center'
theme.notification_icon_size                            = dpi(96/1.645)
theme.notification_width                                = dpi(400/1.645)
-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
theme.menu_bg_normal                                    = "#eaeaea"
theme.menu_fg_normal                                    = "#282a36"
theme.menu_bg_focus                                    = theme.deep_blue
theme.menu_fg_focus                                    = theme.fg_normal
theme.menu_submenu_icon                                 = icon_path.."submenu.png"
theme.menu_height                                       = dpi(25)
theme.menu_width                                        = dpi(150)
theme.menu_border_color                                 = theme.menu_bg_normal
theme.menu_border_width                                 = dpi(5)

theme.margin_size                                       = dpi(6/1.645)
theme.margin_hover_diff                                 = dpi(6/1.645)
theme.taglist_text_font                                 = "JetBrainsMono Nerd Font 15"

-- You can add as many variables as
-- you wish and access them by using
-- beautiful.variable in your rc.lua
--theme.bg_widget = "#cc0000"

-- Define the image to load
-- regular
theme.titlebar_close_button_normal                      = icon_path.."titlebar/close/close_1.png"
theme.titlebar_close_button_focus                       = icon_path.."titlebar/close/close_2.png"
theme.titlebar_maximized_button_normal_inactive         = icon_path.."titlebar/maximize/maximize_1.png"
theme.titlebar_maximized_button_focus_inactive          = icon_path.."titlebar/maximize/maximize_2.png"
theme.titlebar_maximized_button_normal_active           = icon_path.."titlebar/maximize/maximize_3.png"
theme.titlebar_maximized_button_focus_active            = icon_path.."titlebar/maximize/maximize_3.png"
theme.titlebar_minimize_button_normal                   = icon_path.."titlebar/minimize/minimize_1.png"
theme.titlebar_minimize_button_focus                    = icon_path.."titlebar/minimize/minimize_2.png"

-- hover
theme.titlebar_close_button_normal_hover                = icon_path.."titlebar/close/close_3.png"
theme.titlebar_close_button_focus_hover                 = icon_path.."titlebar/close/close_3.png"
theme.titlebar_maximized_button_normal_inactive_hover   = icon_path.."titlebar/maximize/maximize_3.png"
theme.titlebar_maximized_button_focus_inactive_hover    = icon_path.."titlebar/maximize/maximize_3.png"
theme.titlebar_maximized_button_normal_active_hover     = icon_path.."titlebar/maximize/maximize_3.png"
theme.titlebar_maximized_button_focus_active_hover      = icon_path.."titlebar/maximize/maximize_3.png"
theme.titlebar_minimize_button_normal_hover             = icon_path.."titlebar/minimize/minimize_3.png"
theme.titlebar_minimize_button_focus_hover              = icon_path.."titlebar/minimize/minimize_3.png"

theme.titlebar_height                                   = dpi(20)

theme.titlebar_ontop_button_normal_inactive             = icon_path.."titlebar/ontop_normal_inactive.png"
theme.titlebar_ontop_button_focus_inactive              = icon_path.."titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_active               = icon_path.."titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_active                = icon_path.."titlebar/ontop_focus_active.png"

theme.titlebar_sticky_button_normal_inactive            = icon_path.."titlebar/sticky_normal_inactive.png"
theme.titlebar_sticky_button_focus_inactive             = icon_path.."titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_active              = icon_path.."titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_active               = icon_path.."titlebar/sticky_focus_active.png"

theme.titlebar_floating_button_normal_inactive          = icon_path.."titlebar/floating_normal_inactive.png"
theme.titlebar_floating_button_focus_inactive           = icon_path.."titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_active            = icon_path.."titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_active             = icon_path.."titlebar/floating_focus_active.png"

theme.wallpaper                                         = "/home/peter/.config/awesome/themes/default/wall.png"

-- You can use your own layout icons like this:
theme.layout_fairh                                      = icon_path.."layouts/fairhw.png"
theme.layout_fairv                                      = icon_path.."layouts/fairvw.png"
theme.layout_floating                                   = icon_path.."layouts/floatingw.png"
theme.layout_magnifier                                  = icon_path.."layouts/magnifierw.png"
theme.layout_max                                        = icon_path.."layouts/maxw.png"
theme.layout_fullscreen                                 = icon_path.."layouts/fullscreenw.png"
theme.layout_tilebottom                                 = icon_path.."layouts/tilebottomw.png"
theme.layout_tileleft                                   = icon_path.."layouts/tileleftw.png"
theme.layout_tile                                       = icon_path.."layouts/tilew.png"
theme.layout_tiletop                                    = icon_path.."layouts/tiletopw.png"
theme.layout_spiral                                     = icon_path.."layouts/spiralw.png"
theme.layout_dwindle                                    = icon_path.."layouts/dwindlew.png"
theme.layout_cornernw                                   = icon_path.."layouts/cornernww.png"
theme.layout_cornerne                                   = icon_path.."layouts/cornernew.png"
theme.layout_cornersw                                   = icon_path.."layouts/cornersww.png"
theme.layout_cornerse                                   = icon_path.."layouts/cornersew.png"


-- theme.avatar = icon_path.."avatar.png"
-- theme.battery_alert_icon = icon_path.."battery_alert.png"
-- theme.notification_icon = icon_path.."notification.png"
-- theme.search_icon = icon_path.."search.png"
-- theme.search_grey_icon = icon_path.."search_grey.png"
-- theme.next_icon = icon_path.."next.png"
-- theme.next_grey_icon = icon_path.."next_grey.png"
-- theme.previous_icon = icon_path.."previous.png"
-- theme.previous_grey_icon = icon_path.."previous_grey.png"
-- theme.camera_icon = icon_path.."camera.png"
-- Generate Awesome icon:
theme.awesome_icon = theme_assets.awesome_icon(
    theme.menu_height, theme.bg_focus, theme.fg_focus
)

-- Define the icon theme for application icons. If not set then the icons
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme = nil

-- Set different colors for urgent notifications.
rnotification.connect_signal('request::rules', function()
    rnotification.append_rule {
        rule       = { urgency = 'critical' },
        properties = { bg = '#ff0000', fg = '#ffffff' }
    }
end)

theme.tag_preview_widget_border_radius = dpi(2)          -- Border radius of the widget (With AA)
theme.tag_preview_client_border_radius = dpi(2)         -- Border radius of each client in the widget (With AA)
theme.tag_preview_client_opacity = 1              -- Opacity of each client
theme.tag_preview_client_bg = theme.bg_normal             -- The bg color of each client
theme.tag_preview_client_border_color = "#56666f"   -- The border color of each client
theme.tag_preview_client_border_width = 2           -- The border width of each client
theme.tag_preview_widget_bg = theme.bg_normal -- The bg color of the widget
theme.tag_preview_widget_border_color = "#56666f"   -- The border color of the widget
theme.tag_preview_widget_border_width = 2           -- The border width of the widget
theme.tag_preview_widget_margin = 2                 -- The margin of the widget


theme.pinned_apps = {
    "alacritty",
    "brave"
}

theme.app_to_icon = {
    ["thunderbird"] = icon_path .. "apps/email.svg",
    ["alacritty"] = icon_path .. "apps/Terminal.svg",
    ["element"] = icon_path .. "apps/internet-chat.svg",
    ["thunar"] = icon_path .. "apps/filemanager.svg",
    ["deemix-gui-pyweb"] = icon_path .. "apps/music_icon-24.svg",
    ["brave"] = icon_path .. "apps/webbrowser-app.svg",
}

return theme

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
-- LuaFormatter on
