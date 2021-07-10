local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local Taglist = function(s)
  local icon_ratio = 0.8/1.645
  return awful.widget.taglist {
    screen = s,
    filter = awful.widget.taglist.filter.all,
    style = {shape = function(cr, w, h) gears.shape.rounded_rect(cr, w, h, dpi(6/1.645)) end},
    layout = {
      spacing = dpi(10/1.645),
      -- spacing_widget = {
      --     color  = '#dddddd',
      --     shape  = gears.shape.powerline,
      --     widget = wibox.widget.separator,
      -- },
      layout = wibox.layout.fixed.horizontal
    },
    widget_template = {
      {
        {
          -- {
          --     {
          --         {
          --             id     = 'index_role',
          --             widget = wibox.widget.textbox,
          --         },
          --         margins = 1,
          --         widget  = wibox.container.margin,
          --     },
          --     --bg     = '#dddddd',
          --     --shape  = gears.shape.circle,
          --     widget = wibox.container.background,
          -- },
          {
            {id = 'icon_role', resize = true, widget = wibox.widget.imagebox},
            forced_height = beautiful.bar_height * (1 - icon_ratio),
            -- forced_width = dpi(30),
            halign = 'center',
            valign = 'center',
            -- margins = dpi(0),
            widget = wibox.container.place
          },
          {
            id = 'text_role',
            -- forced_height = beautiful.bar_height * icon_ratio,
            -- forced_width = dpi(40),
            -- halign = 'center',
            -- valign = 'center',
            widget = wibox.widget.textbox
          },
          layout = wibox.layout.stack
        },
        left = dpi(10/1.645),
        right = dpi(10/1.645),
        shape = function(cr, w, h) gears.shape.rounded_rect(cr, w, h, dpi(6/1.645)) end,
        widget = wibox.container.margin
      },
      id = 'background_role',
      widget = wibox.container.background,
      -- Add support for hover colors and an index label
      create_callback = function(self, c3, index, objects) -- luacheck: no unused args
        -- self:get_children_by_id('index_role')[1].markup = '<b> '..index..' </b>'
        -- self.bg = beautiful.transparent
        self:connect_signal('mouse::enter', function()
          if #c3:clients() > 0 then
              -- BLING: Update the widget with the new tag
              awesome.emit_signal("bling::tag_preview::update", c3)
              -- BLING: Show the widget
              awesome.emit_signal("bling::tag_preview::visibility", s, true)
          end

          if self.bg ~= '#ffffff22' or self.bg ~= beautiful.taglist_bg_focus then
            self.backup = self.bg
            self.has_backup = true
          end
          self.bg = '#ffffff22'
        end)


        self:connect_signal('mouse::leave', function()
          awesome.emit_signal("bling::tag_preview::visibility", s, false)
          if self.has_backup then self.bg = self.backup end
        end)
        -- self:connect_signal('button::press', function()
        --   self.backup = self.bg
        --   self.has_backup = true
        --   self.bg = beautiful.bg_default
        -- end)
        -- self:connect_signal('button::release', function()
        --   if self.has_backup then self.bg = self.backup end
        -- end)
      end
      -- update_callback = function(self, c3, index, objects) --luacheck: no unused args
      --     self:get_children_by_id('index_role')[1].markup = '<b> '..index..' </b>'
      -- end,
    },
    buttons = {
      awful.button({}, 1, function(t) t:view_only() end),
      awful.button({modkey}, 1, function(t)
        if client.focus then client.focus:move_to_tag(t) end
      end), awful.button({}, 3, awful.tag.viewtoggle),
      awful.button({modkey}, 3, function(t)
        if client.focus then client.focus:toggle_tag(t) end
      end), awful.button({}, 4, function(t) awful.tag.viewprev(t.screen) end),
      awful.button({}, 5, function(t) awful.tag.viewnext(t.screen) end)
    }
  }
end

return Taglist
