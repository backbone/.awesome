----< Includes >------------------------------------------------------
--
-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
awful.rules = require("awful.rules")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Autostart
require("autostart")

----< Theme >---------------------------------------------------------
--
-- Theme handling library
local beautiful = require("beautiful")
beautiful.init(os.getenv("HOME").."/.config/awesome/themes/default/theme.lua")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
--FreeDesktop
require('freedesktop.utils')
require('freedesktop.menu')
freedesktop.utils.icon_theme = 'gnome'
--Vicious + Widgets 
vicious = require("vicious")
local wi = require("wi")
local html = require("html")

----< Error handling >------------------------------------------------
--
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = err })
        in_error = false
    end)
end

----< Variables >-----------------------------------------------------
--
-- This is used later as the default terminal and editor to run.
terminal = "urxvt -tr +sb"
editor = os.getenv("EDITOR") or "vim"
editor_cmd = terminal .. " -e " .. editor
modkey = "Mod1"

----< Table of layouts >----------------------------------------------
--
-- Table of layouts to cover with awful.layout.inc, order matters.
layouts =
{
    awful.layout.suit.max,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.floating,
    awful.layout.suit.max.fullscreen,
--    awful.layout.suit.spiral,
--    awful.layout.suit.spiral.dwindle,
--    awful.layout.suit.magnifier
}

----< Naughty presets >-----------------------------------------------
--
naughty.config.defaults.timeout = 5
naughty.config.defaults.screen = 1
naughty.config.defaults.position = "top_right"
naughty.config.defaults.margin = 8
naughty.config.defaults.gap = 1
naughty.config.defaults.ontop = true
naughty.config.defaults.font = "terminus 9"
naughty.config.defaults.icon = nil
naughty.config.defaults.icon_size = 256
naughty.config.defaults.fg = beautiful.fg_tooltip
naughty.config.defaults.bg = beautiful.bg_tooltip
naughty.config.defaults.border_color = beautiful.border_tooltip
naughty.config.defaults.border_width = 2
naughty.config.defaults.hover_timeout = nil

----< Tags >----------------------------------------------------------
--
tags = {
   names  = { "term",      "web",      "vm",       "office",   "mail",
              "game",      "gimp",     "dict",     "im" },
   layout = { layouts[3],  layouts[1], layouts[1], layouts[1], layouts[1],
              layouts[1],  layouts[1], layouts[1], layouts[2]}
}
 for s = 1, screen.count() do
     -- Each screen has its own tag table.
     tags[s] = awful.tag(tags.names, s, tags.layout)
 end

----< Wallpaper >-----------------------------------------------------
--
local wallpaper = require("wallpaper")

--
--if beautiful.wallpaper then
--    for s = 1, screen.count() do
--        gears.wallpaper.maximized(beautiful.wallpaper, s, true)
--    end
--end

---- Wallpaper Changer Based On 
---- menu icon menu pdq 07-02-2012
-- local wallmenu = {}
-- local function wall_load(wall)
-- local f = io.popen('ln -sfn ' .. home_path .. '.config/awesome/wallpaper/' .. wall .. ' ' .. home_path .. '.config/awesome/themes/default/bg.png')
-- awesome.restart()
-- end
-- local function wall_menu()
-- local f = io.popen('ls -1 ' .. home_path .. '.config/awesome/wallpaper/')
-- for l in f:lines() do
--local item = { l, function () wall_load(l) end }
-- table.insert(wallmenu, item)
-- end
-- f:close()
-- end
-- wall_menu()

----< Menu >----------------------------------------------------------
--
menu_items = freedesktop.menu.new()
myawesomemenu = {
   { "next wall", os.getenv("HOME").."/.config/awesome/set_wall.sh "..os.getenv("HOME").."/wallpapers/" },
   { "hibernate", "gksudo hibernate" },
   { "lock", "xscreensaver-command --lock" },
   { "reboot", "gksudo reboot" },
   { "manual", terminal .. " -e man awesome", freedesktop.utils.lookup_icon({ icon = 'help' }) },
   { "edit config", editor_cmd .. " " .. awesome.conffile, freedesktop.utils.lookup_icon({ icon = 'package_settings' }) },
   { "restart", awesome.restart, freedesktop.utils.lookup_icon({ icon = 'system-shutdown' }) },
   { "quit", awesome.quit, freedesktop.utils.lookup_icon({ icon = 'system-shutdown' }) }
}
table.insert(menu_items, { "Awesome", myawesomemenu, beautiful.awesome_icon })
mymainmenu = awful.menu({ items = menu_items, width = 150 })
mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = mymainmenu })
menubar.utils.terminal = terminal -- Set the terminal for applications that require it

