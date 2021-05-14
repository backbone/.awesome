----< Includes >------------------------------------------------------
--
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup").widget
-- Enable VIM help for hotkeys widget when client with matching name is opened:
require("awful.hotkeys_popup.keys.vim")
--FreeDesktop
require('freedesktop.menu')
--require('freedesktop.utils')
freedesktop.utils.icon_theme = 'gnome'
local vicious = require("vicious")
local wi = require("wi")
local autostart = require("autostart")

----< Variables >-----------------------------------------------------
--
local home = os.getenv("HOME")
local cfgpath = home.."/.config/awesome"
local username = os.getenv("USER")
local terminal = "urxvt +tr +sb"
local editor = os.getenv("EDITOR") or "vim"
local editor_cmd = terminal .. " -e " .. editor
local modkey = "Mod1"
local titlebars_enabled = false

----< Theme >---------------------------------------------------------
--
beautiful.init(cfgpath.."/themes/zenburn/theme.lua")

-- Naughty
--
naughty.config.defaults.timeout = 5
naughty.config.defaults.screen = 1
naughty.config.defaults.position = "top_right"
naughty.config.defaults.margin = 8
naughty.config.defaults.gap = 1
naughty.config.defaults.ontop = true
naughty.config.defaults.font = "terminus 10"
naughty.config.defaults.icon = nil
naughty.config.defaults.icon_size = 256
naughty.config.defaults.fg = beautiful.fg_tooltip
naughty.config.defaults.bg = beautiful.bg_tooltip
naughty.config.defaults.border_color = beautiful.border_tooltip
naughty.config.defaults.border_width = 0
naughty.config.defaults.hover_timeout = nil

----< Error handling >------------------------------------------------
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
                         text = tostring(err) })
        in_error = false
    end)
end

----< Table of layouts >----------------------------------------------
--
awful.layout.layouts = {
--    awful.layout.suit.floating,
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
--    awful.layout.suit.tile.bottom,
--    awful.layout.suit.tile.top,
    awful.layout.suit.fair,
--    awful.layout.suit.fair.horizontal,
--    awful.layout.suit.spiral,
--    awful.layout.suit.spiral.dwindle,
    awful.layout.suit.max,
--    awful.layout.suit.max.fullscreen,
--    awful.layout.suit.magnifier,
--    awful.layout.suit.corner.nw,
    -- awful.layout.suit.corner.ne,
    -- awful.layout.suit.corner.sw,
    -- awful.layout.suit.corner.se,
}

----< Helper functions >--------------------------------------------------
--
local function client_menu_toggle_fn()
    local instance = nil

    return function ()
        if instance and instance.wibox.visible then
            instance:hide()
            instance = nil
        else
            instance = awful.menu.clients({ theme = { width = 250 } })
        end
    end
end

----< Menu >--------------------------------------------------
--
-- Create a launcher widget and a main menu
menu_items = freedesktop.menu.new()
myawesomemenu = {
   { "next wall", cfgpath.."/set_wall.sh "..home.."/wallpapers/" },
   { "suspend", "sh -c 'xscreensaver-command -lock && loginctl suspend'" },
   { "hibernate", "sh -c 'xscreensaver-command -lock && loginctl hibernate'" },
   { "hybrid-sleep", "sh -c 'xscreensaver-command -lock && loginctl hybrid-sleep'" },
   { "susp+hibernate", "sh -c 'xscreensaver-command -lock && loginctl suspend-then-hibernate'" },
   { "lock", "xscreensaver-command --lock" },
   { "reboot", "loginctl reboot" },
   { "poweroff", "loginctl poweroff" },
   { "hotkeys", function() return false, hotkeys_popup.show_help end},
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awesome.conffile },
   { "restart", awesome.restart },
   { "quit", function() awesome.quit() end}
}
table.insert(menu_items, { "Awesome", myawesomemenu, beautiful.awesome_icon })

mymainmenu = awful.menu({ items = menu_items })
--{ { "awesome", myawesomemenu, beautiful.awesome_icon },
 --                                   { "open terminal", terminal }
  --                                }
   --                     })

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = mymainmenu })

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it

-- Keyboard map indicator and switcher
mykeyboardlayout = awful.widget.keyboardlayout()

----< Widgets >-------------------------------------------------------
--
local spacer = wibox.widget.textbox()
spacer:set_text(' ')

