-- TODO: fix dot position and size so that it looks like a dot
-- TODO: add popup options for killing clients/focus bg color
-- TODO: add launcher in newtasklist pinned_apps
local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local naughty = require("naughty")

local class_client_list = {}
local tasklist_height = beautiful.bar_height
-- local pinned_apps = beautiful.pinned_apps -- TODO
local apps_to_icon = beautiful.app_to_icon

-- helper

local search_class_id = function(list, target)
    local index = {}
    for k, v in pairs(list) do index[v[1].class] = k end
    return index[target]
end

local search_id = function(list, target)
    local index = {}
    for k, v in pairs(list) do index[v] = k end
    return index[target]
end

local search_focus_id = function(instance_list)
    for i, c in ipairs(instance_list) do
        if c == client.focus then return i end
    end
    return nil
end

local has = function(list, element)
    for _, e in ipairs(list) do
        if (e[1].class == element) then return true end
    end
    return false
end

-- objects

local default_icon = wibox.widget {
    widget = wibox.widget.imagebox,
    image = beautiful.app_to_icon["alacritty"] -- TODO: change to a questionmark icon
}

local sep = wibox.widget {
    widget = wibox.container.margin,
    top = dpi(4),
    bottom = dpi(4),
    left = dpi(3),
    right = dpi(3),
    {
        widget = wibox.widget.separator,
        shape = function(cr, w, h)
            gears.shape.rounded_rect(cr, w, h, dpi(30))
        end,
        span_ratio = 0.9,
        orientation = "vertical",
        opacity = 0.8,
        forced_width = dpi(0.7)
    }
}

local dot = function(state)
    local normal_color = beautiful.fg_normal
    local focus_color = beautiful.taglist_fg_focus
    local hidden_color = beautiful.bg_normal
    local floating_color = beautiful.blue
    local wdg = wibox.widget {
        widget = wibox.container.background,
        forced_width = tasklist_height / 10,
        forced_height = tasklist_height / 10,
        shape = gears.shape.circle
    }

    if state == "focus" then
        wdg.bg = focus_color
    elseif state == "hidden" then
        wdg.bg = hidden_color
    elseif state == "floating" then
        wdg.bg = floating_color
    else
        wdg.bg = normal_color
    end

    return wdg
end

local clickable_pinned_icon = function(class)
    local container = wibox.widget {
        widget = wibox.container.background,
        shape = function(cr, w, h)
            gears.shape.rounded_rect(cr, w, h, dpi(4))
        end,
        {
            widget = wibox.container.margin,
            margins = dpi(3),
            {
                widget = wibox.widget.imagebox,
                resize = true,
                image = apps_to_icon[class]
            }
        }
    }
    local old_cursor, old_wibox

    container:connect_signal('mouse::enter', function()
        container.bg = '#ffffff11'
        local w = mouse.current_wibox
        if w then
            old_cursor, old_wibox = w.cursor, w
            -- w.cursor = 'hand2'
        end
    end)

    container:connect_signal('mouse::leave', function()
        container.bg = '#ffffff00'
        if old_wibox then
            old_wibox.cursor = old_cursor
            old_wibox = nil
        end
    end)

    container:connect_signal('button::press', function()
        container.bg = '#ffffff22'
        awful.spawn(class)
    end)

    container:connect_signal('button::release', function()
        container.bg = '#ffffff11'
    end)

    return container
end

local create_popup = function(client_names)
    local popup = awful.popup {
        widget = {},
        border_color = '#63c5ea',
        border_width = dpi(1.5),
        maximum_width = dpi(400),
        maximum_height = dpi(200),
        type = "popup_menu",
        ontop = true,
        visible = false,
        offset = dpi(5),
        bg = beautiful.transparent,
        preferred_anchors = {'middle', 'back', 'front'},
        preferred_positions = {'left', 'right', 'top', 'bottom'},
        hide_on_right_click = true
    }
    popup:setup{
        widget = wibox.container.background,
        bg = "#00000077",
        -- shape = function(cr, width, height)
        --   gears.shape.partially_rounded_rect(cr, width, height, true, true, true,
        --     true, 10)
        -- end,
        {widget = client_names}
    }
    return popup
end

local get_client_names = function(instance_list)
    local client_names = wibox.layout.fixed.vertical()
    for i = #instance_list, 1, -1 do
        local c = instance_list[i]
        local name = wibox.widget.textbox(c.name)
        client_names:add(name)
    end
    return client_names -- vertical textboxes
end


local pop = {}

function pop:autohide()
    if self.popup_timer then
        self.popup_timer:stop()
        self.popup_timer = nil
    end
    self.popup_timer = gears.timer.start_new(0, function()
        self.popup_timer = nil
        self.instance.visible = false
    end)
end

function pop:show(instance_list)
    -- TODO: trim long titles
    -- TODO: update instead of instantiate pop here
    -- TODO: scroll on icon/pop needs to update pop
    -- TODO: elongate the timeout when mouse hover above pop
    -- TODO: fix errors when hovering on gradientbar
    if self.instance then self.instance.visible = false end
    if self.popup_timer then
        self.popup_timer:stop()
        self.popup_timer = nil
    end
    self.instance = create_popup(get_client_names(instance_list))
    self.instance.visible = true
    self.instance:move_next_to(mouse.current_widget_geometry)
end

local lyt = wibox.layout.fixed.horizontal(
    clickable_pinned_icon("alacritty"),
    clickable_pinned_icon("brave"),
    clickable_pinned_icon("thunar"),
    {widget = wibox.container.background})

