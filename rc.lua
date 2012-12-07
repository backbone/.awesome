-- Standard awesome library
require("awful")
require("awful.autofocus")
require("awful.rules")
-- Theme handling library
require("beautiful")
-- Notification library
require("naughty")

require("autostart")
-- require("apps")
require("volume")
require("vicious")

-- {{{ Error handling
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
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, and wallpapers
beautiful.init(".config/awesome/theme.lua")

-- This is used later as the default terminal and editor to run.
terminal = "urxvt -tr +sb"
editor = os.getenv("EDITOR") or "nano"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod1"

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
-- }}}

-- -- {{{ Tags
-- -- Define a tag table which hold all screen tags.
-- tags = {}
-- for s = 1, screen.count() do
--     -- Each screen has its own tag table.
--     tags[s] = awful.tag({ 1, 2, 3, 4, 5, 6, 7, 8, 9 }, s, layouts[1])
-- end
-- -- }}}
-- {{{ Tags
 -- Define a tag table which will hold all screen tags.
 tags = {
   names  = { "term",     "web",      "vm",       "office",     "note",
              "game",    "gimp",    "dict",     "im" },
   layout = { layouts[3], layouts[1], layouts[1], layouts[1], layouts[1],
            layouts[1], layouts[1], layouts[1], layouts[2]
 }}
 for s = 1, screen.count() do
     -- Each screen has its own tag table.
     tags[s] = awful.tag(tags.names, s, tags.layout)
 end
-- }}}

-- {{{ Menu
-- Create a laucher widget and a main menu
myawesomemenu = {
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awesome.conffile },
   { "xscreensaver", "xscreensaver-demo" },
   { "restart", awesome.restart },
   { "lock", "xscreensaver-command --lock" },
   { "quit", awesome.quit }
}

function lock_screen ()
  os.execute ("xscreensaver-command --lock")
end

mywebmenu = {
  { "Firefox", "firefox" },
  { "Pidgin", "pidgin" },
  { "Psi", "psi" },
  { "Evernote", "nixnote.sh" }
}

mydrawmenu = {
  { "Dia", "dia --integrated" },
  { "Gimp", "gimp" },
  { "Inkscape", "inkscape" },
  { "Shotwell", "shotwell" },
  { "GQView", "gqview" },
  { "GColor", "gcolor2" }
}

myaudiomenu = {
  { "Sonata", "sonata" }
}

myvideo = {
  { "Avidemux", "avidemux" },
  { "RecordMyDesktop", "gtk-recordMyDesktop" }
}

myeditorsmenu = {
  { "GVim", "gvim" },
  { "Oxygen", "oxygen" }
}

mydevmenu = {
  { "Alleyoop", "alleyoop" },
  { "Android DDMS", "ddms" },
  { "Android Update", "android" },
  { "Anuta", "anjuta" },
  { "DDD", "ddd" },
  { "Glade", "glade" },
  { "KCachegrind", "kcachegrind" },
  { "LabView-8.6", "labview-8.6" }
}

mygamemenu = {
  { "Tuxtracer", "etracer" },
  { "Eboard", "eboard" },
  { "Nexuiz", "nexuiz" },
  { "Minetest", "minetest" },
  { "LinCity NG", "lincity-ng" },
}

myofficemenu = {
  { "LO Writer", "lowriter" },
  { "LO Calc", "localc" },
  { "LO Draw", "lodraw" },
  { "LO Base", "lobase" },
  { "LO Math", "lomath" },
  { "LO Impress", "loimpress" },
  { "Okular", "okular" },
  { "Evince", "evince" },
  { "Stardict", "stardict" },
  { "Xchm", "xchm" },
  { "Xdvik", "xdvik" },
  { "LyX", "lyx" }
}

myutilsmenu = {
  { "File-Roller", "file-roller" },
  { "Xfburn", "xfburn" },
  { "GParted", "gksudo gparted" },
  { "GTK-Theme", "gtk-chtheme" }
}

myvmmenu = {
  { "VirtualBox", "VirtualBox" },
  { "AQemu", "aqemu" },
  { "DosBox", "dosbox" }
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
-- }}}

-- {{{ Wibox
 --  My widgets
 wifi_widget_down = widget({ type = "textbox" })
 wifi_widget_up = widget({ type = "textbox" })
 icon_wifi = widget({ type = "imagebox" })
 icon_wifidown = widget({ type = "imagebox" })
 icon_wifiup = widget({ type = "imagebox" })
 icon_wifi.image = image(beautiful.widget_wifi)
 icon_wifidown.image = image(beautiful.widget_wifidown)
 icon_wifiup.image = image(beautiful.widget_wifiup)
 wired_widget_down = widget({ type = "textbox" })
 wired_widget_up = widget({ type = "textbox" })
 icon_wired = widget({ type = "imagebox" })
 icon_wireddown = widget({ type = "imagebox" })
 icon_wiredup = widget({ type = "imagebox" })
 icon_wired.image = image(beautiful.widget_wired)
 icon_wireddown.image = image(beautiful.widget_wireddown)
 icon_wiredup.image = image(beautiful.widget_wiredup)

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
        separator, wifi_widget_up, icon_wifiup, wifi_widget_down, icon_wifidown, icon_wifi,
        separator, wired_widget_up, icon_wiredup, wired_widget_down, icon_wireddown, icon_wired,
        bat_widget, bat_icon,
        mem_widget, mem_icon,
        cpu_widget, cpu_icon,
        s == 1 and mysystray or nil,
        mytasklist[s],
        layout = awful.widget.layout.horizontal.rightleft
    }
end
-- }}}

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
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
    awful.key({ modkey, "Control"   }, "l", lock_screen),

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

-- Set keys
root.keys(globalkeys)
-- }}}

require("apprules")

-- {{{ Signals
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
-- }}}