----< Widgets >-------------------------------------------------------
-- 
spacer       = wibox.widget.textbox()
spacer:set_text(' ')

--spacer2       = wibox.widget.textbox()
--spacer2:set_text(' ')

--Battery Widget
--batt = wibox.widget.textbox()
--vicious.register(batt, vicious.widgets.bat, "$2% $3 ", 61, "BAT0")


-- {{{ Wibox
-- Create a textclock widget
mytextclock = awful.widget.textclock()

-- Create a wibox for each screen and add it
mywibox = {}
myinfowibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
                    awful.button({ }, 1, awful.tag.viewonly),
                    awful.button({ modkey }, 1, awful.client.movetotag),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, awful.client.toggletag),
                    awful.button({ }, 5, function(t) awful.tag.viewnext(awful.tag.getscreen(t)) end),
                    awful.button({ }, 4, function(t) awful.tag.viewprev(awful.tag.getscreen(t)) end)
                    )
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  -- Without this, the following
                                                  -- :isvisible() makes no sense
                                                  c.minimized = false
                                                  if not c:isvisible() then
                                                      awful.tag.viewonly(c:tags()[1])
                                                  end
                                                  -- This will also un-minimize
                                                  -- the client, if needed
                                                  client.focus = c
                                                  c:raise()
                                              end
                                          end),
                     awful.button({ }, 3, function ()
                                              if instance then
                                                  instance:hide()
                                                  instance = nil
                                              else
                                                  instance = awful.menu.clients({ width=250 })
                                              end
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(1)
                                              if client.focus then client.focus:raise() end
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(-1)
                                              if client.focus then client.focus:raise() end
                                          end))

-- My Mail updater widget
function mail_count(filename)
    local f = io.open(filename)
    local l = nil
    if f ~= nil then
          l = f:read()
          if l == nil then
              l = "?"
          end
    else
          l = "?"
    end
    f:close()
    return l
end
mymail_mail = wibox.widget.textbox( "?" )
mymail_mail.timer = timer{timeout=20}
mymail_mail.timer:connect_signal("timeout",
    function () mymail_mail:set_text ( mail_count("/tmp/"..os.getenv("USERNAME").."-mail_loop".."/mymail_count") ) end)
mymail_mail.timer:start()
mymailicon = wibox.widget.imagebox()
mymailicon:set_image(beautiful.widget_mymail)
gmail_mail = wibox.widget.textbox( "?" )
gmail_mail.timer = timer{timeout=20}
gmail_mail.timer:connect_signal("timeout",
    function () gmail_mail:set_text ( mail_count("/tmp/"..os.getenv("USERNAME").."-mail_loop".."/gmail_count") ) end)
gmail_mail.timer:start()
mymailicon = wibox.widget.imagebox()
mymailicon:set_image(beautiful.widget_mymail)

-- Wi-Fi / Ethernet widgets
wifi_widget_down = wibox.widget.textbox()
wifi_widget_up = wibox.widget.textbox()
icon_wifi = wibox.widget.imagebox()
icon_wifi_down_up = wibox.widget.imagebox()
icon_wifi:set_image (beautiful.widget_wifi)
icon_wifi_down_up:set_image (beautiful.widget_wifi_down_up)
wired_widget_down = wibox.widget.textbox()
wired_widget_up = wibox.widget.textbox()
icon_wired = wibox.widget.imagebox()
icon_wired_down_up = wibox.widget.imagebox()
icon_wired:set_image (beautiful.widget_wired)
icon_wired_down_up:set_image (beautiful.widget_wired_down_up)

