#!/bin/sh

if [ -d $1 ]; then
    f="$(find $1 -type f | shuf -n1)"
    ln -sf "$f" ~/.config/awesome/wallpaper.slink
    feh --bg-scale "$f"
else
    feh --bg-scale $1
fi
