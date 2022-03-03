#!/bin/bash

xrandr --output eDP-1-1 --auto --primary
xrandr --output HDMI-0 --off --output DP-1-3 --off --output DP-1-4 --off --output DP-1-5 --off
xrandr --output HDMI-0 --auto --left-of eDP-1-1
xrandr --output DP-1-4 --auto --above eDP-1-1
xrandr --output DP-1-3 --auto --left-of DP-1-4
xrandr --output DP-1-5 --auto --right-of DP-1-4
#xrandr --output DP-1-6 --auto --below DP-1-5
