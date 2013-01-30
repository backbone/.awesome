require("awful")
require("awful.autofocus")
require("awful.rules")
require("beautiful")
require("naughty")
require("vicious")
require("volume")
require("autostart")

----< Error handling >------------------------------------------------
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
    awesome.add_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = err })
        in_error = false
    end)
end

----< Theme >---------------------------------------------------------
-- Themes define colours, icons, and wallpapers
beautiful.init(".config/awesome/theme.lua")

----< Variables >-----------------------------------------------------
-- This is used later as the default terminal and editor to run.
terminal = "urxvt -tr +sb"
editor = os.getenv("EDITOR") or "nano"
editor_cmd = terminal .. " -e " .. editor
modkey = "Mod1"

----< Table of layouts >----------------------------------------------
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

----< Tags >----------------------------------------------------------
tags = {
   names  = { "term",      "web",      "vm",       "office",   "note",
              "game",      "gimp",     "dict",     "im" },
   layout = { layouts[3],  layouts[1], layouts[1], layouts[1], layouts[1],
              layouts[1],  layouts[1], layouts[1], layouts[2]}
}
 for s = 1, screen.count() do
     -- Each screen has its own tag table.
     tags[s] = awful.tag(tags.names, s, tags.layout)
 end

----< Menu >----------------------------------------------------------
-- Create a laucher widget and a main menu
myawesomemenu = {
   { "edit config", editor_cmd .. " " .. awesome.conffile },
   { "hibernate", "gksudo hibernate" },
   { "lock", "xscreensaver-command --lock" },
   { "manual", terminal .. " -e man awesome" },
   { "quit", awesome.quit },
   { "restart", awesome.restart },
   { "reboot", "gksudo reboot" },
   { "xscreensaver", "xscreensaver-demo" },
}

mywebmenu = {
  { "Evernote", "nixnote.sh" },
  { "Firefox", "firefox" },
  { "Pidgin", "pidgin" },
  { "Psi", "psi" },
  { "Remmina", "remmina" },
}

mydrawmenu = {
  { "Dia", "dia --integrated" },
  { "GColor", "gcolor2" },
  { "Gimp", "gimp" },
  { "GQView", "gqview" },
  { "Inkscape", "inkscape" },
  { "Shotwell", "shotwell" },
}

myaudiomenu = {
  { "Sonata", "sonata" },
}

myvideo = {
  { "Avidemux", "avidemux2_gtk" },
  { "RecordMyDesktop", "gtk-recordMyDesktop" },
}

myeditorsmenu = {
  { "GVim", "gvim" },
  { "Oxygen", "oxygen" },
}

mydevmenu = {
  { "Alleyoop", "alleyoop" },
  { "Android DDMS", "ddms" },
  { "Android Update", "android" },
  { "Anjuta", "anjuta" },
  { "DDD", "ddd" },
  { "Glade", "glade" },
  { "KCachegrind", "kcachegrind" },
  { "LabView-8.6", "labview-8.6" },
  { "XML Spy", "wine '"..os.getenv("HOME").."/.wine/drive_c/Program Files/Altova/XMLSpy2005/XMLSpy.exe'" },
}

mygamemenu = {
  { "0ad", "0ad" },
  { "Eboard", "eboard" },
  { "Charley", "charleygame-bin" },
  { "LinCity NG", "lincity-ng" },
  { "Nexuiz", "nexuiz" },
  { "Minetest", "minetest" },
  { "Tuxtracer", "etracer" },
}

myofficemenu = {
  { "Evince", "evince" },
  { "LO Base", "lobase" },
  { "LO Calc", "localc" },
  { "LO Draw", "lodraw" },
  { "LO Math", "lomath" },
  { "LO Writer", "lowriter" },
  { "LO Impress", "loimpress" },
  { "LyX", "lyx" },
  { "Okular", "okular" },
  { "Stardict", "stardict" },
  { "Xchm", "xchm" },
  { "Xdvik", "xdvik" },
}

myutilsmenu = {
  { "File-Roller", "file-roller" },
  { "GConf-editor", "gconf-editor" },
  { "GParted", "gksudo gparted" },
  { "GTK-Theme", "gtk-chtheme" },
  { "NVIDIA", "nvidia-settings" },
  { "Xfburn", "xfburn" },
}

myvmmenu = {
  { "AQemu", "aqemu" },
  { "DosBox", "dosbox" },
  { "VirtualBox", "VirtualBox" },
}

mymainmenu = awful.menu({ items = {
                                    { "awesome", myawesomemenu, beautiful.awesome_icon },
                                    { "audio", myaudiomenu, beautiful.awesome_icon },
                                    { "dev", mydevmenu, beautiful.awesome_icon },
                                    { "draw", mydrawmenu, beautiful.awesome_icon },
                                    { "edit", myeditorsmenu, beautiful.awesome_icon },
                                    { "game", mygamemenu, beautiful.awesome_icon },
                                    { "office", myofficemenu, beautiful.awesome_icon },
                                    { "utils", myutilsmenu, beautiful.awesome_icon },
                                    { "video", myvideo, beautiful.awesome_icon },
                                    { "vm", myvmmenu, beautiful.awesome_icon },
                                    { "web", mywebmenu, beautiful.awesome_icon },
                                    { "lock", "xscreensaver-command --lock" },
                                    { "open terminal", terminal }
                                  }
                        })