-- Create a wibox for each screen and add it
local myinfowibox = {}

-- My Mail updater widget
function mail_count(filename)
    local f = io.open(filename, "r")
    local l = nil
    if f ~= nil then
          l = f:read()
          if l == nil then
              l = "?"
          end
          f:close()
    else
          l = "?"
    end
    return l
end
local mail_tmp_path = "/tmp/"..username.."-mail_loop"
local mailicon = wibox.widget.imagebox()
mailicon:set_image(beautiful.widget_mailnew)
function mail_on_click()
  os.execute ("pgrep thunderbird || thunderbird &")
end
mailicon:buttons(awful.util.table.join(awful.button({ }, 1, mail_on_click)))
local mymail_mail = wibox.widget.textbox( "?" )
gears.timer {
	timeout = 20,
	autostart = true,
	callback = function() mymail_mail:set_text ( mail_count(mail_tmp_path.."/mymail_count") ) end
}
mymail_mail:buttons(mailicon:buttons())
-- local gmail_mail = wibox.widget.textbox( "?" )
-- gears.timer {
-- 	timeout = 20,
-- 	autostart = true,
-- 	callback = function() gmail_mail:set_text ( mail_count(mail_tmp_path.."/gmail_count") ) end
-- }
-- gmail_mail:buttons(mailicon:buttons())

-- nVidia Optimus
--local optimus_icon = wibox.widget.imagebox()
--local optimus_overclocked = false
--optimus_icon:set_image(beautiful.widget_optimus_off)
--gears.timer {
--	timeout = 3,
--	autostart = true,
--	callback = function()
--        local f = io.open("/proc/acpi/bbswitch", "r")
--        local l = nil
--        if f ~= nil then
--            l = f:read()
--            if string.sub (l, 14) == "ON" then
--                if optimus_overclocked == true then
--                    optimus_icon:set_image(beautiful.widget_optimus_overclocked)
--                else
--                    optimus_icon:set_image(beautiful.widget_optimus_on)
--                end
--            else
--                optimus_icon:set_image(beautiful.widget_optimus_off)
--                optimus_overclocked = false
--            end
--            f:close()
--        else
--            optimus_icon:set_image(beautiful.widget_optimus_off)
--        end
--    end
--}
--optimus_icon:buttons(awful.util.table.join(
--    awful.button({ }, 1,
--        function ()
--            os.execute ("pgrep nvidia-settings || optirun nvidia-settings -c :8 &")
--        end
--    ),
--    awful.button({ }, 3,
--        function ()
--            os.execute ("optirun nvidia-settings -c :8 -a '[gpu:0]/GPUGraphicsClockOffset[2]=135' &")
--            os.execute ("optirun nvidia-settings -c :8 -a '[gpu:0]/GPUMemoryTransferRateOffset[2]=560' &")
--            optimus_overclocked = true
--        end
--    )
--))

-- Wi-Fi / Ethernet widgets
local net_widget = wibox.widget.textbox()
local icon_net = wibox.widget.imagebox()
icon_net:set_image (beautiful.widget_wired)
local icon_wifi = wibox.widget.imagebox()
icon_wifi:set_image (beautiful.widget_wifi)

-- Network buttons
function show_nload (interface)
    os.execute ("pgrep --full --exact 'nload "..interface.."' || urxvt -e nload "..interface.." &")
end
function show_nethogs ()
    os.execute ("pgrep nethogs || urxvt -e sudo nethogs &")
end
icon_net:buttons(awful.util.table.join(awful.button({ }, 1, function () show_nload("wan0") end), awful.button({ }, 1, show_nethogs)))
icon_wifi:buttons(awful.util.table.join(awful.button({ }, 1, function () show_nload("wifi0") end), awful.button({ }, 1, show_nethogs)))
net_widget:buttons(awful.util.table.join(awful.button({ }, 1, function () show_nload("") end), awful.button({ }, 1, show_nethogs)))
vicious.register(net_widget, vicious.widgets.net, '<span color="#AEE350">${wan0 down_mb}</span>^<span color="#EB598D">${wan0 up_mb}</span> <span color="#E2E2E2">mb/s</span> <span color="#ABE347">${wifi0 down_mb}</span>^<span color="#E84D84">${wifi0 up_mb}</span>', 2)

