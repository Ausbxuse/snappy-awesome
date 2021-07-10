local awful = require("awful")
local wibox = require("wibox")

local tableutils = require("widgets.lua-console.tableutils")
local stringutils = require("widgets.lua-console.stringutils")
local anim = require("utils.anim")
local easing = require("utils.anim.easing")
local aconsolewatch = require("widgets.lua-console.aconsolewatch")
local statics = require("widgets.lua-console.statics")

local aluaconsole = {}

aluaconsole.watches = {}

aluaconsole.log_lines = {}
for _ = 1, 30 do
  table.insert(aluaconsole.log_lines, " ")
end

aluaconsole.log = wibox.widget{
  text = "",
  font = statics.mono_font,
  widget = wibox.widget.textbox,
}

function aluaconsole.update_log()
  aluaconsole.log.text = table.concat(aluaconsole.log_lines, "\n")
end

function aluaconsole.object_to_string(obj)
  if type(obj) == "table" then
    return tableutils.to_string(obj)
  else
    return tostring(obj)
  end
end

function aluaconsole.run_code(code)
  aluaconsole.add_log_line("> " .. code)

  local func, err = load("return (" .. code .. ")", "Lua console (statement)", "t")
  if func then
    local _, ret = pcall(func)
    aluaconsole.add_log_line(aluaconsole.object_to_string(ret))
  else
    -- If it fails, try see if it's an statement
    local stmt_func, stmt_err = load(code, "Lua console (statement)", "t")
    if stmt_func then
      local _, ret = pcall(stmt_func)
      aluaconsole.add_log_line(aluaconsole.object_to_string(ret))
    else
      aluaconsole.add_log_line(stmt_err)
      aluaconsole.add_log_line(err)
    end
  end
end

function aluaconsole.add_log_line(line)
  local lines = stringutils.split(line, "\n")

  for _, v in ipairs(lines) do
    table.remove(aluaconsole.log_lines, 1)
    table.insert(aluaconsole.log_lines, v)
  end

  aluaconsole.update_log()
end

function aluaconsole.show_help()
  aluaconsole.add_log_line("= Help ===================================================")
  aluaconsole.add_log_line(":req                 require many awesome and user modules")
  aluaconsole.add_log_line(":watch <var>         keep track of a variable")
  aluaconsole.add_log_line(":delwatch <index>    delete a watch")
  aluaconsole.add_log_line(":clear               clear the console")
  aluaconsole.add_log_line(":help                print this help text")
  aluaconsole.add_log_line(":q                   hide this console")
  aluaconsole.add_log_line("==========================================================")
end

local function str_starts_with(str, start)
  return str:sub(1, #start) == start
end

function aluaconsole.update_watch_positions(_)
  local offset = 32

  for _, v in pairs(aluaconsole.watches) do
    if v.y ~= offset then
      anim.animate{
        start_val = v.y,
        end_val = offset,
        prop_table = v,
        prop_name = "y",
        duration = 0.5,
        easing = easing.outExpo,
      }
    end

    offset = offset + v.height + 16
  end
end

function aluaconsole.add_watch(code)
  local watch = aconsolewatch.create{
    ["code"] = code,
    index = #aluaconsole.watches + 1,
  }

  watch:connect_signal("property::height", aluaconsole.update_watch_positions)

  table.insert(aluaconsole.watches, watch)
end

function aluaconsole.del_watch(index)
  aluaconsole.watches[index].visible = false
  table.remove(aluaconsole.watches, index)

  -- Redo watch indices
  for k, v in pairs(aluaconsole.watches) do
    v.set_index(k)
  end

  aluaconsole.update_watch_positions(nil)
end

aluaconsole.prompt = awful.widget.prompt{
  prompt = "> ",
  font = statics.mono_font,
  exe_callback = function(code)
    if code == ":req" then
      aluaconsole.run_code('awful = require("awful")')
      aluaconsole.run_code('gears = require("gears")')
      aluaconsole.run_code('wibox = require("wibox")')
      aluaconsole.run_code('beautiful = require("beautiful")')
      aluaconsole.run_code('naughty = require("naughty")')
      aluaconsole.run_code('easing = require("easing")')
      aluaconsole.run_code('statics = require("statics")')
      aluaconsole.run_code('mathutils = require("mathutils")')
      aluaconsole.run_code('tableutils = require("tableutils")')
      aluaconsole.run_code('stringutils = require("stringutils")')
      aluaconsole.run_code('anim = require("anim")')
    elseif code == ":clear" then
      for _ = 1, 30 do
        aluaconsole.add_log_line(" ")
      end
    elseif str_starts_with(code, ":watch") then
      aluaconsole.add_watch(code:sub(8))
    elseif str_starts_with(code, ":delwatch") then
      aluaconsole.del_watch(tonumber(code:sub(11)))
    elseif code == ":help" then
      aluaconsole.show_help()
    elseif code == ":q" then
      aluaconsole.hide()
      return
    else
      aluaconsole.run_code(code)
    end

    return aluaconsole.prompt:run()
  end
}

aluaconsole.console_popup = awful.popup{
  widget = {
    {
      {
        text = "Lua console",
        font = statics.font_title,
        widget = wibox.widget.textbox,
      },
      {
        aluaconsole.log,
        bg = "#000000",
        opacity = 0.5,
        widget = wibox.container.background,
        forced_width = 512,
      },
      aluaconsole.prompt,
      layout = wibox.layout.fixed.vertical,
    },
    margins = 10,
    widget = wibox.container.margin
  },
  ontop = true,
  visible = false,
  y = 32,
}

function aluaconsole.show()
  aluaconsole.console_popup.visible = true
  aluaconsole.prompt:run()

  anim.animate{
    start_val = -96,
    end_val = 0,
    prop_table = aluaconsole.console_popup,
    prop_name = "x",
    duration = 0.5,
    easing = easing.outExpo,
  }
  anim.animate{
    start_val = 0,
    end_val = 0.95,
    prop_table = aluaconsole.console_popup,
    prop_name = "opacity",
    duration = 0.5,
    easing = easing.outExpo,
  }

  for _, v in pairs(aluaconsole.watches) do
    anim.animate{
      start_val = v.x,
      end_val = 512 + 32,
      prop_table = v,
      prop_name = "x",
      duration = 0.5,
      easing = easing.outExpo,
    }
    anim.animate{
      start_val = v.opacity,
      end_val = 0.95,
      prop_table = v,
      prop_name = "opacity",
      duration = 0.5,
      easing = easing.outExpo,
    }

    v.input_passthrough = false
  end
end

function aluaconsole.hide()
  aluaconsole.console_popup.visible = false

  for _, v in pairs(aluaconsole.watches) do
    anim.animate{
      start_val = v.x,
      end_val = 0,
      prop_table = v,
      prop_name = "x",
      duration = 0.5,
      easing = easing.outExpo,
    }
    anim.animate{
      start_val = v.opacity,
      end_val = 0.5,
      prop_table = v,
      prop_name = "opacity",
      duration = 0.5,
      easing = easing.outExpo,
    }
    v.input_passthrough = true
  end
end

function aluaconsole.toggle_visibility()
  if aluaconsole.console_popup.visible then
    aluaconsole.hide()
  else
    aluaconsole.show()
  end
end

function aluaconsole.init()
  print("Initializing aluaconsole")
  aluaconsole.show_help()
end

return aluaconsole
