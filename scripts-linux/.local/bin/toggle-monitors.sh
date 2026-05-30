#!/bin/bash
# Toggle secondary monitors (HDMI-A-1 and DP-2 when present) for FreeSync gaming
# Uses kscreen-doctor (KDE Wayland). Preserves position/mode on re-enable.
# DP-2 (TV) only appears in kscreen output when powered on; skip its commands when absent.

# Warm up the KScreen daemon — first invocation after session start can drop writes silently
kscreen-doctor -o > /dev/null 2>&1
sleep 0.3

OUTPUTS=$(kscreen-doctor -o 2>&1)
HAS_DP2=$(echo "$OUTPUTS" | grep -c "DP-2")

disable_secondary() {
    if [ "$HAS_DP2" -gt 0 ]; then
        kscreen-doctor output.HDMI-A-1.disable output.DP-2.disable
    else
        kscreen-doctor output.HDMI-A-1.disable
    fi
}

if echo "$OUTPUTS" | grep -A2 "HDMI-A-1" | grep -q "enabled"; then
    disable_secondary
    # KDE's kscreen daemon can auto-restore its saved config within ~1s; re-apply if it does.
    sleep 1
    if kscreen-doctor -o 2>&1 | grep -A2 "HDMI-A-1" | grep -q "enabled"; then
        disable_secondary
    fi
    notify-send "Monitors" "Secondary monitors disabled — FreeSync ready"
else
    # Enable HDMI-A-1 first with explicit position so it stays independent (not mirrored)
    kscreen-doctor output.HDMI-A-1.enable output.HDMI-A-1.position.-1920,0
    # Then enable DP-2 separately to avoid replication confusion (see arch/freesync-monitor-toggle.md)
    [ "$HAS_DP2" -gt 0 ] && kscreen-doctor output.DP-2.enable
    notify-send "Monitors" "Secondary monitors enabled"
fi