-- VOL icon
vicious.cache(vicious.widgets.volume)
local volicon = wibox.widget.imagebox()
volicon:set_image(beautiful.widget_vol)
volicon:buttons(
    awful.util.table.join(
        -- awful.button({ }, 1, function () os.execute("pgrep alsamixer || urxvt -e alsamixer --view=all &") end),
        awful.button({ }, 1, function () os.execute("pgrep pavucontrol || pavucontrol &") end),
        awful.button({ }, 3, function () os.execute("pgrep alsamixer || urxvt -e alsamixer -c 2 &") end),
        awful.button({ }, 4, function () os.execute("pgrep -x amixer || amixer set Master 2%+") end),
        awful.button({ }, 5, function () os.execute("pgrep -x amixer || amixer set Master 2%-") end)
    )
)
volpct = wibox.widget.textbox()
volpct:buttons(volicon:buttons())
vicious.register(volpct, vicious.widgets.volume, "$1% ", nil, "Master")

-- CPU icon
vicious.cache(vicious.widgets.cpu)
function show_htop ()
    os.execute ("pgrep htop || urxvt -e htop &")
end
local cpuicon = wibox.widget.imagebox()
cpuicon:set_image(beautiful.widget_cpu)
cpuicon:buttons(awful.util.table.join(awful.button({ }, 1, show_htop)))
cpu = wibox.widget.textbox()
cpu.fit = function (box,w,h)
  return 45,0
end
vicious.register(cpu, vicious.widgets.cpu, '<span color="#6FE6F2"> $1%</span>', 2)
cpu:buttons(cpuicon:buttons())

-- Memory icon
vicious.cache(vicious.widgets.mem)
function show_atop ()
    os.execute ("pgrep atop || urxvt -e atop &")
end
local memicon = wibox.widget.imagebox()
memicon:set_image(beautiful.widget_ram)
memicon:buttons(awful.util.table.join(awful.button({ }, 1, show_atop)))
mem = wibox.widget.textbox()
vicious.register(mem, vicious.widgets.mem, '<span color="#7CD059"> $1/$5% </span>', 2)
mem:buttons(memicon:buttons())

-- Disk icon
vicious.cache(vicious.widgets.fs)
function show_iotop ()
    os.execute ("pgrep iotop || urxvt -e sudo iotop --delay=4 &")
end
local diskicon = wibox.widget.imagebox()
diskicon:set_image(beautiful.widget_disk)
diskicon:buttons(awful.util.table.join(awful.button({ }, 1, show_iotop)))
disk = wibox.widget.textbox()
vicious.register(disk, vicious.widgets.fs, '<span color="#E68347">${/ avail_gb}/${/home avail_gb}/${/mnt/1tb avail_gb}Gb </span>', 15)
disk:buttons(diskicon:buttons())



----< Wibar >--------------------------------------------------
--
-- Create a textclock widget
mytextclock = wibox.widget.textclock()
mytextclock:buttons(gears.table.join(awful.button({ }, 1,
    function () os.execute ("xdg-open https://calendar.google.com/calendar/render?tab=wc#main_7%7Cmonth &") end
)))

-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
                    awful.button({ }, 1, function(t) t:view_only() end),
                    awful.button({ modkey }, 1, function(t)
                                              if client.focus then
                                                  client.focus:move_to_tag(t)
                                              end
                                          end),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, function(t)
                                              if client.focus then
                                                  client.focus:toggle_tag(t)
                                              end
                                          end),
                    awful.button({ }, 4, function(t) awful.tag.viewprev(t.screen) end),
                    awful.button({ }, 5, function(t) awful.tag.viewnext(t.screen) end)
                )

local tasklist_buttons = gears.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  -- Without this, the following
                                                  -- :isvisible() makes no sense
                                                  c.minimized = false
                                                  if not c:isvisible() and c.first_tag then
                                                      c.first_tag:view_only()
                                                  end
                                                  -- This will also un-minimize
                                                  -- the client, if needed
                                                  client.focus = c
                                                  c:raise()
                                              end
                                          end),
                     awful.button({ }, 3, client_menu_toggle_fn()),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(-1)
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(1)
                                          end))

local function set_wallpaper(s)
    -- Wallpaper
