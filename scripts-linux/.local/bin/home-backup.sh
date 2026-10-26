#!/usr/bin/env bash
set -euo pipefail

BACKUP_MOUNT="/mnt/backup"
BACKUP_DIR="$BACKUP_MOUNT/10_LINUX/Arch/home-snapshots"
SOURCE="$HOME/"
KEEP=4
LOG="$BACKUP_DIR/backup.log"
DATE=$(date +%Y-%m-%d)
DEST="$BACKUP_DIR/$DATE"

log() { echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" | tee -a "$LOG"; }
trap 'log "ERROR: script exited unexpectedly at line $LINENO"' ERR

# Check that the backup drive is mounted
if ! mountpoint -q "$BACKUP_MOUNT"; then
    # Drive not mounted — log to a fallback location so the failure is visible
    FALLBACK_LOG="$HOME/.local/share/home-backup-errors.log"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] ERROR: $BACKUP_MOUNT is not mounted — backup aborted" | tee -a "$FALLBACK_LOG"
    exit 1
fi

mkdir -p "$BACKUP_DIR"
log "--- Backup started → $DEST"

# Find most recent snapshot to use as hard-link base (delta storage)
LATEST=$(ls -1d "$BACKUP_DIR"/[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9] 2>/dev/null | sort | tail -1 || true)

RSYNC_OPTS=(
    -a                  # archive: preserves permissions, timestamps, symlinks, etc.
    --delete            # remove files from dest that no longer exist in source
    --stats             # print transfer statistics
    --human-readable    # human-readable sizes in stats
    # --- Excludes: large dirs that can be redownloaded or regenerated ---
    --exclude='.cache/'
    --exclude='.npm/'
    --exclude='.local/share/Steam/'
    --exclude='.local/share/lazyvim/'
    --exclude='.local/share/mise/'
    --exclude='.local/share/PrismLauncher/libraries/'
    --exclude='.local/share/PrismLauncher/cache/'
    --exclude='.local/share/containers/storage/overlay/'
)

# If a previous snapshot exists, hard-link unchanged files from it (saves space)
if [ -n "$LATEST" ]; then
    RSYNC_OPTS+=(--link-dest="$LATEST")
    log "Using hard-link base: $LATEST"
else
    log "No previous snapshot found — performing full backup"
fi

mkdir -p "$DEST"
STATUS=0
LOG_START=$(wc -l < "$LOG")
rsync "${RSYNC_OPTS[@]}" "$SOURCE" "$DEST/" >> "$LOG" 2>&1 || STATUS=$?

# A full destination also exits 23 — never treat that as rotatable, or an
# incomplete snapshot would push out good ones. (11 = rsync's file I/O error.)
if [ "$STATUS" -eq 23 ] && tail -n +"$((LOG_START + 1))" "$LOG" | grep -q 'No space left on device'; then
    STATUS=11
fi

# 23 = some files/attrs not transferred, 24 = source files vanished mid-run.
# The snapshot is still usable, so rotate anyway — otherwise one unreadable
# file blocks rotation forever and snapshots pile up until the NTFS MFT fills.
if [ "$STATUS" -eq 0 ] || [ "$STATUS" -eq 23 ] || [ "$STATUS" -eq 24 ]; then
    if [ "$STATUS" -eq 0 ]; then
        log "Backup SUCCESS: $DEST"
    else
        log "Backup PARTIAL (rsync status $STATUS, see errors above): $DEST"
    fi

    # Rotate: delete snapshots beyond $KEEP (oldest first)
    mapfile -t OLD < <(ls -1d "$BACKUP_DIR"/[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9] 2>/dev/null | sort | head -n -"$KEEP" || true)
    for dir in "${OLD[@]}"; do
        log "Rotating out old snapshot: $dir"
        rm -rf "$dir"
    done
else
    log "ERROR: rsync exited with status $STATUS — incomplete snapshot left at $DEST"
    exit $STATUS
fi

log "--- Done"
