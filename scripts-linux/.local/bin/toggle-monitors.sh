#!/bin/bash
# Toggle secondary monitors (HDMI-A-1 and DP-2 when present) for FreeSync gaming
# Uses kscreen-doctor (KDE Wayland). Preserves position/mode on re-enable.
# DP-2 (TV) only appears in kscreen output when powered on; skip its commands when absent.

OUTPUTS=$(kscreen-doctor -o 2>&1)
HAS_DP2=$(echo "$OUTPUTS" | grep -c "DP-2")

if echo "$OUTPUTS" | grep -A2 "HDMI-A-1" | grep -q "enabled"; then
    kscreen-doctor output.HDMI-A-1.disable
    [ "$HAS_DP2" -gt 0 ] && kscreen-doctor output.DP-2.disable
    notify-send "Monitors" "Secondary monitors disabled — FreeSync ready"
else
    # Enable HDMI-A-1 first with explicit position so it stays independent (not mirrored)
    kscreen-doctor output.HDMI-A-1.enable output.HDMI-A-1.position.-1920,0
    # Then enable DP-2 separately to avoid replication confusion (see arch/freesync-monitor-toggle.md)
    [ "$HAS_DP2" -gt 0 ] && kscreen-doctor output.DP-2.enable
    notify-send "Monitors" "Secondary monitors enabled"
fi
