local wibox = require('wibox')
local gears = require('gears')
local awful = require('awful')
local beautiful = require('beautiful')
local spawn = awful.spawn
local dpi = beautiful.xresources.apply_dpi
local icons = require('icons')

local osd_value = wibox.widget {
  text = '0%',
  font = 'Inter Bold 12',
  align = 'center',
  valign = 'center',
  widget = wibox.widget.textbox
}

local slider_osd = wibox.widget {
  nil,
  {
    id = 'vol_osd_slider',
    bar_shape = gears.shape.rounded_rect,
    bar_height = dpi(6),
    bar_color = '#ffffff20',
    bar_active_color = '#f2f2f2EE',
    handle_color = '#ffffff',
    handle_shape = gears.shape.circle,
    handle_width = dpi(6),
    handle_border_color = '#00000012',
    handle_border_width = dpi(0),
    maximum = 100,
    widget = wibox.widget.slider
  },
  nil,
  expand = 'none',
  layout = wibox.layout.align.vertical
}

local vol_osd_slider = slider_osd.vol_osd_slider

vol_osd_slider:connect_signal('property::value', function()
  local volume_level = vol_osd_slider:get_value()
  -- awful.spawn('amixer -D default sset Master ' .. volume_level .. '%', false)

  -- Update textbox widget text
  osd_value.text = volume_level .. '%'

  -- Update the volume slider if values here change
  awesome.emit_signal('widget::volume:update', volume_level)

  if awful.screen.focused().show_vol_osd then
    awesome.emit_signal('module::volume_osd:show', true)
  end
end)

vol_osd_slider:connect_signal('button::press', function()
  awful.screen.focused().show_vol_osd = true
end)

vol_osd_slider:connect_signal('mouse::enter', function()
  awful.screen.focused().show_vol_osd = true
end)

-- The emit will come from the volume-slider
awesome.connect_signal('module::volume_osd',
                       function(volume) vol_osd_slider:set_value(volume) end)

local cat_image = wibox.widget{
  widget = wibox.widget.imagebox,
  --resize = true,
  image = icons.cat
}

local cat_image_layout = wibox.widget {
  widget = wibox.container.margin,
  top = dpi(38),
  left = dpi(38),
  right = dpi(38),
  bottom = dpi(30),
  cat_image
}

local volume_slider_osd = wibox.widget {
  slider_osd,
  --spacing = dpi(24),
  layout = wibox.layout.fixed.horizontal
}

local osd_height = dpi(180)
local osd_width = dpi(170)
local osd_margin = dpi(100)

screen.connect_signal('request::desktop_decoration', function(s)
  local s = s or {}
  s.show_vol_osd = false

  -- Create the box
  s.volume_osd_overlay = awful.popup {
    widget = {
      -- Removing this block will cause an error...
    },
    ontop = true,
    visible = false,
    type = 'notification',
    screen = s,
    height = osd_height,
    width = osd_width,
    maximum_height = osd_height,
    maximum_width = osd_width,
    offset = dpi(5),
    shape = gears.shape.rectangle,
    bg = beautiful.transparent,
    preferred_anchors = 'middle',
    preferred_positions = {'left', 'right', 'top', 'bottom'}
  }

  s.volume_osd_overlay:setup{
    {
      cat_image_layout,
      {
        widget = wibox.container.margin,
        left = dpi(8),
        right = dpi(8),
        volume_slider_osd
      },
      layout = wibox.layout.fixed.vertical
    },
    bg = "#00000099",
    shape = gears.shape.rounded_rect,
    widget = wibox.container.background()
  }

  -- Reset timer on mouse hover
  s.volume_osd_overlay:connect_signal('mouse::enter', function()
    awful.screen.focused().show_vol_osd = true
    awesome.emit_signal('module::volume_osd:rerun')
  end)
end)