local tasklist = wibox.widget {
    widget = wibox.container.background,
    forced_height = tasklist_height,
    {
        layout = wibox.layout.align.horizontal,
        expand = "none",
        nil,
        {
            widget = wibox.container.margin,
            top = dpi(2),
            bottom = dpi(2),
            {
                widget = wibox.container.background,
                bg = beautiful.tasklist_bg_focus,
                shape = function(cr, w, h)
                    gears.shape.rounded_rect(cr, w, h, dpi(4))
                end,
                {
                    widget = wibox.container.margin,
                    left = dpi(2),
                    right = dpi(2),
                    {layout = lyt}
                }
            }
        },
        nil
    }
}

local add_client_with_icon = function(c)
    table.insert(class_client_list, {[1] = c})
end

local add_client_to_old_list = function(c)
    local pos = search_class_id(class_client_list, c.class)
    table.insert(class_client_list[pos], c)
end

local remove_client_with_icon = function(pos)
    table.remove(class_client_list, pos)
end

local remove_client_in_old_list = function(c)
    local class_pos = search_class_id(class_client_list, c.class)
    local pos = search_id(class_client_list[class_pos], c)
    table.remove(class_client_list[class_pos], pos)
end

local cycle_clients = function(instance_list, clock_wise)
    local id = search_focus_id(instance_list)
    if id then
        if clock_wise then
            if id == #instance_list then
                client.focus = instance_list[1]
            else
                client.focus = instance_list[id + 1]
            end
        else
            if id == 1 then
                client.focus = instance_list[#instance_list]
            else
                client.focus = instance_list[id - 1]
            end
        end
    else
        client.focus = instance_list[1]
    end
end

local gradient_bar = wibox.widget {
    widget = wibox.container.background,
    shape = gears.shape.rounded_rect,
    forced_width = tasklist_height / 24 * 12,
    forced_height = tasklist_height / 24 * 2,
    bg = {
        type = "linear",
        from = {0, 0},
        to = {tasklist_height / 24 * 9, 0},
        stops = {{0, "#1daed4"}, {0.5, "#6f86c9"}, {1, "#e379d8"}}
    }
}

local icon_widget = function(icon, instance_list, grad)
    icon.forced_width = tasklist_height / 24 * 15

    icon:buttons(gears.table.join(
        awful.button({}, 1, function()
            client.focus = instance_list[#instance_list]
            instance_list[#instance_list].first_tag:view_only()
        end),
        -- awful.button({ }, 2, function ()
        -- end),
        awful.button({}, 4, function()
            cycle_clients(instance_list, true)
        end),

        awful.button({}, 5, function()
            cycle_clients(instance_list, false)
        end)))

    local dot_lyt = wibox.layout.fixed.horizontal()
    dot_lyt.spacing = dpi(0.5)
    local icon_wdg = wibox.widget {
        widget = wibox.container.margin,
        top = tasklist_height / 24 * 2,
        left = dpi(2),
        right = dpi(2),
        bottom = dpi(0.5),
        {
            layout = wibox.layout.fixed.vertical,
            -- expand = "none",
            {
                layout = wibox.layout.align.horizontal,
                expand = "none",
                nil,
                icon,
                nil
            },
            {
                layout = wibox.layout.align.horizontal,
                expand = "none",
                nil,
                {layout = dot_lyt},
                nil
            }
        }
    }

    if not grad then
        for i = #instance_list, 1, -1 do
            local c = instance_list[i]
            if c.floating then
                dot_lyt:add(dot("floating"))
            elseif c.minimized then
                dot_lyt:add(dot("hidden"))
            elseif c == client.focus then
                dot_lyt:add(dot("focus"))
            else
                dot_lyt:add(dot())
            end
        end
    else
        dot_lyt:add(gradient_bar)
    end

    icon:connect_signal("mouse::enter", function() pop:show(instance_list) end)
    icon:connect_signal("mouse::leave", function() pop:autohide() end)

    return icon_wdg
end

local set_icons_in_order = function()
    local icons = wibox.layout.fixed.horizontal()
    if #class_client_list >= 1 then icons:add(sep) end

    for _, client_list in ipairs(class_client_list) do
        if not client_list[1].icon then
            if #client_list > 4 then
                icons:add(icon_widget(default_icon, client_list, true))
            else
                icons:add(icon_widget(default_icon, client_list))
            end
        else
            if #client_list > 4 then
                icons:add(icon_widget(awful.widget.clienticon(client_list[1]), client_list, true))
            else
                icons:add(icon_widget(awful.widget.clienticon(client_list[1]), client_list))
            end
        end
    end

    lyt:set(4, icons)
end

local add_client = function(c)
    -- gears.timer.start_new(0.001, function() -- added so that minecraft launcher shows properly, TODO: better fix
        if c.class then
            if not has(class_client_list, c.class) then
                add_client_with_icon(c)
            else
                add_client_to_old_list(c)
            end
            set_icons_in_order()
        end
    -- end)
end

local remove_client = function(c)
    if c.class then
        local pos = search_class_id(class_client_list, c.class)
        if pos then
            local num_clients = #class_client_list[pos]
            if num_clients == 1 then
                remove_client_with_icon(pos)
            else
                remove_client_in_old_list(c)
            end
        end
        set_icons_in_order()
    end
end

local update = function() set_icons_in_order() end

client.connect_signal("property::floating", update)
client.connect_signal("property::hidden", update)
client.connect_signal("focus", update)
client.connect_signal("unfocus", update)
client.connect_signal("manage", add_client)
client.connect_signal("unmanage", remove_client)

return tasklist
