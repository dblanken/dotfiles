#!/bin/bash
sleep 2
xrandr --newmode "1920x1080_60_rb"  138.50  1920 1968 2000 2080  1080 1083 1088 1111 +hsync -vsync 2>/dev/null
xrandr --addmode HDMI-A-0 "1920x1080_60_rb" 2>/dev/null
xrandr --output HDMI-A-0 --mode "1920x1080_60_rb" --pos 0x0 \
       --output DisplayPort-0 --mode 1920x1080 --rate 144 --pos 1920x0 --primary \
       --output DisplayPort-1 --mode 1920x1080 --rate 60 --same-as DisplayPort-0
