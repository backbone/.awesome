-------------------------------
--  "Zenburn" awesome theme  --
--    By Adrian C. (anrxc)   --
-------------------------------

local themes_path = require("gears.filesystem").get_themes_dir()

-- {{{ Main
local theme = {}
theme.wallpaper = themes_path .. "zenburn/zenburn-background.png"
-- }}}

-- {{{ Styles
theme.font      = "sans 8"

-- {{{ Colors
theme.fg_normal  = "#DCDCCC"
theme.fg_focus   = "#F0DFAF"
theme.fg_urgent  = "#CC9393"
theme.bg_normal  = "#3F3F3F"
theme.bg_focus   = "#1E2320"
theme.bg_urgent  = "#3F3F3F"
theme.bg_systray = theme.bg_normal
-- }}}

-- {{{ Borders
theme.useless_gap   = 0
theme.border_width  = 0
theme.border_normal = "#3F3F3F"
theme.border_focus  = "#6F6F6F"
theme.border_marked = "#CC9393"
-- }}}

-- {{{ Titlebars
theme.titlebar_bg_focus  = "#3F3F3F"
theme.titlebar_bg_normal = "#3F3F3F"
-- }}}

-- There are other variable sets
-- overriding the default one when
-- defined, the sets are:
-- [taglist|tasklist]_[bg|fg]_[focus|urgent|occupied|empty|volatile]
-- titlebar_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- Example:
--theme.taglist_bg_focus = "#CC9393"
-- }}}

-- {{{ Widgets
-- You can add as many variables as
-- you wish and access them by using
-- beautiful.variable in your rc.lua
--theme.fg_widget        = "#AECF96"
--theme.fg_center_widget = "#88A175"
--theme.fg_end_widget    = "#FF5656"
--theme.bg_widget        = "#494B4F"
--theme.border_widget    = "#3F3F3F"
-- }}}

-- {{{ Mouse finder
theme.mouse_finder_color = "#CC9393"
-- mouse_finder_[timeout|animate_timeout|radius|factor]
-- }}}

-- {{{ Menu
-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
theme.menu_height = 15
theme.menu_width  = 100
-- }}}

-- {{{ Icons
-- {{{ Taglist
theme.taglist_squares_sel   = themes_path .. "zenburn/taglist/squarefz.png"
theme.taglist_squares_unsel = themes_path .. "zenburn/taglist/squarez.png"
--theme.taglist_squares_resize = "false"
-- }}}

-- {{{ Misc
theme.awesome_icon           = themes_path .. "zenburn/awesome-icon.png"
theme.menu_submenu_icon      = themes_path .. "default/submenu.png"
-- }}}

-- {{{ Layout
theme.layout_tile       = themes_path .. "zenburn/layouts/tile.png"
theme.layout_tileleft   = themes_path .. "zenburn/layouts/tileleft.png"
theme.layout_tilebottom = themes_path .. "zenburn/layouts/tilebottom.png"
theme.layout_tiletop    = themes_path .. "zenburn/layouts/tiletop.png"
theme.layout_fairv      = themes_path .. "zenburn/layouts/fairv.png"
theme.layout_fairh      = themes_path .. "zenburn/layouts/fairh.png"
theme.layout_spiral     = themes_path .. "zenburn/layouts/spiral.png"
theme.layout_dwindle    = themes_path .. "zenburn/layouts/dwindle.png"
theme.layout_max        = themes_path .. "zenburn/layouts/max.png"
theme.layout_fullscreen = themes_path .. "zenburn/layouts/fullscreen.png"
theme.layout_magnifier  = themes_path .. "zenburn/layouts/magnifier.png"
theme.layout_floating   = themes_path .. "zenburn/layouts/floating.png"
theme.layout_cornernw   = themes_path .. "zenburn/layouts/cornernw.png"
theme.layout_cornerne   = themes_path .. "zenburn/layouts/cornerne.png"
theme.layout_cornersw   = themes_path .. "zenburn/layouts/cornersw.png"
theme.layout_cornerse   = themes_path .. "zenburn/layouts/cornerse.png"
-- }}}

-- {{{ Titlebar
theme.titlebar_close_button_focus  = themes_path .. "zenburn/titlebar/close_focus.png"
theme.titlebar_close_button_normal = themes_path .. "zenburn/titlebar/close_normal.png"

theme.titlebar_minimize_button_normal = themes_path .. "default/titlebar/minimize_normal.png"
theme.titlebar_minimize_button_focus  = themes_path .. "default/titlebar/minimize_focus.png"

theme.titlebar_ontop_button_focus_active  = themes_path .. "zenburn/titlebar/ontop_focus_active.png"
theme.titlebar_ontop_button_normal_active = themes_path .. "zenburn/titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_inactive  = themes_path .. "zenburn/titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_inactive = themes_path .. "zenburn/titlebar/ontop_normal_inactive.png"

theme.titlebar_sticky_button_focus_active  = themes_path .. "zenburn/titlebar/sticky_focus_active.png"
theme.titlebar_sticky_button_normal_active = themes_path .. "zenburn/titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_inactive  = themes_path .. "zenburn/titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_inactive = themes_path .. "zenburn/titlebar/sticky_normal_inactive.png"

theme.titlebar_floating_button_focus_active  = themes_path .. "zenburn/titlebar/floating_focus_active.png"
theme.titlebar_floating_button_normal_active = themes_path .. "zenburn/titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_inactive  = themes_path .. "zenburn/titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_inactive = themes_path .. "zenburn/titlebar/floating_normal_inactive.png"

theme.titlebar_maximized_button_focus_active  = themes_path .. "zenburn/titlebar/maximized_focus_active.png"
theme.titlebar_maximized_button_normal_active = themes_path .. "zenburn/titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_inactive  = themes_path .. "zenburn/titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_inactive = themes_path .. "zenburn/titlebar/maximized_normal_inactive.png"
-- }}}
-- }}}