local hide_osd = gears.timer {
  timeout = 2,
  autostart = true,
  callback = function()
    local focused = awful.screen.focused()
    focused.volume_osd_overlay.visible = false
    focused.show_vol_osd = false
  end
}

awesome.connect_signal('module::volume_osd:rerun', function()
  if hide_osd.started then
    hide_osd:again()
  else
    hide_osd:start()
  end
end)

local placement_placer = function()
  local focused = awful.screen.focused()
  local volume_osd = focused.volume_osd_overlay

  awful.placement.bottom(volume_osd, {
    margins = {left = 0, right = 0, top = 0, bottom = osd_margin},
    honor_workarea = true
  })
end

awesome.connect_signal('module::volume_osd:show', function(bool)
  placement_placer()
  awful.screen.focused().volume_osd_overlay.visible = bool
  if bool then
    awesome.emit_signal('module::volume_osd:rerun')
    awesome.emit_signal('module::brightness_osd:show', false)
  else
    if hide_osd.started then hide_osd:stop() end
  end
end)
local slider = wibox.widget {
  nil,
  {
    id = 'volume_slider',
    bar_shape = gears.shape.rounded_rect,
    bar_height = dpi(2),
    bar_color = '#ffffff20',
    bar_active_color = '#f2f2f2EE',
    handle_color = '#ffffff',
    handle_shape = gears.shape.circle,
    handle_width = dpi(15),
    handle_border_color = '#00000012',
    handle_border_width = dpi(1),
    maximum = 100,
    widget = wibox.widget.slider
  },
  nil,
  forced_height = dpi(24),
  expand = 'none',
  layout = wibox.layout.align.vertical
}

local volume_slider = slider.volume_slider

volume_slider:connect_signal('property::value', function()
  local volume_level = volume_slider:get_value()

  -- spawn('amixer -D default sset Master ' .. 
  --	volume_level .. '%',
  --	false
  -- )

  -- Update volume osd
  awesome.emit_signal('module::volume_osd', volume_level)
end)

volume_slider:buttons(gears.table.join(awful.button({}, 4, nil, function()
  if volume_slider:get_value() > 100 then
    volume_slider:set_value(100)
    return
  end
  volume_slider:set_value(volume_slider:get_value() + 5)
end), awful.button({}, 5, nil, function()
  if volume_slider:get_value() < 0 then
    volume_slider:set_value(0)
    return
  end
  volume_slider:set_value(volume_slider:get_value() - 5)
end)))

local update_slider = function()
  awful.spawn.easy_async_with_shell([[bash -c "check-vol"]],
                                    function(stdout)
    local vol = stdout:gsub('%\n', '')
    -- local muted = string.match(stdout, 'off')
    if vol == 'muted' then
      cat_image:set_image(icons.cat)
      volume_slider:set_value(0)
    else
      vol = tonumber(vol)
      if vol == 0 then
        cat_image:set_image(icons.cat)
      elseif vol > 0 and vol <= 25  then
        cat_image:set_image(icons.cat20)
      elseif vol > 25 and vol <= 50  then
        cat_image:set_image(icons.cat40)
      elseif vol > 50 and vol <= 75 then
        cat_image:set_image(icons.cat60)
      elseif vol > 75 then
        cat_image:set_image(icons.cat80)
      end
      volume_slider:set_value(vol)
    end
  end)
end

-- Update on startup
update_slider()

local action_jump = function()
  local sli_value = volume_slider:get_value()
  local new_value = 0

  if sli_value >= 0 and sli_value < 50 then
    new_value = 50
  elseif sli_value >= 50 and sli_value < 100 then
    new_value = 100
  else
    new_value = 0
  end
  volume_slider:set_value(new_value)
end

-- The emit will come from the global keybind
awesome.connect_signal('widget::volume', function() update_slider() end)

-- The emit will come from the OSD
awesome.connect_signal('widget::volume:update', function(value)
  volume_slider:set_value(tonumber(value))
end)
