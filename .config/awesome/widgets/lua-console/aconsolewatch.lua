local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")

local tableutils = require("widgets.lua-console.tableutils")
local stringutils = require("widgets.lua-console.stringutils")
local easing = require("utils.anim.easing")
local anim = require("utils.anim")

local aconsolewatch = {}

function aconsolewatch.create(args)
  local code = args.code or nil
  local index = args.index or "?"

  local code_split = stringutils.split(code, ".:")
  local code_maj = gears.string.xml_escape(code_split[#code_split])
  local code_min = gears.string.xml_escape(code:sub(1, -#code_maj - 1))

  local func, err = load("return (" .. code .. ")", "Lua console (watch)", "t")
  if err then
    return nil, err
  end

  local index_text = wibox.widget{
    text = "#" .. index .. ": ",
    font = "sans 12",
    widget = wibox.widget.textbox,
  }

  local watch_result_text = wibox.widget{
    font = "Scientifica 8",
    widget = wibox.widget.textbox,
  }

  local function update_result_text()
    local val = func()
    local val_str
    if type(val) == "table" then
      val_str = tableutils.to_string(val)
    else
      val_str = tostring(val)
    end
    watch_result_text.text = type(val) .. ": " .. val_str

    return true
  end
  gears.timer.start_new(0.1, update_result_text)

  local watch_popup = awful.popup{
    widget = {
      {
        {
          index_text,
          {
            markup = "<span color='#ffffff99'>" .. code_min .. "</span><span font='12'>" .. code_maj .. "</span>",
            font = "sans 8",
            widget = wibox.widget.textbox,
          },
          layout = wibox.layout.fixed.horizontal,
        },
        watch_result_text,
        layout = wibox.layout.fixed.vertical,
      },
      margins = 10,
      widget = wibox.container.margin
    },
    ontop = true,
    x = 512 + 32,
    y = 32,
  }

  watch_popup.set_index = function(new_index)
    index_text.text = "#" .. new_index .. ": "
  end

  -- Animate in
  anim.animate{
    start_val = 512 - 64,
    end_val = 512 + 32,
    prop_table = watch_popup,
    prop_name = "x",
    duration = 0.5,
    easing = easing.outExpo,
  }
  anim.animate{
    start_val = 0,
    end_val = 0.95,
    prop_table = watch_popup,
    prop_name = "opacity",
    duration = 0.9,
    easing = easing.outExpo,
  }

  return watch_popup
end

return aconsolewatch