-- {{{ Widgets
local home = os.getenv("HOME")
local cfgpath = home.."/.config/awesome"

theme.widget_disk = cfgpath .. "/Icons/16x16/hdd_clear.png"
theme.widget_cpu = cfgpath .. "/themes/default/widgets/cpu.png"
theme.widget_ac = cfgpath .. "/themes/default/widgets/ac.png"
theme.widget_acblink = cfgpath .. "/themes/default/widgets/acblink.png"
theme.widget_blank = cfgpath .. "/themes/default/widgets/blank.png"
theme.widget_batfull = cfgpath .. "/themes/default/widgets/batfull.png"
theme.widget_batmed = cfgpath .. "/themes/default/widgets/batmed.png"
theme.widget_batlow = cfgpath .. "/themes/default/widgets/batlow.png"
theme.widget_batempty = cfgpath .. "/themes/default/widgets/batempty.png"
theme.widget_vol = cfgpath .. "/themes/default/widgets/vol.png"
theme.widget_mute = cfgpath .. "/themes/default/widgets/mute.png"
theme.widget_pac = cfgpath .. "/themes/default/widgets/pac.png"
theme.widget_pacnew = cfgpath .. "/themes/default/widgets/pacnew.png"
theme.widget_mail = cfgpath .. "/themes/default/widgets/mail.png"
theme.widget_mailnew = cfgpath .. "/themes/default/widgets/mailnew.png"
theme.widget_optimus_off = cfgpath .. "/themes/default/widgets/optimus_off.png"
theme.widget_optimus_on = cfgpath .. "/themes/default/widgets/optimus_on.png"
theme.widget_optimus_overclocked = cfgpath .. "/themes/default/widgets/optimus_overclocked.png"
theme.widget_temp = cfgpath .. "/themes/default/widgets/temp.png"
theme.widget_tempwarn = cfgpath .. "/themes/default/widgets/tempwarm.png"
theme.widget_temphot = cfgpath .. "/themes/default/widgets/temphot.png"
theme.widget_wifi = cfgpath .. "/Icons/16x16/net-wifi.png"
theme.widget_nowifi = cfgpath .. "/themes/default/widgets/nowifi.png"
theme.widget_wired = cfgpath .. "/Icons/16x16/net-wired.png"
theme.widget_wired_down_up = cfgpath .. "/Icons/16x16/down_up.png"
theme.widget_wifi_down_up = cfgpath .. "/Icons/16x16/down_up.png"
theme.widget_mpd = cfgpath .. "/themes/default/widgets/mpd.png"
theme.widget_play = cfgpath .. "/themes/default/widgets/play.png"
theme.widget_pause = cfgpath .. "/themes/default/widgets/pause.png"
theme.widget_ram = cfgpath .. "/themes/default/widgets/ram.png"
theme.widget_mem = cfgpath .. "/themes/default/tp/ram.png"
theme.widget_swap = cfgpath .. "/themes/default/tp/swap.png"
theme.widget_fs = cfgpath .. "/themes/default/tp/fs_01.png"
theme.widget_fs2 = cfgpath .. "/themes/default/tp/fs_02.png"
theme.widget_up = cfgpath .. "/themes/default/tp/up.png"
theme.widget_down = cfgpath .. "/themes/default/tp/down.png"
-- }}}

return theme

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
