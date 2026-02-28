#!/bin/bash

sleep 2

# Enable VRR (variable refresh rate / adaptive sync) on DisplayPort outputs
# Uncomment ONE block below depending on your display server:

# ---- xrandr (X11 / Pop!_OS 22.04) ----
# xrandr --output DisplayPort-0 --set "vrr_capable" 1
# xrandr --output DisplayPort-1 --set "vrr_capable" 1

# ---- cosmic-randr (Wayland / Cosmic DE 24.04) ----
# --adaptive-sync options: true, automatic, false
# "automatic" enables VRR only when a game/app requests it (recommended)
cosmic-randr mode DP-1 1920 1080 --refresh 144 --adaptive-sync automatic
cosmic-randr mode DP-2 1920 1080 --refresh 60  --adaptive-sync automatic