mylauncher = awful.widget.launcher({ image = image(beautiful.awesome_icon),
                                     menu = mymainmenu })

----< Wibox >----------------------------------------------------------
 wifi_widget_down = widget({ type = "textbox" })
 wifi_widget_up = widget({ type = "textbox" })
 icon_wifi = widget({ type = "imagebox" })
 icon_wifi_down_up = widget({ type = "imagebox" })
 icon_wifi.image = image(beautiful.widget_wifi)
 icon_wifi_down_up.image = image(beautiful.widget_wifi_down_up)
 wired_widget_down = widget({ type = "textbox" })
 wired_widget_up = widget({ type = "textbox" })
 icon_wired = widget({ type = "imagebox" })
 icon_wireddown = widget({ type = "imagebox" })
 icon_wired_down_up = widget({ type = "imagebox" })
 icon_wired.image = image(beautiful.widget_wired)
 icon_wired_down_up.image = image(beautiful.widget_wired_down_up)

 bat_widget = widget({ type = "textbox" })
 bat_icon = widget({ type = "imagebox" })
 bat_icon.image = image(beautiful.widget_bat)

 cpu_widget = widget({ type = "textbox" })
 cpu_icon = widget({ type = "imagebox" })
 cpu_icon.image = image(beautiful.widget_cpu)

 mem_widget = widget({ type = "textbox" })
 mem_icon = widget({ type = "imagebox" })
 mem_icon.image = image(beautiful.widget_mem)

 -- vol_widget = widget({ type = "textbox" })
 vol_icon = widget({ type = "imagebox" })
 vol_icon.image = image(beautiful.widget_vol)

 vicious.cache(vicious.widgets.net)
 vicious.register(wifi_widget_down, vicious.widgets.net, '<span color="#7F9F7F">${wlan0 down_mb}</span>', 2)
 vicious.register(wifi_widget_up, vicious.widgets.net, '<span color="#CC9393">${wlan0 up_mb}</span>', 2)
 vicious.register(wired_widget_down, vicious.widgets.net, '<span color="#7F9F7F">${eth0 down_mb}</span>', 2)
 vicious.register(wired_widget_up, vicious.widgets.net, '<span color="#CC9393">${eth0 up_mb}</span>', 2)
 vicious.register(bat_widget, vicious.widgets.bat, "$2%", 120, "BAT0")
 vicious.register(cpu_widget, vicious.widgets.cpu, "$1%")
 vicious.register(mem_widget, vicious.widgets.mem, "$1%")


-- Create a textclock widget
mytextclock = awful.widget.textclock({ align = "right" })

-- Create a systray
mysystray = widget({ type = "systray" })

-- Create a wibox for each screen and add it
mywibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
                    awful.button({ }, 1, awful.tag.viewonly),
                    awful.button({ modkey }, 1, awful.client.movetotag),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, awful.client.toggletag),
                    awful.button({ }, 4, awful.tag.viewnext),
                    awful.button({ }, 5, awful.tag.viewprev)
                    )
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
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
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                              if client.focus then client.focus:raise() end
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                              if client.focus then client.focus:raise() end
                                          end))

for s = 1, screen.count() do
    -- Create a promptbox for each screen
    mypromptbox[s] = awful.widget.prompt({ layout = awful.widget.layout.horizontal.leftright })
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                           awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.label.all, mytaglist.buttons)

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(function(c)
                                              return awful.widget.tasklist.label.currenttags(c, s)
                                          end, mytasklist.buttons)

    -- Create the wibox
    mywibox[s] = awful.wibox({ position = "top", screen = s })
    -- Add widgets to the wibox - order matters
    mywibox[s].widgets = {
        {
            mylauncher,
            mytaglist[s],
            mypromptbox[s],
            layout = awful.widget.layout.horizontal.leftright
        },
        mylayoutbox[s],
        mytextclock,
        volume_widget, vol_icon,
        separator, wifi_widget_up, icon_wifi_down_up, wifi_widget_down, icon_wifi,
        separator, wired_widget_up, icon_wired_down_up, wired_widget_down, icon_wireddown, icon_wired,
        bat_widget, bat_icon,
        mem_widget, mem_icon,
        cpu_widget, cpu_icon,
        s == 1 and mysystray or nil,
        mytasklist[s],
        layout = awful.widget.layout.horizontal.rightleft
    }
end

----< Mouse bindings >------------------------------------------------

root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))

----< Key bindings >--------------------------------------------------
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
    awful.key({ modkey, "Control"   }, "l", function () os.execute ("xscreensaver-command --lock") end),

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
    awful.button({ modkey }, 3, awful.mouse.client.resize))

require("apprules")

-- Set keys
root.keys(globalkeys)

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
