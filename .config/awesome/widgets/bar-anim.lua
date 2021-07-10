local beautiful = require("beautiful")
local awestore = require("awestore")

local res = function(s)
  -- s.statusbar.x = 0
  -- s.statusbar.y = -2 * beautiful.bar_height
  local panel_in_anim = awestore.tweened(-beautiful.bar_height, {
    duration = 300,
    easing = awestore.easing.circ_in_out
  })

  local panel_out_anim = awestore.tweened(0, {
    duration = 300,
    easing = awestore.easing.circ_in_out
  })


  if not s.statusbar.visible then
    panel_in_anim:subscribe(function(y) s.statusbar.y = y end)

    s.statusbar.visible = true
    panel_in_anim:set(0)

    local unsub_panel
    unsub_panel = panel_in_anim.ended:subscribe(
                    function()
        unsub_panel()
      end)
  else
    panel_out_anim:subscribe(function(y) s.statusbar.y = y end)
    panel_out_anim:set(-beautiful.bar_height)

    local unsub_panel
    unsub_panel = panel_out_anim.ended:subscribe(
                    function()
        unsub_panel()
        s.statusbar.visible = false -- why here(only works here)?
      end)
  end

end

return res
