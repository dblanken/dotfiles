#!/bin/bash
# Toggle only HDMI-A-1, leaving DP-2 (Vizio TV, usually mirroring DP-1) alone.
# HDMI-only sibling of toggle-monitors.sh — see system-setup/freesync-monitor-toggle.md

# Warm up the KScreen daemon — first invocation after session start can drop writes silently
kscreen-doctor -o > /dev/null 2>&1
sleep 0.3

hdmi_enabled() { kscreen-doctor -o 2>&1 | grep -A2 "HDMI-A-1" | grep -q "enabled"; }

if hdmi_enabled; then
    kscreen-doctor output.HDMI-A-1.disable
    # KDE's kscreen daemon can auto-restore its saved config within ~1s; re-apply if it does.
    sleep 1
    hdmi_enabled && kscreen-doctor output.HDMI-A-1.disable
    notify-send "Monitors" "HDMI monitor disabled (Vizio untouched)"
else
    # Explicit position keeps it independent rather than inheriting a mirror config
    kscreen-doctor output.HDMI-A-1.enable output.HDMI-A-1.position.0,0
    notify-send "Monitors" "HDMI monitor enabled"
fi
