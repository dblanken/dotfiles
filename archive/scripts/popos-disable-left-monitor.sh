#!/bin/bash

# Disable HDMI monitor
# Uncomment ONE block below depending on your display server:

# ---- xrandr (X11 / Pop!_OS 22.04) ----
# xrandr --output HDMI-A-0 --off

# ---- cosmic-randr (Wayland / Cosmic DE 24.04) ----
cosmic-randr disable HDMI-A-1