vicious.cache(vicious.widgets.net)
vicious.register(wifi_widget_down, vicious.widgets.net, '<span color="#baa53f">${wlan0 down_mb}</span>', 2)
vicious.register(wifi_widget_up, vicious.widgets.net, '<span color="#b165bd">${wlan0 up_mb}</span>', 2)
vicious.register(wired_widget_down, vicious.widgets.net, '<span color="#baa53f">${eth0 down_mb}</span>', 2)
vicious.register(wired_widget_up, vicious.widgets.net, '<span color="#b165bd">${eth0 up_mb}</span>', 2)

for s = 1, screen.count() do
    -- Create a promptbox for each screen
    mypromptbox[s] = awful.widget.prompt()
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                           awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, mytaglist.buttons)

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, mytasklist.buttons)

    -- Create the wibox
    mywibox[s] = awful.wibox({ position = "top", screen = s , height = 15.5})

    -- Widgets that are aligned to the left
    local left_layout = wibox.layout.fixed.horizontal()
    left_layout:add(mylauncher)
    left_layout:add(mytaglist[s])
    left_layout:add(mypromptbox[s])

    -- Widgets that are aligned to the right
    local right_layout = wibox.layout.fixed.horizontal()
    if s == 1 then right_layout:add(wibox.widget.systray()) end

    right_layout:add(spacer)
    right_layout:add(mymailicon)
    right_layout:add(mymail_mail)
    myslash = wibox.widget.textbox("+")
    right_layout:add(myslash)
    right_layout:add(gmail_mail)

    right_layout:add(spacer)
    right_layout:add(cpuicon)
    right_layout:add(cpu)
    --right_layout:add(spacer)
    right_layout:add(memicon)
    right_layout:add(mem)
    right_layout:add(diskicon)
    right_layout:add(disk)
    --right_layout:add(spacer)
    --right_layout:add(weatheric)
    --right_layout:add(weather)
    --right_layout:add(spacer)
    --right_layout:add(mailicon)
    --right_layout:add(mailwidget)
    --right_layout:add(spacer)
    right_layout:add(baticon)
    right_layout:add(batpct)
    --right_layout:add(netwidgeticon)
    --right_layout:add(netwidget)
    --right_layout:add(wifiicon)
    --right_layout:add(wifi)
    --right_layout:add(spacer2)
    --right_layout:add(spacer)
    --right_layout:add(pacicon)
    --right_layout:add(pacwidget)
    --right_layout:add(spacer)
    --right_layout:add(spacer)
    --right_layout:add(spacer)
    right_layout:add(icon_wifi)
    right_layout:add(wifi_widget_down)
    right_layout:add(icon_wifi_down_up)
    right_layout:add(wifi_widget_up)
    right_layout:add(spacer)
    right_layout:add(icon_wired)
    right_layout:add(wired_widget_down)
    right_layout:add(icon_wired_down_up)
    right_layout:add(wired_widget_up)
    right_layout:add(spacer)
    right_layout:add(volicon)
    --right_layout:add(volumecfg.widget)
    right_layout:add(volpct)
    --right_layout:add(volspace)
    --right_layout:add(spacer)
    --right_layout:add(spacer)
    right_layout:add(mytextclock)
    right_layout:add(mylayoutbox[s])

    -- Now bring it all together (with the tasklist in the middle)
    local layout = wibox.layout.align.horizontal()
    layout:set_left(left_layout)
    layout:set_middle(mytasklist[s])
    layout:set_right(right_layout)

   mywibox[s]:set_widget(layout)
   
   -- Create the bottom wibox
     --myinfowibox[s] = awful.wibox({ position = "bottom", screen = s })
   -- Widgets that are aligned to the bottom
    --local bottom_layout = wibox.layout.fixed.horizontal()
--    bottom_layout:add(diskwidget)
    --bottom_layout:add(spacer)
    --bottom_layout:add(netwidgeticon)
    --bottom_layout:add(netwidget)
    --bottom_layout:add(spacer)
    --bottom_layout:add(wifiicon)
    --bottom_layout:add(wifi)

 -- Now bring it all together 
    --local layout = wibox.layout.align.horizontal()
    --layout:set_bottom(bottom_layout)

    --myinfowibox[s]:set_widget(bottom_layout)

end
-- }}}

