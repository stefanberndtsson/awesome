local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")

-- Create a widget and update its content using the output of a shell
-- command every 10 seconds:
local mybatterybar = wibox.widget {
    {
        min_value    = 0,
        max_value    = 100,
        value        = 60,
        paddings     = 0,
        border_width = 0,
        forced_width = 50,
        forced_height = 3,
        border_color = "#000000",
        color = "#880000",
        background_color = "#000000",
        id           = "pbtop",
        widget       = wibox.widget.progressbar,
    },
    {
       {
          id           = "mytb",
          text         = " 50%",
          widget       = wibox.widget.textbox,
       },
       id = "mycont",
       fg = "#ffffff",
       widget = wibox.container.background
    },
    {
        min_value    = 0,
        max_value    = 100,
        value        = 60,
        paddings     = 0,
        border_width = 0,
        forced_width = 50,
        forced_height = 3,
        border_color = "#000000",
        color = "#880000",
        background_color = "#000000",
        id           = "pbbottom",
        widget       = wibox.widget.progressbar,
    },
    --    layout      = wibox.layout.stack,
    layout = wibox.layout.fixed.vertical,
    set_battery = function(self, val)
       local words = {}
       for word in val:gmatch("%w+") do
          table.insert(words, word)
       end
       local direction = words[1]
       local percent = tonumber(words[2])
       local directionsym = " "
       if direction == "up" then
          directionsym = "↑"
       elseif direction == "down" then
          directionsym = "↓"
       end
       self.mycont.mytb.text  = "  "..percent.."% "..directionsym
       local pbcol = "#00bb00"
       if percent < 16 then
          pbcol = "#660000"
       elseif percent < 36 then
          pbcol = "#bbbb00"
       end
       self.pbtop.color = pbcol
       self.pbbottom.color = pbcol
       self.pbtop.value = percent
       self.pbbottom.value = percent
    end,
}

gears.timer {
    timeout   = 3,
    autostart = true,
    callback  = function()
        -- You should read it from `/sys/class/power_supply/` (on Linux)
        -- instead of spawning a shell. This is only an example.
        awful.spawn.easy_async(gears.filesystem.get_configuration_dir() .. "cmds/battlevel.sh",
            function(out)
               mybatterybar:set_battery(out)
            end
        )
    end
}

own = {
   batterybar = mybatterybar,
   consts = {
      terminal = "xterm -u8 +sb -fg white -bg black -fn 6x10 -fb 6x10b -geometry 100x90 -xrm 'XTerm*vt100.color12: lightblue'"
   }
}
return own
