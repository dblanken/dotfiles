#!/bin/bash

# Mirror TV (DisplayPort-1 / DP-2) to primary monitor (DisplayPort-0 / DP-1)
# Uncomment ONE block below depending on your display server:

# ---- xrandr (X11 / Pop!_OS 22.04) ----
# xrandr --output DisplayPort-1 --same-as DisplayPort-0 --auto

# ---- cosmic-randr (Wayland / Cosmic DE 24.04) ----
# Usage: mirror <OUTPUT> <FROM>  (mirrors OUTPUT to show the same as FROM)
cosmic-randr mirror DP-2 DP-1