----< Mouse bindings >------------------------------------------------
--
root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 5, awful.tag.viewnext),
    awful.button({ }, 4, awful.tag.viewprev)
))

----< Key bindings >--------------------------------------------------
--
globalkeys = awful.util.table.join(
    -- Volume control --
    awful.key({ modkey }, ".", function ()
    awful.util.spawn("amixer set Master 9%+") end),
    awful.key({ modkey }, ",", function ()
    awful.util.spawn("amixer set Master 9%-") end),
    awful.key({ modkey }, "/", function ()
    awful.util.spawn("amixer sset Master toggle") end),

    -- Volume control --
    awful.key({ }, "XF86AudioRaiseVolume", function ()
    awful.util.spawn("amixer set Master 9%+") end),
    awful.key({ }, "XF86AudioLowerVolume", function ()
    awful.util.spawn("amixer set Master 9%-") end),
    awful.key({ }, "XF86AudioMute", function ()
    awful.util.spawn("amixer sset Master toggle") end),

    awful.key({ modkey,           }, "[",   awful.tag.viewprev       ),
    awful.key({ modkey,           }, "]",  awful.tag.viewnext       ),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore),

    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx( 1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "w", function () mymainmenu:show({keygrabber=true}) end),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx(  1)    end),
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx( -1)    end),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative( 1) end),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative(-1) end),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal) end),
    awful.key({ modkey, "Control" }, "r", awesome.restart),
    -- awful.key({ modkey, "Shift"   }, "q", awesome.quit),
    awful.key({ "Mod4"   }, "l", function () os.execute ("xscreensaver-command --lock") end),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),
    awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),

    awful.key({ modkey, "Control" }, "n", awful.client.restore),

    -- Prompt
    awful.key({ modkey },            "r",     function () mypromptbox[mouse.screen]:run() end),

    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run({ prompt = "Run Lua code: " },
                  mypromptbox[mouse.screen].widget,
                  awful.util.eval, nil,
                  awful.util.getdir("cache") .. "/history_eval")
              end),
    awful.key({ modkey }, "l",function () awful.util.spawn( "mpc play" ) end),
    awful.key({ modkey }, ";",function () awful.util.spawn( "mpc pause" ) end),
    awful.key({ modkey }, "'",function () awful.util.spawn( "mpc prev" ) end),
    awful.key({ modkey }, "\\",function () awful.util.spawn( "mpc next" ) end)
)

clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
    awful.key({ modkey, "Shift"   }, "r",      function (c) c:redraw()                       end),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end),
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end)
)

-- Compute the maximum number of digit we need, limited to 9
keynumber = 0
for s = 1, screen.count() do
   keynumber = math.min(9, math.max(#tags[s], keynumber));
end

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, keynumber do
    globalkeys = awful.util.table.join(globalkeys,
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = mouse.screen
                        if tags[screen][i] then
                            awful.tag.viewonly(tags[screen][i])
                        end
                  end),
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = mouse.screen
                      if tags[screen][i] then
                          awful.tag.viewtoggle(tags[screen][i])
                      end
                  end),
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.movetotag(tags[client.focus.screen][i])
                      end
                  end),
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.toggletag(tags[client.focus.screen][i])
                      end
                  end))
end

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize)
)

-- PrintScreen keys --
globalkeys = awful.util.table.join(globalkeys,
        awful.key({        }, "Print",
                  function () awful.util.spawn_with_shell ("DATE=`date +%d%m%Y_%H%M%S`;"..
                      "xsnap -nogui -file $HOME/screenshots/xsnap$DATE && gqview -r $HOME/screenshots/xsnap$DATE.png") end)
)

-- Set keys
root.keys(globalkeys)

