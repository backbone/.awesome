os.execute ("numlockx on &")
os.execute ("xsetroot -cursor_name left_ptr &")
os.execute ("pgrep xscreensaver || xscreensaver -no-splash &")
os.execute ("pgrep pidgin || pidgin &")
os.execute ("pgrep stardict || stardict &")
os.execute ("pgrep urxvt || urxvt &")
os.execute ("pgrep firefox || (firefox || firefox-bin) &")
os.execute ("smbnetfs "..os.getenv("HOME").."/smb")
os.execute (os.getenv("HOME").."/.config/awesome/set_wall.sh "..os.getenv("HOME").."/.config/awesome/wallpaper.slink")
os.execute ("pgrep mail_loop.sh || "..os.getenv("HOME").."/.config/awesome/mail_loop.sh &")
os.execute ("pgrep lightsOn.sh || "..os.getenv("HOME").."/.config/awesome/lightsOn.sh &")
os.execute ("pgrep wicd-client || wicd-gtk --tray &")