--    if beautiful.wallpaper then
--        local wallpaper = beautiful.wallpaper
--        -- If wallpaper is a function, call it with the screen
--        if type(wallpaper) == "function" then
--            wallpaper = wallpaper(s)
--        end
--        gears.wallpaper.maximized(wallpaper, s, true)
--    end
    gears.wallpaper.maximized(cfgpath.."/wallpaper"..s.index..".slink", s, true)
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

awful.screen.connect_for_each_screen(function(s)
    -- Wallpaper
    set_wallpaper(s)

    -- Each screen has its own tag table.
    awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "-" }, s, awful.layout.layouts[4])
    awful.tag.add("+", {
        --icon = "/path/to/icon.png",
        layout = awful.layout.suit.fair,
        screen = s,
	})

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(gears.table.join(
                           awful.button({ }, 1, function () awful.layout.inc( 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(-1) end),
                           awful.button({ }, 4, function () awful.layout.inc( 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(-1) end)))
    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist(s, awful.widget.taglist.filter.all, taglist_buttons)

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, tasklist_buttons)

    -- Create the wibox
    s.mywibox = awful.wibar({ position = "top", screen = s, height = 14.5 })

    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            mylauncher,
            s.mytaglist,
            s.mypromptbox,
        },
        s.mytasklist, -- Middle widget
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,

			spacer,
			mailicon,
			mymail_mail,
            -- myslash = wibox.widget.textbox("+")
            -- myslash:buttons(mailicon:buttons())
            -- right_layout:add(myslash)
            -- right_layout:add(gmail_mail)
            -- gmail_mail,
			spacer,
			cpuicon,
			cpu,
			memicon,
			mem,
			diskicon,
			disk,
			--optimus_icon,
			spacer,
			baticon,
			batpct,
			spacer,
			icon_net,
			net_widget,
			icon_wifi,
			spacer,
			volicon,
			volpct,

            mykeyboardlayout,
            wibox.widget.systray(),
            mytextclock,
            s.mylayoutbox,
        },
    }
end)

----< Mouse bindings >--------------------------------------------------
--
root.buttons(gears.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewprev),
    awful.button({ }, 5, awful.tag.viewnext)
))

