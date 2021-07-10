local awful = require('awful')
local wibox = require('wibox')
local dpi = require('beautiful').xresources.apply_dpi
local gears = require('gears')
local clickable_container = require('utils.clickable-container')
--- Common method to create buttons.
-- @tab buttons
-- @param object
-- @treturn table

local common = require("awful.widget.common")
local tasklist_buttons = awful.util.table.join(
                           awful.button({}, 1, function(c)
    c.minimized = false
    if not c:isvisible() and c.first_tag then c.first_tag:view_only() end
    -- This will also un-minimize
    -- the client, if needed
    _G.client.focus = c
    c:raise()
  end), awful.button({}, 3, function(c)
    if c == _G.client.focus then
      c.minimized = true
    else
      -- Without this, the following
      -- :isvisible() makes no sense
      c.minimized = false
      if not c:isvisible() and c.first_tag then c.first_tag:view_only() end
      -- This will also un-minimize
      -- the client, if needed
      _G.client.focus = c
      c:raise()
    end
  end), awful.button({}, 2, function(c) c.kill(c) end), awful.button({}, 4,
                                                                     function()
    awful.client.focus.byidx(1)
  end), awful.button({}, 5, function() awful.client.focus.byidx(-1) end))

local widget = function(s, filter)
  return awful.widget.tasklist {
    screen = s,
    filter = filter,
    buttons = tasklist_buttons,
    style = {
      border_width = 1,
      border_color = '#777777',
      shape = function(cr, w, h) gears.shape.rounded_rect(cr, w, h, dpi(6/1.645)) end
    },
    layout = {
      spacing = 10,
      layout = wibox.layout.flex.horizontal
    },
    -- Notice that there is *NO* wibox.wibox prefix, it is a template,
    -- not a widget instance.
    update_function = common.list_update,
    widget_template = {
      {
        {
          {
              {id = 'icon_role', widget = wibox.widget.imagebox},
              margins = 2,
              widget = wibox.container.margin
          },
          top = 1,
          bottom = 1,
          left = 8,
          right = 8,
          widget = wibox.container.margin
        },
        widget = clickable_container
      },
      id = 'background_role',
      widget = wibox.container.background
      }
    }
end

local TaskList = function(s, filter)
  return wibox.widget {
    widget(s, filter),
    top = dpi(4/1.645),
    bottom = dpi(4/1.645),
    widget = wibox.container.margin
  }
end

return TaskList
