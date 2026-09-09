#!/usr/bin/env bash
set -uo pipefail

LOG="$HOME/.local/share/system-checkup.log"
mkdir -p "$(dirname "$LOG")"
ts() { date '+%Y-%m-%d %H:%M:%S'; }

failures=()

check() {
    local name="$1" cmd="$2"
    if eval "$cmd"; then
        echo "[$(ts)] OK   $name" | tee -a "$LOG"
    else
        echo "[$(ts)] FAIL $name" | tee -a "$LOG"
        failures+=("$name")
    fi
}

check "Backup drive mounted (/mnt/backup)"        'mountpoint -q /mnt/backup'
check "Weekly home backup not in failed state"    '[ "$(systemctl --user is-failed home-backup.service 2>&1)" != "failed" ]'
check "UPS monitoring active (nut-monitor)"        'systemctl is-active -q nut-monitor'
check "UPS server active (nut-server)"             'systemctl is-active -q nut-server'
check "SMART disk monitoring active (smartd)"      'systemctl is-active -q smartd'

if [ "${#failures[@]}" -gt 0 ]; then
    body=$(printf '✗ FAILED: %s\n' "${failures[@]}")
    notify-send -u critical -i dialog-warning "System checkup: ${#failures[@]} issue(s) found" "$body"
    echo "[$(ts)] --- ${#failures[@]} failure(s) ---" | tee -a "$LOG"
else
    echo "[$(ts)] --- all checks passed ---" | tee -a "$LOG"
fi
