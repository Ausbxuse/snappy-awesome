local gears = require("gears")

local easing = require("utils.anim.easing")

local anim = {}

anim.active = {}

local refresh_rate = 60

local refresh_delta = 1 / refresh_rate

function anim.on_update()
  -- Iterate backwards because we remove stuff from the table while iterating
  for i = #anim.active, 1, -1 do
    local obj = anim.active[i]

    -- Remove from the active list if we're beyond the duration
    if obj.time > obj.duration then
      table.remove(anim.active, i)
    end

    obj.time = obj.time + refresh_delta
    obj.prop_table[obj.prop_name] = obj.easing(
      math.min(obj.time, obj.duration),
      obj.start_val,
      obj.end_val - obj.start_val,
      obj.duration
    )
  end

  return #anim.active > 0
end

function anim.start_timer()
  if #anim.active == 1 then
    gears.timer.start_new(refresh_delta, anim.on_update)
  end
end

function anim.animate(args)
  local obj = {
    start_val = args.start_val or 0,
    end_val = args.end_val or 1,
    prop_table = args.prop_table or nil,
    prop_name = args.prop_name or nil,
    duration = args.duration or 1,
    time = args.time or 0,
    easing = args.easing or easing.linear,
  }

  local toremove = nil
  for k, v in pairs(anim.active) do
    if v.prop_table == args.prop_table and v.prop_name == args.prop_name then
      toremove = k
      break
    end
  end

  if toremove then
    table.remove(anim.active, toremove)
  end

  table.insert(anim.active, obj)

  obj.prop_table[obj.prop_name] = obj.start_val

  anim.start_timer()
end

return anim
