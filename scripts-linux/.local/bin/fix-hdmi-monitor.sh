#!/bin/bash

sleep 2

# Set up HDMI monitor on the left, primary DP monitor on the right, TV mirrored to primary.
# Uncomment ONE block below depending on your display server:

# ---- xrandr (X11 / Pop!_OS 22.04) ----
# Note: --newmode/--addmode use a custom reduced-blanking modeline for HDMI.
# This is not needed (or possible) under Wayland; use the cosmic-randr block instead.
# xrandr --newmode "1920x1080_60_rb"  138.50  1920 1968 2000 2080  1080 1083 1088 1111 +hsync -vsync 2>/dev/null
# xrandr --addmode HDMI-A-0 "1920x1080_60_rb" 2>/dev/null
# xrandr --output HDMI-A-0 --mode "1920x1080_60_rb" --pos 0x0 \
#        --output DisplayPort-0 --mode 1920x1080 --rate 144 --pos 1920x0 --primary \
#        --output DisplayPort-1 --mode 1920x1080 --rate 60 --same-as DisplayPort-0

# ---- cosmic-randr (Wayland / Cosmic DE 24.04) ----
cosmic-randr enable HDMI-A-1
cosmic-randr mode HDMI-A-1 1920 1080 --refresh 60 --pos-x 0 --pos-y 0
cosmic-randr mode DP-1 1920 1080 --refresh 144 --pos-x 1920 --pos-y 0
cosmic-randr mirror DP-2 DP-1
