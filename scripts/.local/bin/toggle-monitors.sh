#!/bin/bash
# Toggle secondary monitors (HDMI-A-1 and DP-2) for FreeSync gaming
# Uses kscreen-doctor (KDE Wayland). Preserves position/mode on re-enable.

if kscreen-doctor -o 2>&1 | grep -A2 "HDMI-A-1" | grep -q "enabled"; then
    kscreen-doctor output.HDMI-A-1.disable output.DP-2.disable
    notify-send "Monitors" "Secondary monitors disabled — FreeSync ready"
else
    kscreen-doctor output.HDMI-A-1.enable output.DP-2.enable
    notify-send "Monitors" "Secondary monitors enabled"
fi
