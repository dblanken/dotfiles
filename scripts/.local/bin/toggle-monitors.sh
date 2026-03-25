#!/bin/bash
# Toggle secondary monitors (HDMI-A-1 and DP-2) for FreeSync gaming
# Uses kscreen-doctor (KDE Wayland). Preserves position/mode on re-enable.

if kscreen-doctor -o 2>&1 | grep -A2 "HDMI-A-1" | grep -q "enabled"; then
    kscreen-doctor output.HDMI-A-1.disable output.DP-2.disable
    notify-send "Monitors" "Secondary monitors disabled — FreeSync ready"
else
    # Enable HDMI-A-1 first with explicit position so it stays independent (not mirrored)
    kscreen-doctor output.HDMI-A-1.enable output.HDMI-A-1.position.-1920,0
    # Then enable DP-2 (mirror of DP-1) separately to avoid replication confusion
    kscreen-doctor output.DP-2.enable
    notify-send "Monitors" "Secondary monitors enabled"
fi
