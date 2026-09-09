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
check "more_games drive mounted (/mnt/more_games)" 'mountpoint -q /mnt/more_games'
check "AI data symlinks intact (Ollama/HF/Podman)" '[ -e "$HOME/.ollama/models" ] && [ -e "$HOME/.cache/huggingface" ] && [ -e "$HOME/.local/share/containers/storage" ]'
check "HyperX virtual surround active (filter-chain)" 'systemctl --user is-active -q filter-chain'
check "OneDrive sync active"                       'systemctl --user is-active -q onedrive'
check "KDE Remote Desktop server active (krdpserver)" 'systemctl --user is-active -q app-org.kde.krdpserver'
check "Snapper timers not failed"                  '[ "$(systemctl is-failed snapper-timeline.timer 2>&1)" != "failed" ] && [ "$(systemctl is-failed snapper-cleanup.timer 2>&1)" != "failed" ]'
check "AUR malware check not failed"               '[ "$(systemctl --user is-failed aur-malware-check.service 2>&1)" != "failed" ]'
check "KRDP TLS cert not expiring within 30 days"  'openssl x509 -in "$HOME/.local/share/krdpserver/krdp.crt" -checkend 2592000 -noout >/dev/null'

if [ "${#failures[@]}" -gt 0 ]; then
    body=$(printf '✗ FAILED: %s\n' "${failures[@]}")
    notify-send -u critical -i dialog-warning "System checkup: ${#failures[@]} issue(s) found" "$body"
    echo "[$(ts)] --- ${#failures[@]} failure(s) ---" | tee -a "$LOG"
else
    echo "[$(ts)] --- all checks passed ---" | tee -a "$LOG"
fi