----< Key bindings >--------------------------------------------------
--
globalkeys = gears.table.join(
    awful.key({ modkey,           }, "s",      hotkeys_popup.show_help,
              {description="show help", group="awesome"}),
    awful.key({ modkey,           }, "[",   awful.tag.viewprev,
              {description = "view previous", group = "tag"}),
    awful.key({ modkey,           }, "]",  awful.tag.viewnext,
              {description = "view next", group = "tag"}),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore,
              {description = "go back", group = "tag"}),

    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx( 1)
        end,
        {description = "focus next by index", group = "client"}
    ),
    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx(-1)
        end,
        {description = "focus previous by index", group = "client"}
    ),
    awful.key({ modkey,           }, "w", function () mymainmenu:show() end,
              {description = "show main menu", group = "awesome"}),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx(  1)    end,
              {description = "swap with next client by index", group = "client"}),
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx( -1)    end,
              {description = "swap with previous client by index", group = "client"}),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative( 1) end,
              {description = "focus the next screen", group = "screen"}),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative(-1) end,
              {description = "focus the previous screen", group = "screen"}),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto,
              {description = "jump to urgent client", group = "client"}),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end,
        {description = "go back", group = "client"}),

    -- Standard program
    awful.key({ modkey, "Shift"   }, "Return", function () awful.spawn(terminal) end,
              {description = "open a terminal", group = "launcher"}),
    awful.key({ modkey, "Control" }, "r", awesome.restart,
              {description = "reload awesome", group = "awesome"}),
    -- awful.key({ modkey, "Shift"   }, "q", awesome.quit,
    --           {description = "quit awesome", group = "awesome"}),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)          end,
              {description = "increase master width factor", group = "layout"}),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)          end,
              {description = "decrease master width factor", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1, nil, true) end,
              {description = "increase the number of master clients", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1, nil, true) end,
              {description = "decrease the number of master clients", group = "layout"}),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1, nil, true)    end,
              {description = "increase the number of columns", group = "layout"}),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1, nil, true)    end,
              {description = "decrease the number of columns", group = "layout"}),
    awful.key({ modkey,           }, "space", function () awful.layout.inc( 1)                end,
              {description = "select next", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(-1)                end,
              {description = "select previous", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "u",     function () awful.client.incwfact( 0.05)    end,
              {description = "increase the number of rows", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "p",     function () awful.client.incwfact(-0.05)    end,
              {description = "decrease the number of rows", group = "layout"}),

    awful.key({ modkey, "Control" }, "n",
              function ()
                  local c = awful.client.restore()
                  -- Focus restored client
                  if c then
                      client.focus = c
                      c:raise()
                  end
              end,
              {description = "restore minimized", group = "client"}),

    -- Prompt
    awful.key({ modkey },            "r",     function () awful.screen.focused().mypromptbox:run() end,
              {description = "run prompt", group = "launcher"}),

    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run {
                    prompt       = "Run Lua code: ",
                    textbox      = awful.screen.focused().mypromptbox.widget,
                    exe_callback = awful.util.eval,
                    history_path = awful.util.get_cache_dir() .. "/history_eval"
                  }
              end,
              {description = "lua execute prompt", group = "awesome"}),
    -- Menubar
    awful.key({ modkey }, "p", function() menubar.show() end,
              {description = "show the menubar", group = "launcher"}),

    -- Volume control --
    awful.key({ modkey }, ".", function () os.execute("pgrep -x amixer || amixer set Master 5%+") end, {description = "increase volume by 5%", group = "sound"}),
    awful.key({ modkey }, ",", function () os.execute("pgrep -x amixer || amixer set Master 5%-") end, {description = "decrease volume by 5%", group = "sound"}),
    awful.key({ modkey }, "/", function () awful.util.spawn("amixer sset Master toggle") end, {description = "mute / unmute", group = "sound"}),
    awful.key({ }, "XF86AudioRaiseVolume", function () os.execute("pgrep -x amixer || amixer set Master 5%+") end, {description = "increase volume by 5%", group = "sound"}),
    awful.key({ }, "XF86AudioLowerVolume", function () os.execute("pgrep -x amixer || amixer set Master 5%-") end, {description = "decrease volume by 5%", group = "sound"}),
    awful.key({ }, "XF86AudioMute", function () awful.util.spawn("amixer sset Master toggle") end, {description = "mute / unmute", group = "sound"}),

    -- Player control --
    awful.key({ modkey }, "p",function () awful.util.spawn( "mpc play" ); awful.util.spawn( "audacious -p" ) end, {description = "start play", group = "sound"} ),
    awful.key({ modkey }, ";",function () awful.util.spawn( "mpc pause" ); awful.util.spawn( "audacious -u" ) end, {description = "pause / play", group = "sound"} ),
    awful.key({ modkey }, "'",function () awful.util.spawn( "mpc prev" ); awful.util.spawn( "audacious -r" ) end, {description = "play previous song", group = "sound"} ),
    awful.key({ modkey }, "\\",function () awful.util.spawn( "mpc next" ); awful.util.spawn( "audacious -f" ) end, {description = "play next song", group = "sound"} ),

    awful.key({        }, "Print", function () awful.util.spawn_with_shell ("DATE=`date +%Y%m%d_%H%M%S`;"..
                                   "xsnap -nogui -file $HOME/screenshots/$DATE && geeqie -r $HOME/screenshots/$DATE.png") end, {description = "print screen", group = "screen"}),
	-- Lock Screen --
    awful.key({ "Mod4"   }, "l", function () os.execute ("xscreensaver-command --lock") end, {description = "Lock screen", group = "login"})
)

clientkeys = gears.table.join(
    awful.key({ modkey,           }, "f",
        function (c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        {description = "toggle fullscreen", group = "client"}),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end,
              {description = "close", group = "client"}),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ,
              {description = "toggle floating", group = "client"}),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end,
              {description = "move to master", group = "client"}),
    awful.key({ modkey,           }, "o",      function (c) c:move_to_screen()               end,
              {description = "move to screen", group = "client"}),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end,
              {description = "toggle keep on top", group = "client"}),
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end ,
        {description = "minimize", group = "client"}),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized = not c.maximized
            c:raise()
        end ,
        {description = "(un)maximize", group = "client"}),
    awful.key({ modkey, "Control" }, "m",
        function (c)
            c.maximized_vertical = not c.maximized_vertical
            c:raise()
        end ,
        {description = "(un)maximize vertically", group = "client"}),
    awful.key({ modkey, "Shift"   }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c:raise()
        end ,
        {description = "(un)maximize horizontally", group = "client"})
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 12 do
    globalkeys = gears.table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = awful.screen.focused()
                        local tag = screen.tags[i]
                        if tag then
                           tag:view_only()
                        end
                  end,
                  {description = "view tag #"..i, group = "tag"}),
        -- Toggle tag display.
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = awful.screen.focused()
                      local tag = screen.tags[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end,
                  {description = "toggle tag #" .. i, group = "tag"}),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:move_to_tag(tag)
                          end
                     end
                  end,
                  {description = "move focused client to tag #"..i, group = "tag"}),
        -- Toggle tag on focused client.
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:toggle_tag(tag)
                          end
                      end
                  end,
                  {description = "toggle focused client on tag #" .. i, group = "tag"})
    )
