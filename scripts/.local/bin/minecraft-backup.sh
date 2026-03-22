#!/bin/bash

# Prism Launcher (Minecraft) Backup Script
# Usage: ./minecraft-backup.sh [/path/to/backup/destination]
# Defaults to /mnt/backups/minecraft-backups if no destination given
# Suitable for running as a weekly cron job

set -e
set -o pipefail

# Configuration
MAX_BACKUPS=8  # Keep last 8 weekly backups
PRISM_DATA_DIR="$HOME/.var/app/org.prismlauncher.PrismLauncher/data/PrismLauncher"

BACKUP_DEST="${1:-/mnt/backup/01_GAME_BACKUPS/Prism_Launcher}"
BACKUP_DATE=$(date +%Y-%m-%d_%H-%M-%S)
BACKUP_DIR="$BACKUP_DEST/prism-backup-$BACKUP_DATE"
LOG_FILE="$BACKUP_DIR/backup.log"

# Check if source directory exists
if [ ! -d "$PRISM_DATA_DIR" ]; then
  echo "Error: Prism Launcher data directory not found at $PRISM_DATA_DIR"
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
log "Prism Launcher (Minecraft) Backup Started"
log "========================================="
log "Source: $PRISM_DATA_DIR"
log "Destination: $BACKUP_DIR"

# 1. Back up instances (saves, mods, configs, resourcepacks per instance)
log "[1/3] Backing up instances..."
if [ -d "$PRISM_DATA_DIR/instances" ]; then
  rsync -a --info=progress2 "$PRISM_DATA_DIR/instances/" "$BACKUP_DIR/instances/" 2>&1 | tee -a "$LOG_FILE"
else
  log "Warning: No instances directory found."
fi

# 2. Back up icons and catpacks
log "[2/3] Backing up icons and catpacks..."
if [ -d "$PRISM_DATA_DIR/icons" ]; then
  rsync -a "$PRISM_DATA_DIR/icons/" "$BACKUP_DIR/icons/" 2>&1 | tee -a "$LOG_FILE"
fi

if [ -d "$PRISM_DATA_DIR/catpacks" ]; then
  rsync -a "$PRISM_DATA_DIR/catpacks/" "$BACKUP_DIR/catpacks/" 2>&1 | tee -a "$LOG_FILE"
fi

# 3. Back up instance grouping config
log "[3/3] Backing up launcher config files..."
for config_file in instgroups.json prismlauncher.cfg; do
  if [ -f "$PRISM_DATA_DIR/$config_file" ]; then
    cp "$PRISM_DATA_DIR/$config_file" "$BACKUP_DIR/"
  fi
done

# Create backup manifest
log "Creating backup manifest..."
cat > "$BACKUP_DIR/MANIFEST.txt" << EOF
Prism Launcher (Minecraft) Backup
===================================
Created: $(date)
Computer: $(hostname)
User: $USER

Contents:
- instances/       : All Prism Launcher instances (saves, mods, configs, resourcepacks)
- icons/           : Custom instance icons
- catpacks/        : Cat cosmetics
- instgroups.json  : Instance grouping configuration
- prismlauncher.cfg: Launcher settings

To restore:
  rsync -av $BACKUP_DIR/ $PRISM_DATA_DIR/

Note: Java installations and Minecraft assets are not included and will be
re-downloaded by the launcher on first run.
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
BACKUP_COUNT=$(find "$BACKUP_DEST" -maxdepth 1 -type d -name "prism-backup-*" | wc -l)

if [ "$BACKUP_COUNT" -gt "$MAX_BACKUPS" ]; then
  REMOVE_COUNT=$((BACKUP_COUNT - MAX_BACKUPS))
  log "Found $BACKUP_COUNT backups, removing $REMOVE_COUNT oldest..."

  find "$BACKUP_DEST" -maxdepth 1 -type d -name "prism-backup-*" -printf '%T+ %p\n' | \
    sort | head -n "$REMOVE_COUNT" | cut -d' ' -f2- | while read -r old_backup; do
      log "Removing: $old_backup"
      rm -rf "$old_backup"
    done
else
  log "Backup count ($BACKUP_COUNT) within limit ($MAX_BACKUPS), no cleanup needed."
fi

log ""
log "Finished: $(date)"
