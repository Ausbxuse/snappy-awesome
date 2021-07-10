local awful = require("awful")
local hotkeys_popup = require("awful.hotkeys_popup")
local beautiful = require("beautiful")
local wibox = require("wibox")
local anim = require("utils.anim")
local easing = require("utils.anim.easing")
local bling = require("bling")
local naughty = require("naughty")
-- local bling = require("bling")

super = "Mod4"
alt = "Mod1"
shift = "Shift"
ctrl = "Control"

local hotkeys = {mouse = {}, raw = {}, keys = {}, fake = {}}
-- Mouse bindings
awful.mouse.append_global_mousebindings({
  -- awful.button({ }, 1, function() dashboard_show() end),
  awful.button({}, 3, function() mymainmenu:toggle() end),
  awful.button({}, 1, function() mymainmenu:hide() end),
  awful.button({}, 2, function() if dashboard_show then dashboard_show() end end)
})

-- Key bindings
local lock_screen = require("widgets.lockscreen")
lock_screen.init()

local awmodoro = require("widgets.awmodoro")
local s = awful.screen.focused()

-- pomodoro wibox
local pomowibox = awful.wibar({position = "top", screen = 1, height = 4, ontop = true})
pomowibox.visible = false
local pomodoro = awmodoro.new({
  minutes = 65,
  do_notify = true,
  active_bg_color = '#313131',
  paused_bg_color = '#7746D7',
  fg_color = {
    type = "linear",
    from = {0, 0},
    to = {pomowibox.width, 0},
    stops = {{0, "#1daed4"}, {0.5, "#6f86c9"}, {1, "#e379d8"}}
  },
  width = pomowibox.width,
  height = pomowibox.height,

  begin_callback = function()
    -- s.statusbar.visible = false
    pomowibox.visible = true
  end,

  finish_callback = function()
    awful.spawn("aplay --quiet --nonblock /home/peter/.local/share/sounds/bell.wav")
    -- s.statusbar.visible = true
    pomowibox.visible = false
  end
})
pomowibox:set_widget(pomodoro)

local switcher = require("widgets.awesome-switcher")

local aluaconsole = require("widgets.lua-console.aluaconsole")

local machi = require("widgets.layout-machi")
local awestore = require("utils.awestore")
-- local editor = machi.editor.create()
-- local layout = machi.layout.create({name = "lmao"})