end

clientbuttons = gears.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)

----< Rules >------------------------------------------------------
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = naughty.config.defaults.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     raise = true,
                     keys = clientkeys,
                     size_hints_honor = false,
                     buttons = clientbuttons,
                     screen = awful.screen.preferred,
                     placement = awful.placement.no_overlap+awful.placement.no_offscreen
     }
    },

    -- Floating clients.
    { rule_any = {
        instance = {
          "DTA",  -- Firefox addon DownThemAll.
          "copyq",  -- Includes session name in class.
        },
        class = {
          "Arandr",
          "Gpick",
          "Kruler",
          "MessageWin",  -- kalarm.
          "Sxiv",
          "Wpa_gui",
          "pinentry",
          "veromix",
          "xtightvncviewer"},

        name = {
          "Event Tester",  -- xev.
        },
        role = {
          "AlarmWindow",  -- Thunderbird's calendar.
          "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
        }
      }, properties = { floating = true }},

    -- Default 'Normal' clients properties
    { rule_any = {type = { "normal" }
      }, properties = { titlebars_enabled = false; border_width = 0; floating = false; }
    },
    -- Default 'Dialog' clients properties
    { rule_any = {type = { "dialog" }
      }, properties = { titlebars_enabled = true; border_width = 2; }
    },

--    { rule = { class = "URxvt" },
--      properties = { tag = "2" } },
--    { rule = { class = "Firefox" },
--      properties = { tag = "1" } },
--    { rule = { class = "Opera" },
--      properties = { tag = "1" } },
--    { rule = { class = "Thunderbird" },
--      properties = { tag = "1" } },
--    { rule = { class = "VirtualBox" },
--      properties = { tag = "3" } },
--    { rule = { class = "Remmina" },
--      properties = { tag = "3" } },
--    { rule = { class = "Spicy" },
--      properties = { tag = "3" } },
--    { rule = { class = "Aqemu" },
--      properties = { tag = "3" } },
--    { rule = { name = "Instances - Vimperator" },
--      properties = { tag = "3" } },
--    { rule = { name = "VMs - .* - Vimperator" },
--      properties = { tag = "3" } },
--    { rule = { name = "noVNC - .* - Vimperator" },
--      properties = { tag = "3" } },
--    { rule = { class = "Soffice" },
--      properties = { tag = "4" } },
--    { rule = { class = "LibreOffice" },
--      properties = { tag = "4" } },
--    { rule = { class = "libreoffice-writer" },
--      properties = { tag = "4" } },
--    { rule = { class = "libreoffice-calc" },
--      properties = { tag = "4" } },
--    { rule = { class = "libreoffice-draw" },
--      properties = { tag = "4" } },
--    { rule = { class = "libreoffice-base" },
--      properties = { tag = "4" } },
--    { rule = { class = "libreoffice-math" },
--      properties = { tag = "4" } },
--    { rule = { class = "libreoffice-impress" },
--      properties = { tag = "4" } },
--    { rule = { class = "libreoffice-startcenter" },
--      properties = { tag = "4" } },
--    { rule = { class = "Okular" },
--      properties = { tag = "4" } },
--    { rule = { class = "Lyx" },
--      properties = { tag = "4" } },
--    { rule = { class = "Evince" },
--      properties = { tag = "4" } },
--    { rule = { class = "Qt Jambi application" },
--      properties = { tag = "1" } },
    { rule = { class = "Pidgin" },
      properties = { tag = "+" } },
    { rule = { class = "Telegram" },
      properties = { tag = "+" } },
    { rule = { class = "Viber" },
      properties = { tag = "+" } },
    { rule = { class = "Stardict" },
      properties = { tag = "-" } },
