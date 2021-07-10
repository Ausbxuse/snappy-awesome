local awful = require("awful")
local gears = require("gears")
local ruled = require("ruled")

-- Rules to apply to new clients.
ruled.client.connect_signal("request::rules", function()
  -- All clients will match this rule.
  ruled.client.append_rule {
    id = "global",
    rule = {},
    properties = {
      focus = awful.client.focus.filter,
      raise = true,
      screen = awful.screen.preferred,
      placement = awful.placement.no_overlap + awful.placement.no_offscreen
    },

    -- callback = function(c) awful.placement.centered(c, nil) end
  }

  -- Floating clients.
  ruled.client.append_rule{
    rule_any = {
      class = {"Alacritty"}
    },
    callback = function(c) awful.placement.centered(c, nil) end
  }
  ruled.client.append_rule {
    id = "floating",
    rule_any = {
      instance = {"copyq", "pinentry", "wally"},
      class = {
        "Arandr", "Blueman-manager", "Gpick", "Kruler", "Tor Browser",
        "Wpa_gui", "veromix", "xtightvncviewer", "scratchpad", "Sxiv",
        "Zathura", "Wally", "wally"
      },
      -- Note that the name property shown in xprop might be set slightly after creation of the client
      -- and the name shown there might not match defined rules here.
      name = {
        "Event Tester", -- xev.
        "wally",
        "emoji"
      },
      role = {
        "AlarmWindow", -- Thunderbird's calendar.
        "ConfigManager", -- Thunderbird's about:config.
        "pop-up" -- e.g. Google Chrome's (detached) Developer Tools.
      }
    },
    properties = {raise = true, floating = true},
    -- always center
    -- callback = function(c) awful.placement.centered(c, nil) end
  }

  -- Add titlebars to normal clients and dialogs
  ruled.client.append_rule {
    id = "titlebars",
    rule_any = {type = {"normal", "dialog"}},
    properties = {titlebars_enabled = true}
  }

  -- Set Firefox to always map on the tag named "2" on screen 1.
  ruled.client.append_rule {
    rule = {class = {"Gimp", "Zathura", "Sxiv", "feh" }},
    properties = {tag = "󰪷", switch_to_tags = true}
  }
  ruled.client.append_rule {
    rule = {class = {"Chromium", "Blender"}},
    properties = {tag = "󰥟", switch_to_tags = true}
  }

  ruled.client.append_rule {
    rule = {class = "mpv"},
    properties = {tag = "󱉺", switch_to_tags = true}
  }

  ruled.client.append_rule {
    rule = {class = "ncmpcpp"},
    properties = {tag = "󰋋", switch_to_tags = true}
  }

end)