-- General Awesome keys
awful.keyboard.append_global_keybindings(
  {
  awful.key({super}, "Tab",
                    function() switcher.switch(1, super, "Super_L", shift, "Tab") end),
      awful.key({super, shift}, "Tab",
                function() switcher.switch(-1, super, "Super_L", shift, "Tab") end),
    awful.key({super, shift}, "x",
              -- function() aluaconsole.toggle_visibility() end),
              function() naughty.notification{
                  message = tostring(client.focus)
            } end),
    -- awful.key({super}, "Tab",
    --           function() appswitcher:show({ filter = allscr }) end),
    awful.key({super, shift}, "Escape",
              function()
                lock_screen_show()
              end,
              {description = "lockscreen", group = "launcher"}),
    awful.key({super}, "F1", function()
      if dashboard_show then dashboard_show() end
      -- rofi_show()
    end, {description = "dashboard", group = "custom"}),
    awful.key({super}, "x", hotkeys_popup.show_help,
              {description = "show help", group = "awesome"}),
    awful.key({super, shift}, "e",
              function() machi.default_editor.start_interactive() end,
              {description = "layout edit", group = "window management"}),
    awful.key({super}, "e", function() machi.switcher.start(client.focus) end,
              {description = "layout edit", group = "window management"}),
    awful.key({super}, "w", function()

      if not client.focus then
        awful.spawn("firefox")
      else
        if not client.focus.fullscreen then
          awful.spawn("firefox")
        end
      end
    end,
              {description = "show main menu", group = "awesome"}),
    awful.key({super, shift}, "r", awesome.restart,
              {description = "reload awesome", group = "awesome"}),
    awful.key({super, shift}, "q",
              function() awesome.emit_signal("module::exit_screen:show") end,
              {description = "quit awesome", group = "awesome"}),
    awful.key({super}, "b",
              function()
                require("widgets.bar-anim")(s)
              end,
              {description = "toggle bar", group = "awesome"}), -- awful.key({ super }, "b", function() wibars_toggle() end,
    --           {description = "toggle dock", group = "awesome"}),
    -- awful.key({ super, shift       }, "b", function() s.mybar.visible = not s.mybar.visible end,
    --          {description = "toggle dashboard", group = "awesome"}),
    -- awful.key({ super }, "x",
    --          function ()
    --              awful.prompt.run {
    --                prompt       = "Run Lua code: ",
    --                textbox      = awful.screen.focused().mypromptbox.widget,
    --                exe_callback = awful.util.eval,
    --                history_path = awful.util.get_cache_dir() .. "/history_eval"
    --              }
    --          end,
    --          {description = "lua execute prompt", group = "awesome"}),
    awful.key({super}, "d", function()
      awful.spawn.with_shell("~/.config/rofi/launcher.sh")
    end, {description = "rofi launcher", group = "launcher"}),
    awful.key({super}, "semicolon",
              function() awful.spawn.with_shell("alacritty -e nvim") end,
              {description = "vim", group = "Application"}),
    awful.key({super}, "Return", function() 
        if not client.focus then
          awful.spawn(terminal)
        else
          if not client.focus.fullscreen then
            awful.spawn(terminal)
          end
        end
      end,
              {description = "open a terminal", group = "launcher"}),
    awful.key({super, ctrl}, "r", function()
      awesome.emit_signal("widget::screen_recorder:toggle")
    end, {description = "record screen with sound", group = "launcher"}),
    awful.key({super}, "r", function() awful.spawn("rofi -show run") end,
              {description = "run prompt", group = "launcher"}), 
    awful.key({ super, ctrl }, "p", function() 

        local amp = '&amp'..string.char(0x3B)
        local quot = '&quot'..string.char(0x3B)
        local atextbox = wibox.widget.textbox()
        awful.prompt.run {
            prompt       = '<b>Echo: </b>',
            bg_cursor    = '#ff0000',
            -- To use the default `rc.lua` prompt:
            --textbox      = mouse.screen.mypromptbox.widget,
            textbox      = atextbox,
            highlighter  = function(b, a)
                -- Add a random marker to delimitate the cursor
                local cmd = b..'ZZZCURSORZZZ'..a
                -- Find shell variables
                local sub = '<span foreground=\'#CFBA5D\'>%1</span>'
                cmd = cmd:gsub('($[A-Za-z][a-zA-Z0-9]*)', sub)
                -- Highlight ' && '
                sub = '<span foreground=\'#159040\'>%1</span>'
                cmd = cmd:gsub('( '..amp..amp..')', sub)
                -- Highlight double quotes
                local quote_pos = cmd:find('[^\\]'..quot)
                while quote_pos do
                    local old_pos = quote_pos
                    quote_pos = cmd:find('[^\\]'..quot, old_pos+2)
                    if quote_pos then
                        local content = cmd:sub(old_pos+1, quote_pos+6)
                        cmd = table.concat({
                                cmd:sub(1, old_pos),
                                '<span foreground=\'#2977CF\'>',
                                content,
                                '</span>',
                                cmd:sub(quote_pos+7, #cmd)
                        }, '')
                        quote_pos = cmd:find('[^\\]'..quot, old_pos+38)
                    end
                end
                -- Split the string back to the original content
                -- (ignore the recursive and escaped ones)
                local pos = cmd:find('ZZZCURSORZZZ')
                b,a = cmd:sub(1, pos-1), cmd:sub(pos+12, #cmd)
                return b,a
            end,
        }
    end,
             {description = "show the menubar", group = "launcher"}),
    -- awful.key({super}, "p", function() awful.spawn.with_shell("maimpick") end,
    --          {description = "screenshots", group = "launcher"}), -- Brightness
    awful.key({super}, "p", function()
      require("themes.default.notification.screen-shot").scrshot()
    end, {description = "screenshots", group = "launcher"}), -- Brightness
    awful.key({}, 'XF86MonBrightnessUp', function()
      awful.spawn('brightnessctl set +100', false)
      awesome.emit_signal('widget::brightness')
      awesome.emit_signal('module::brightness_osd:show', true)
    end, {description = 'increase brightness by 10%', group = 'hotkeys'}),
    awful.key({}, 'XF86MonBrightnessDown', function()
      awful.spawn('brightnessctl set 100-', false)
      awesome.emit_signal('widget::brightness')
      awesome.emit_signal('module::brightness_osd:show', true)
    end, {description = 'decrease brightness by 10%', group = 'hotkeys'}), -- Volume Control with volume keys
    awful.key({}, 'XF86AudioRaiseVolume', function()
      awful.spawn('amixer -D default sset Master 5%+', false)
      awesome.emit_signal('widget::volume')
      awesome.emit_signal('module::volume_osd:show', true)
    end, {description = 'increase volume up by 5%', group = 'hotkeys'}),
    awful.key({}, 'XF86AudioLowerVolume', function()
      awful.spawn('amixer -D default sset Master 5%-', false)
      awesome.emit_signal('widget::volume')
      awesome.emit_signal('module::volume_osd:show', true)
    end, {description = 'decrease volume up by 5%', group = 'hotkeys'}),
    awful.key({}, 'XF86AudioMute', function()
      awful.spawn('amixer -D default set Master 1+ toggle', false)
      awesome.emit_signal('widget::volume')
      awesome.emit_signal('module::volume_osd:show', true)
    end, {description = 'toggle mute', group = 'hotkeys'}), -- Media keys
    awful.key({}, "XF86AudioRewind",
              function() awful.spawn.with_shell("mpc -q seek -10") end,
              {description = "rewind song", group = "media"}),
    awful.key({}, "XF86AudioForward",
              function() awful.spawn.with_shell("mpc -q seek +10") end,
              {description = "forward song", group = "media"}),
    awful.key({}, "XF86AudioNext",
              function()
                awful.spawn.with_shell("mpc -q next")
              end,
              {description = "next song", group = "media"}),
    awful.key({}, "XF86AudioPrev",
              function() awful.spawn.with_shell("mpc -q prev") end,
              {description = "previous song", group = "media"}),
    awful.key({}, "XF86AudioPlay",
              function() awful.spawn.with_shell("mpc -q toggle") end,
              {description = "toggle pause/play", group = "media"}),
    awful.key({}, "XF86AudioStop",
              function() awful.spawn.with_shell("mpc -q stop") end,
              {description = "stop music", group = "media"}),
    awful.key({super}, "s", function() awful.spawn("scratchpad") end,
              {description = "scratchpad", group = "launcher"}),
    awful.key({super, shift}, "s",
              function() bling.module.window_swallowing.toggle() end,
              {description = "swallow", group = "launcher"}),
    awful.key({super, ctrl}, "space",
              function() awful.spawn("alacritty -e emoji -g 38x15") end,
              {description = "emojis", group = "launcher"})
  })

-- Tags related keybindings
awful.keyboard.append_global_keybindings(
  {
    awful.key({super}, "i", function() pomodoro:toggle() end),
    awful.key({super, shift}, "i", function() pomodoro:finish() end),
    awful.key({super, ctrl}, "i", function() pomodoro:reset() end)
    --    awful.key({ super,           }, "Left",   awful.tag.viewprev,
    --              {description = "view previous", group = "tag"}),
    --    awful.key({ super,           }, "Right",  awful.tag.viewnext,
    --              {description = "view next", group = "tag"}),
    --    awful.key({ super           }, "Tab", awful.tag.history.restore,
    --              {description = "go back", group = "tag"}),
  })

-- Focus related keybindings
awful.keyboard.append_global_keybindings(
  {

    awful.key({super}, "grave", function()
      awful.client.focus.history.previous()
      if client.focus then client.focus:raise() end
    end, {description = "go back", group = "client"}),
    --   awful.key({ super, ctrl }, "j", function () awful.screen.focus_relative( 1) end,
    --             {description = "focus the next screen", group = "screen"}),
    --   awful.key({ super, ctrl }, "k", function () awful.screen.focus_relative(-1) end,
    --             {description = "focus the previous screen", group = "screen"}),
    awful.key({super, shift}, "n", function()
      local c = awful.client.restore()
      -- Focus restored client
      if c then c:activate{raise = true, context = "key.unminimize"} end
    end, {description = "restore minimized", group = "client"})
  })

-- Layout related keybindings

function move_to_edge(c, direction)
  local old = c:geometry()
  local new = awful.placement[direction_translate[direction]](c, {
    honor_padding = true,
    honor_workarea = true,
    margins = beautiful.useless_gap * 2,
    pretend = true
  })
  if direction == "up" or direction == "down" then
    c:geometry({x = old.x, y = new.y})
  else
    c:geometry({x = new.x, y = old.y})
  end
end

function move_client_dwim(c, direction)
  if (awful.layout.get(mouse.screen) == awful.layout.suit.floating) then
    move_to_edge(c, direction)
  elseif awful.layout.get(mouse.screen) == awful.layout.suit.max then
    if direction == "up" or direction == "left" then
      awful.client.swap.byidx(-1, c)
    elseif direction == "down" or direction == "right" then
      awful.client.swap.byidx(1, c)
    end
  else
    awful.client.swap.bydirection(direction, c, nil)
  end
end

awful.keyboard.append_global_keybindings(
  {

    awful.key({super}, "u", awful.client.urgent.jumpto,
              {description = "jump to urgent client", group = "client"}),
    awful.key({super, alt}, "h", function() awful.tag.incncol(1, nil, true) end,
              {description = "increase the number of columns", group = "layout"}),
    awful.key({super, alt}, "l",
              function() awful.tag.incncol(-1, nil, true) end, {
      description = "decrease the number of columns",
      group = "layout"
    }), 
  -- awful.key({super}, "space", function() awful.layout.inc(1) end,
  --                 {description = "select next", group = "layout"}),
  --   awful.key({super, shift}, "space", function() awful.layout.inc(-1) end,
  --             {description = "select previous", group = "layout"})
  })

-- LuaFormatter off
awful.keyboard.append_global_keybindings(
  {
    awful.key {
      modifiers = {super},
      keygroup = "numrow",
      description = "only view tag",
      group = "tag",
      on_press = function(index)
        local screen = awful.screen.focused()
        local tag = screen.tags[index]
        if tag then tag:view_only() end
      end
    },
    awful.key {
      modifiers = {super, ctrl},
      keygroup = "numrow",
      description = "toggle tag",
      group = "tag",
      on_press = function(index)
        local screen = awful.screen.focused()
        local tag = screen.tags[index]
        if tag then awful.tag.viewtoggle(tag) end
      end
    },
    awful.key {
      modifiers = {super, shift},
      keygroup = "numrow",
      description = "move focused client to tag",
      group = "tag",
      on_press = function(index)
        if client.focus then
          local tag = client.focus.screen.tags[index]
          if tag then
            client.focus:move_to_tag(tag)
            tag:view_only()
          end
        end
      end
    },
    awful.key {
      modifiers = {super, ctrl, shift},
      keygroup = "numrow",
      description = "toggle focused client on tag",
      group = "tag",
      on_press = function(index)
        if client.focus then
          local tag = client.focus.screen.tags[index]
          if tag then client.focus:toggle_tag(tag) end
        end
      end
    },
    awful.key {
      modifiers = {super},
      keygroup = "numpad",
      description = "select layout directly",
      group = "layout",
      on_press = function(index)
        local t = awful.screen.focused().selected_tag
        if t then t.layout = t.layouts[index] or t.layout end
      end
    }
  })
-- LuaFormatter on
client.connect_signal("request::default_mousebindings", function()
  awful.mouse.append_client_mousebindings(
    {
      awful.button({}, 1, function(c) c:activate{context = "mouse_click"} end),
      awful.button({super}, 1, function(c)
        c:activate{context = "mouse_click", action = "mouse_move"}
      end), awful.button({super}, 3, function(c)
        c:activate{context = "mouse_click", action = "mouse_resize"}
      end)
    })
end)

client.connect_signal("request::default_keybindings", function()
  awful.keyboard.append_client_keybindings(
    {

      awful.key({super, shift}, "f", function(c)
        local layout_is_floating = (awful.layout.get(mouse.screen) ==
                                     awful.layout.suit.floating)
        if not layout_is_floating then
          awful.client.floating.toggle()
          c.above = not c.above
        end
      end, {description = "toggle floating", group = "client"}),
      awful.key({super, shift}, "j", function(c)
        local layout_is_floating = (awful.layout.get(mouse.screen) ==
                                     awful.layout.suit.floating)
        if c.floating or layout_is_floating then
          anim.animate {
            start_val = c.y,
            end_val = c.y + 40,
            prop_table = c,
            prop_name = "y",
            duration = 0.5,
            easing = easing.outExpo
          } -- make an animate function
          -- c:relative_move(0, 40, 0, 0)
        else
          move_client_dwim(c, "down")
        end
      end), awful.key({super, shift}, "k", function(c)
        local layout_is_floating = (awful.layout.get(mouse.screen) ==
                                     awful.layout.suit.floating)
        if c.floating or layout_is_floating then
          anim.animate {
            start_val = c.y,
            end_val = c.y - 40,
            prop_table = c,
            prop_name = "y",
            duration = 0.5,
            easing = easing.outExpo
          }
          -- c:relative_move(0, -40, 0, 0)
        else
          move_client_dwim(c, "up")
        end
      end), awful.key({super, shift}, "h", function(c)
        local layout_is_floating = (awful.layout.get(mouse.screen) ==
                                     awful.layout.suit.floating)
        if c.floating or layout_is_floating then
          anim.animate {
            start_val = c.x,
            end_val = c.x - 40,
            prop_table = c,
            prop_name = "x",
            duration = 0.5,
            easing = easing.outExpo
          }
          -- c:relative_move(-40, 0, 0, 0)
        else
          move_client_dwim(c, "left")
        end
      end), awful.key({super, shift}, "l", function(c)
        local layout_is_floating = (awful.layout.get(mouse.screen) ==
                                     awful.layout.suit.floating)
        if c.floating or layout_is_floating then

          anim.animate {
            start_val = c.x,
            end_val = c.x + 40,
            prop_table = c,
            prop_name = "x",
            duration = 0.5,
            easing = easing.outExpo
          }
          -- c:relative_move(40, 0, 0, 0)
        else
          move_client_dwim(c, "right")
        end
      end), 
      awful.key({super, alt}, "j", function(c)
        awful.client.cycle(true)
        client.focus:raise()
      end, {description = "focus down", group = "client"}),
      awful.key({super}, "j", function(c)
        if not c.fullscreen then
          awful.client.focus.bydirection("down")
          client.focus:raise()
        end
      end, {description = "focus down", group = "client"}),
      awful.key({super}, "k", function(c)
        if not c.fullscreen then
          awful.client.focus.bydirection("up")
          client.focus:raise()
        end
      end, {description = "focus up", group = "client"}),
      awful.key({super}, "h", function(c)
        if not c.fullscreen then
          awful.client.focus.bydirection("left")
          client.focus:raise()
        end
      end, {description = "focus left", group = "client"}),
      awful.key({super}, "l", function(c)
        if not c.fullscreen then
          awful.client.focus.bydirection("right")
          client.focus:raise()
        end
        -- bling.module.flash_focus.flashfocus(client.focus)
      end, {description = "focus right", group = "client"}),
      awful.key({super}, "f", function(c)
        -- if not c.fullscreen then
        --   if not naughty.suspended then
        --     naughty.suspended = true
        --     c.fullscreen = true
        --     c:raise()
        --   end
        -- else
        --   if naughty.suspended then
        --     naughty.suspended = false
        --     c.fullscreen = false
        --     c:raise()
        --   end
        -- end

        if not c.fullscreen then
          naughty.destroy_all_notifications(nil, 1)
          c.fullscreen = not c.fullscreen
          c:raise()
        else
          c.fullscreen = not c.fullscreen
          c:raise()
        end
      end, {description = "toggle fullscreen", group = "client"}),
      awful.key({super}, "q", function(c) c:kill() end,
                {description = "close", group = "client"}),
      awful.key({super, ctrl}, "space", awful.client.floating.toggle,
                {description = "toggle floating", group = "client"}),
      awful.key({super, ctrl}, "Return",
                function(c) c:swap(awful.client.getmaster()) end,
                {description = "move to master", group = "client"}),
      awful.key({super}, "o", function(c) c:move_to_screen() end,
                {description = "move to screen", group = "client"}),
      awful.key({super, ctrl}, "t", function(c) c.ontop = not c.ontop end,
                {description = "toggle keep on top", group = "client"}),
      awful.key({super, ctrl}, "j", function(c)
        local layout_is_floating = (awful.layout.get(mouse.screen) ==
                                     awful.layout.suit.floating)
        if c.floating or layout_is_floating then
          c:relative_move(0, 0, 0, 40)
        else
          awful.client.incwfact(0.1)
        end
      end, {description = "increase master height factor", group = "layout"}),
      awful.key({super, ctrl}, "k", function(c)
        local layout_is_floating = (awful.layout.get(mouse.screen) ==
                                     awful.layout.suit.floating)
        if c.floating or layout_is_floating then
          c:relative_move(0, 0, 0, -40)
        else
          awful.client.incwfact(-0.1)
        end
      end, {description = "decrease master height factor", group = "layout"}),
      awful.key({super, ctrl}, "l", function(c)
        local layout_is_floating = (awful.layout.get(mouse.screen) ==
                                     awful.layout.suit.floating)
        if c.floating or layout_is_floating then
          c:relative_move(0, 0, 40, 0)
        else
          awful.tag.incmwfact(0.05)
        end
      end, {description = "increase master width factor", group = "layout"}),
      awful.key({super, ctrl}, "h", function(c)
        local layout_is_floating = (awful.layout.get(mouse.screen) ==
                                     awful.layout.suit.floating)
        if c.floating or layout_is_floating then
          c:relative_move(0, 0, -40, 0)
        else
          awful.tag.incmwfact(-0.05)
        end
      end, {description = "decrease master width factor", group = "layout"}), -- Toggle titlebar (for focused client only)
      awful.key({super}, "t", function(c)
        -- Don't toggle if titlebars are used as borders
        if not beautiful.titlebars_imitate_borders then
          awful.titlebar.toggle(c)
        end
      end, {description = "toggle titlebar", group = "client"}), -- Toggle titlebar (for all visible clients in selected tag)
      awful.key({super, shift}, "t", function(c)
        -- local s = awful.screen.focused()
        local clients = awful.screen.focused().clients
        for _, c in pairs(clients) do
          -- Don't toggle if titlebars are used as borders
          awful.titlebar.toggle(c)
        end
      end, {description = "toggle titlebar", group = "client"}),
      awful.key({super}, "n", function(c)
        -- The client currently has the input focus, so it cannot be
        -- minimized, since minimized clients can't have the focus.
        c.minimized = true
      end, {description = "minimize", group = "client"}),
      awful.key({super, ctrl}, "n", function()
        local c = awful.client.restore()
        -- Focus restored client
        if c then client.focus = c end
      end, {description = "restore minimized", group = "client"}),
      awful.key({super}, "m",
                function() awful.spawn("alacritty --class ncmpcpp,ncmpcpp -e ncmpcpp") end,
                {description = "(un)maximize", group = "client"})
    })
end)