----< Application rules >---------------------------------------------
--
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = true,
                     keys = clientkeys,
                     buttons = clientbuttons } },
    { rule = { class = "URxvt" },
      callback = function(c) awful.client.movetotag(tags[mouse.screen][1], c) end },
    { rule = { class = "Firefox" },
      callback = function(c) awful.client.movetotag(tags[mouse.screen][2], c) end },
    { rule = { class = "Thunderbird" },
      callback = function(c) awful.client.movetotag(tags[mouse.screen][5], c) end },
    { rule = { class = "Geary" },
      callback = function(c) awful.client.movetotag(tags[mouse.screen][5], c) end },
    { rule = { class = "Liferea" },
      callback = function(c) awful.client.movetotag(tags[mouse.screen][2], c) end },
    { rule = { class = "VirtualBox" },
      callback = function(c) awful.client.movetotag(tags[mouse.screen][3], c) end },
    { rule = { class = "Remmina" },
      callback = function(c) awful.client.movetotag(tags[mouse.screen][3], c) end },
    { rule = { class = "Spicy" },
      callback = function(c) awful.client.movetotag(tags[mouse.screen][3], c) end },
    { rule = { class = "Aqemu" },
      callback = function(c) awful.client.movetotag(tags[mouse.screen][3], c) end },
    { rule = { class = "Soffice" },
      callback = function(c) awful.client.movetotag(tags[mouse.screen][4], c) end },
    { rule = { class = "LibreOffice" },
      callback = function(c) awful.client.movetotag(tags[mouse.screen][4], c) end },
    { rule = { class = "libreoffice-writer" },
      callback = function(c) awful.client.movetotag(tags[mouse.screen][4], c) end },
    { rule = { class = "libreoffice-calc" },
      callback = function(c) awful.client.movetotag(tags[mouse.screen][4], c) end },
    { rule = { class = "libreoffice-draw" },
      callback = function(c) awful.client.movetotag(tags[mouse.screen][4], c) end },
    { rule = { class = "libreoffice-base" },
      callback = function(c) awful.client.movetotag(tags[mouse.screen][4], c) end },
    { rule = { class = "libreoffice-math" },
      callback = function(c) awful.client.movetotag(tags[mouse.screen][4], c) end },
    { rule = { class = "libreoffice-impress" },
      callback = function(c) awful.client.movetotag(tags[mouse.screen][4], c) end },
    { rule = { class = "libreoffice-startcenter" },
      callback = function(c) awful.client.movetotag(tags[mouse.screen][4], c) end },
    { rule = { class = "Okular" },
      callback = function(c) awful.client.movetotag(tags[mouse.screen][4], c) end },
    { rule = { class = "Lyx" },
      callback = function(c) awful.client.movetotag(tags[mouse.screen][4], c) end },
    { rule = { class = "Evince" },
      callback = function(c) awful.client.movetotag(tags[mouse.screen][4], c) end },
    { rule = { class = "Qt Jambi application" },
      callback = function(c) awful.client.movetotag(tags[mouse.screen][5], c) end },
    { rule = { class = "Pidgin" },
      callback = function(c) awful.client.movetotag(tags[mouse.screen][9], c) end },
    { rule = { class = "Stardict" },
      callback = function(c) awful.client.movetotag(tags[mouse.screen][8], c) end },
    { rule = { class = "MPlayer" },
      properties = { floating = true } },
    { rule = { class = "Texreport-gtk" },
      properties = { floating = true } },
    { rule = { class = "etracer" },
      callback = function(c) awful.client.movetotag(tags[mouse.screen][6], c) end },
    { rule = { class = "Eboard" },
      callback = function(c) awful.client.movetotag(tags[mouse.screen][6], c) end },
    { rule = { class = "charleygame-bin" },
      callback = function(c) awful.client.movetotag(tags[mouse.screen][6], c) end },
    { rule = { class = "lincity-ng" },
      callback = function(c) awful.client.movetotag(tags[mouse.screen][6], c) end },
    -- XTerm на пятом и шестом теге первого экрана
    -- { rule = { class = "XTerm" }, callback = function(c) c:tags({tags[1][4], tags[1][6]}) end},
}

----< Signals >------------------------------------------------------
-- Signal function to execute when a new client appears.
client.add_signal("manage", function (c, startup)
    -- Add a titlebar
    -- awful.titlebar.add(c, { modkey = modkey })

    -- Enable sloppy focus
    c:add_signal("mouse::enter", function(c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
            and awful.client.focus.filter(c) then
            client.focus = c
        end
    end)

    if not startup then
        -- Set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.
        -- awful.client.setslave(c)

        -- Put windows in a smart way, only if they does not set an initial position.
        if not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    end
end)

client.add_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.add_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