--    { rule = { class = "MPlayer" },
--      properties = { floating = true } },
--    { rule = { class = "Texreport-gtk" },
--      properties = { floating = true } },
--    { rule = { class = "etr" },
--      properties = { tag = "6" } },
--    { rule = { class = "Eboard" },
--      properties = { tag = "6" } },
--    { rule = { class = "charleygame-bin" },
--      properties = { tag = "6" } },
--    { rule = { class = "lincity-ng" },
--      properties = { tag = "6" } },
--    { rule = { class = "Kodi" },
--      properties = { tag = "6" } },
--    { rule = { class = "Vlc" },
--      properties = { tag = "6" } },
    { rule = { class = "Audacious" },
      properties = { tag = "0" } },
--    { rule = { class = "Audacity" },
--      properties = { tag = "6" } },
--    { rule = { class = "Gimp" },
--      properties = { tag = "7" } },
--    { rule = { class = "Blender" },
--      properties = { tag = "7" } },
--    { rule = { class = "Anjuta" },
--      properties = { tag = "5" } },
--    { rule = { class = "Android SDK Manager" },
--      properties = { tag = "5" } },
--    { rule = { class = "DDMS" },
--      properties = { tag = "5" } },
--    { rule = { class = "Gucharmap" },
--      properties = { tag = "5" } },
--    { rule = { class = "Pcmanfm" },
--      properties = { tag = "4" } },
--    { rule = { class = "Fm" },
--      properties = { tag = "4" } },
--    { rule = { class = "File-roller" },
--      properties = { tag = "4" } },
--    { rule = { class = "Clamtk" },
--      properties = { tag = "4" } },
--    { rule = { class = "Assistant" },
--      properties = { tag = "5" } },
--    { rule = { class = "Bluefish" },
--      properties = { tag = "5" } },
--    { rule = { class = "Designer" },
--      properties = { tag = "5" } },
--    { rule = { class = "Glade" },
--      properties = { tag = "5" } },
--    { rule = { class = "Geany" },
--      properties = { tag = "5" } },
--    { rule = { class = "Gvim" },
--      properties = { tag = "5" } },
--    { rule = { class = "Qtcreator" },
--      properties = { tag = "5" } },
--    { rule = { class = "Kcachegrind" },
--      properties = { tag = "5" } },
--    { rule = { class = "Wxmaxima" },
--      properties = { tag = "5" } },
--    { rule = { class = "0ad" },
--      properties = { tag = "6" } },
--    { rule = { class = "dosbox" },
--      properties = { tag = "3" } },
--    { rule = { class = "Steam" },
--      properties = { tag = "6" } },
--    { rule = { class = "supertux" },
--      properties = { tag = "6" } },
--    { rule = { name = "Minetest" },
--      properties = { tag = "6" } },
--    { rule = { name = "glxgears" },
--      properties = { tag = "6" } },
--    { rule = { class = "urbanterror" },
--      properties = { tag = "6" } },
--    { rule = { class = "warzone2100" },
--      properties = { tag = "6" } },
--    { rule = { class = "xonotic-sdl" },
--      properties = { tag = "6" } },
--    { rule = { class = "DarkPlaces" },
--      properties = { tag = "6" } },
--    { rule = { class = "Camorama" },
--      properties = { tag = "6" } },
--    { rule = { class = "Dia" },
--      properties = { tag = "7" } },
--    { rule = { class = "feh" },
--      properties = { tag = "7" } },
--    { rule = { class = "FreeCAD" },
--      properties = { tag = "7" } },
--    { rule = { class = "Gcolor2" },
--      properties = { tag = "7" } },
--    { rule = { class = "GQview" },
--      properties = { tag = "7" } },
--    { rule = { class = "Inkscape" },
--      properties = { tag = "7" } },
--    { rule = { class = "Shotwell" },
--      properties = { tag = "7" } },
--    { rule = { name = "Xdvi" },
--      properties = { tag = "4" } },
--    { rule = { class = "Deluge" },
--      properties = { tag = "1" } },
--    { rule = { class = "Eiskaltdcpp" },
--      properties = { tag = "1" } },
--    { rule = { class = "Ekiga" },
--      properties = { tag = "+" } },
--    { rule = { class = "Googleearth-bin" },
--      properties = { tag = "1" } },
--    { rule = { class = "Links" },
--      properties = { tag = "1" } },
--    { rule = { class = "Linphone" },
--      properties = { tag = "1" } },
    { rule = { class = "psi" },
      properties = { tag = "+" } },
