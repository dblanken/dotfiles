#!/bin/bash

# Disable all monitors except the primary (DisplayPort-0 / DP-1)
# Uncomment ONE block below depending on your display server:

# ---- xrandr (X11 / Pop!_OS 22.04) ----
# xrandr --output DisplayPort-1 --off \
#        --output HDMI-A-0 --off \
#        --output DisplayPort-2 --off

# ---- cosmic-randr (Wayland / Cosmic DE 24.04) ----
cosmic-randr disable DP-2
cosmic-randr disable HDMI-A-1
