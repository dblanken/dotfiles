#!/bin/bash

# Vintage Story Saves & Config Backup Script
# Usage: ./backup-vs.sh [/path/to/backup/destination]
# Defaults to /mnt/backups/VintageStory if no destination given
# Suitable for running as a weekly cron job

set -e
set -o pipefail

# Configuration
MAX_BACKUPS=8  # Keep last 8 weekly backups

# Auto-detect VS data directory: prefer native install, fall back to flatpak
VS_NATIVE_DIR="$HOME/.config/VintagestoryData"
VS_FLATPAK_DIR="$HOME/.var/app/at.vintagestory.VintageStory/config/VintagestoryData"

if [ -d "$VS_NATIVE_DIR" ]; then
  VS_DATA_DIR="$VS_NATIVE_DIR"
elif [ -d "$VS_FLATPAK_DIR" ]; then
  VS_DATA_DIR="$VS_FLATPAK_DIR"
else
  echo "Error: No Vintage Story data directory found."
  echo "  Checked: $VS_NATIVE_DIR"
  echo "  Checked: $VS_FLATPAK_DIR"
  exit 1
fi

BACKUP_DEST="${1:-/mnt/backup/01_GAME_BACKUPS/VintageStory}"
BACKUP_DATE=$(date +%Y-%m-%d_%H-%M-%S)
BACKUP_DIR="$BACKUP_DEST/vintagestory-backup-$BACKUP_DATE"
LOG_FILE="$BACKUP_DIR/backup.log"

# Check if source directory exists
if [ ! -d "$VS_DATA_DIR" ]; then
  echo "Error: Vintage Story data directory not found at $VS_DATA_DIR"
  exit 1
fi

mkdir -p "$BACKUP_DEST"

# Create backup directory
mkdir -p "$BACKUP_DIR"

# Logging function
log() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

log "========================================="
log "Vintage Story Backup Started"
log "========================================="
log "Source: $VS_DATA_DIR"
log "Destination: $BACKUP_DIR"

# 1. Back up saves
log "[1/4] Backing up world saves..."
if [ -d "$VS_DATA_DIR/Saves" ]; then
  rsync -a --info=progress2 "$VS_DATA_DIR/Saves/" "$BACKUP_DIR/Saves/" 2>&1 | tee -a "$LOG_FILE"
fi

if [ -d "$VS_DATA_DIR/BackupSaves" ]; then
  rsync -a --info=progress2 "$VS_DATA_DIR/BackupSaves/" "$BACKUP_DIR/BackupSaves/" 2>&1 | tee -a "$LOG_FILE"
fi

# 2. Back up mods and mod configurations/data
log "[2/4] Backing up mods, mod configurations, and mod data..."
if [ -d "$VS_DATA_DIR/Mods" ]; then
  rsync -a "$VS_DATA_DIR/Mods/" "$BACKUP_DIR/Mods/" 2>&1 | tee -a "$LOG_FILE"
fi

if [ -d "$VS_DATA_DIR/ModConfig" ]; then
  rsync -a "$VS_DATA_DIR/ModConfig/" "$BACKUP_DIR/ModConfig/" 2>&1 | tee -a "$LOG_FILE"
fi

if [ -d "$VS_DATA_DIR/ModData" ]; then
  rsync -a "$VS_DATA_DIR/ModData/" "$BACKUP_DIR/ModData/" 2>&1 | tee -a "$LOG_FILE"
fi

# 3. Back up player data and macros
log "[3/4] Backing up player data and macros..."
if [ -d "$VS_DATA_DIR/Playerdata" ]; then
  rsync -a "$VS_DATA_DIR/Playerdata/" "$BACKUP_DIR/Playerdata/" 2>&1 | tee -a "$LOG_FILE"
fi

if [ -d "$VS_DATA_DIR/Macros" ]; then
  rsync -a "$VS_DATA_DIR/Macros/" "$BACKUP_DIR/Macros/" 2>&1 | tee -a "$LOG_FILE"
fi

# 4. Back up configuration files
log "[4/4] Backing up configuration files..."
for config_file in clientsettings.json clientsettings.bkp serverconfig.json servermagicnumbers.json; do
  if [ -f "$VS_DATA_DIR/$config_file" ]; then
    cp "$VS_DATA_DIR/$config_file" "$BACKUP_DIR/"
  fi
done

# Create backup manifest
log "Creating backup manifest..."
cat > "$BACKUP_DIR/MANIFEST.txt" << EOF
Vintage Story Backup
====================
Created: $(date)
Computer: $(hostname)
User: $USER

Contents:
- Saves/        : World save files
- BackupSaves/  : In-game backup saves
- Mods/         : Installed mod files
- ModConfig/    : Mod configuration files
- ModData/      : Mod data and state
- Playerdata/   : Player data
- Macros/       : Player macros
- *.json        : Game configuration files

To restore:
  rsync -av $BACKUP_DIR/ $VS_DATA_DIR/

Note: Mods are not included - reinstall from mod portal.
EOF

# Calculate backup size
BACKUP_SIZE=$(du -sh "$BACKUP_DIR" | cut -f1)
FILE_COUNT=$(find "$BACKUP_DIR" -type f | wc -l)

log ""
log "========================================="
log "Backup Complete!"
log "========================================="
log "Location: $BACKUP_DIR"
log "Size: $BACKUP_SIZE"
log "Files: $FILE_COUNT"

# Cleanup old backups (keep only MAX_BACKUPS most recent)
log ""
log "Checking for old backups to remove..."
BACKUP_COUNT=$(find "$BACKUP_DEST" -maxdepth 1 -type d -name "vintagestory-backup-*" | wc -l)

if [ "$BACKUP_COUNT" -gt "$MAX_BACKUPS" ]; then
  REMOVE_COUNT=$((BACKUP_COUNT - MAX_BACKUPS))
  log "Found $BACKUP_COUNT backups, removing $REMOVE_COUNT oldest..."

  find "$BACKUP_DEST" -maxdepth 1 -type d -name "vintagestory-backup-*" -printf '%T+ %p\n' | \
    sort | head -n "$REMOVE_COUNT" | cut -d' ' -f2- | while read -r old_backup; do
      log "Removing: $old_backup"
      rm -rf "$old_backup"
    done
else
  log "Backup count ($BACKUP_COUNT) within limit ($MAX_BACKUPS), no cleanup needed."
fi

log ""
log "Finished: $(date)"