--    { rule = { class = "Transmission" },
--      properties = { tag = "1" } },
--    { rule = { class = "Vncviewer" },
--      properties = { tag = "3" } },
--    { rule = { class = "Avidemux" },
--      properties = { tag = "6" } },
--    { rule = { class = "Xfburn" },
--      properties = { tag = "6" } },
--    { rule = { class = "Gtk-recordMyDesktop" },
--      properties = { tag = "6" } },
--    { rule = { class = "Qv4l2" },
--      properties = { tag = "6" } },
--    { rule = { class = "V4l2ucp" },
--      properties = { tag = "6" } },
--    { rule = { class = "TiMidity" },
--      properties = { tag = "6" } },
--    { rule = { class = "Gnumeric" },
--      properties = { tag = "4" } },
--    { rule = { class = "Yagf" },
--      properties = { tag = "4" } },
--    { rule = { class = "Xchm" },
--      properties = { tag = "4" } },
--    { rule = { class = "Flash-player-properties" },
--      properties = { tag = "1" } },
--    { rule = { class = "Libfm-pref-apps" },
--      properties = { tag = "4" } },
--    { rule = { class = "Qtconfig" },
--      properties = { tag = "5" } },
--    { rule = { class = "Baobab" },
--      properties = { tag = "4" } },
--    { rule = { class = "Gcdemu" },
--      properties = { tag = "3" } },
--    { rule = { class = "Wireshark" },
--      properties = { tag = "1" } },
--    { rule = { name = "Frozen-.*Bubble" },
--      properties = { tag = "6" } },
--    { rule = { class = "d-feet" },
--      properties = { tag = "5" } },
--    { rule = { class = "Cinelerra" },
--      properties = { tag = "6" } },
--    { rule = { class = "Kdenlive" },
--      properties = { tag = "6" } },
--    { rule = { class = "Dconf-editor" },
--      properties = { tag = "5" } },
}

----< Signals >------------------------------------------------------
--
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup and
      not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
    -- buttons for the titlebar
    local buttons = gears.table.join(
        awful.button({ }, 1, function()
            client.focus = c
            c:raise()
            awful.mouse.client.move(c)
        end),
        awful.button({ }, 3, function()
            client.focus = c
            c:raise()
            awful.mouse.client.resize(c)
        end)
    )

    awful.titlebar(c) : setup {
        { -- Left
            awful.titlebar.widget.iconwidget(c),
            buttons = buttons,
            layout  = wibox.layout.fixed.horizontal
        },
        { -- Middle
            { -- Title
                align  = "center",
                widget = awful.titlebar.widget.titlewidget(c)
            },
            buttons = buttons,
            layout  = wibox.layout.flex.horizontal
        },
        { -- Right
            awful.titlebar.widget.floatingbutton (c),
            awful.titlebar.widget.maximizedbutton(c),
            awful.titlebar.widget.stickybutton   (c),
            awful.titlebar.widget.ontopbutton    (c),
            awful.titlebar.widget.closebutton    (c),
            layout = wibox.layout.fixed.horizontal()
        },
        layout = wibox.layout.align.horizontal
    }
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
        and awful.client.focus.filter(c) then
        client.focus = c
    end
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)

-- Borders for floating windows
client.connect_signal("property::floating", function(c)
        if c.maximized or c.fullscreen then return end

        if c.floating and not c.maximized and not c.fullscreen then
            if c.titlebar == nil then
               c:emit_signal("request::titlebars", "rules", {})
            end
            awful.titlebar.show(c)
            c.border_width = 2
        else
            awful.titlebar.hide(c)
            c.border_width = 0
        end
end)

client.connect_signal("property::maximized", function(c)
        if c.maximized or c.fullscreen or not c.floating then
            awful.titlebar.hide(c)
            c.border_width = 0
        else
            if c.floating then
              awful.titlebar.show(c)
              c.border_width = 2
            end
        end
end)
