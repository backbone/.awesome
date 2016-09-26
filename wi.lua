local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local vicious = require("vicious")
local naughty = require("naughty")

----< Battery >-------------------------------------------------------
--
local bat_state  = ""
local bat_charge = 0
local bat_time   = 0
local blink      = true
baticon = wibox.widget.imagebox()
baticon:set_image(beautiful.widget_batfull)

-- Charge %
batpct = wibox.widget.textbox()
vicious.register(batpct, vicious.widgets.bat, function(widget, args)
  bat_state  = args[1]
  bat_charge = args[2]
  bat_time   = args[3]

  if args[1] == "−" then
    if bat_charge > 70 then
      baticon:set_image(beautiful.widget_batfull)
    elseif bat_charge > 30 then
      baticon:set_image(beautiful.widget_batmed)
    elseif bat_charge > 10 then
      baticon:set_image(beautiful.widget_batlow)
    else
      baticon:set_image(beautiful.widget_batempty)
    end
  else
    baticon:set_image(beautiful.widget_ac)
    if args[1] == "+" then
      blink = not blink
      if blink then
        baticon:set_image(beautiful.widget_acblink)
      end
    end
  end

  return args[2] .. "% "
end, nil, "BAT0")

function popup_bat()
  local state = ""
  if bat_state == "↯" then
    state = "Full"
  elseif bat_state == "↯" then
    state = "Charged"
  elseif bat_state == "+" then
    state = "Charging"
  elseif bat_state == "-" then
    state = "Discharging"
  elseif bat_state == "⌁" then
    state = "Not charging"
  else
    state = "Unknown"
  end

  naughty.notify { text = "Charge : " .. bat_charge .. "%\nState  : " .. state ..
    " (" .. bat_time .. ")", timeout = 5, hover_timeout = 0.5 }
end
batpct:buttons(awful.util.table.join(awful.button({ }, 1, popup_bat)))
baticon:buttons(batpct:buttons())

----< Volume >--------------------------------------------------------
--
vicious.cache(vicious.widgets.volume)
volicon = wibox.widget.imagebox()
volicon:set_image(beautiful.widget_vol)
volicon:buttons(
    awful.util.table.join(
        awful.button({ }, 1, function () awful.util.spawn("urxvt -e alsamixer --view=all") end),
        awful.button({ }, 4, function () awful.util.spawn("amixer set Master 1%+") end),
        awful.button({ }, 5, function () awful.util.spawn("amixer set Master 1%-") end)
    )
)
volpct = wibox.widget.textbox()
volpct:buttons(
    awful.util.table.join(
        awful.button({ }, 1, function () awful.util.spawn("urxvt -e alsamixer --view=all") end),
        awful.button({ }, 4, function () awful.util.spawn("amixer set Master 1%+") end),
        awful.button({ }, 5, function () awful.util.spawn("amixer set Master 1%-") end)
    )
)
vicious.register(volpct, vicious.widgets.volume, "$1% ", nil, "Master")

----< CPU >-----------------------------------------------------------
--
cpuicon = wibox.widget.imagebox()
cpuicon:set_image(beautiful.widget_cpu)
cpu = wibox.widget.textbox()
cpu.fit = function (box,w,h)
  return 30,0
end
vicious.register(cpu, vicious.widgets.cpu, '<span color="#677ecc"> $1%</span>', 2)

----< Disk Usage >----------------------------------------------------
--
diskicon = wibox.widget.imagebox()
diskicon:set_image(beautiful.widget_disk)
disk = wibox.widget.textbox()
vicious.register(disk, vicious.widgets.fs, '<span color="#cc7c4b">${/home avail_gb}Gb </span>', 15)

----< Memory Usage >--------------------------------------------------
--
memicon = wibox.widget.imagebox()
memicon:set_image(beautiful.widget_ram)
mem = wibox.widget.textbox()
vicious.register(mem, vicious.widgets.mem, '<span color="#639150"> $1/$5% </span>', 2)
