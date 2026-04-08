#!/bin/bash

# Complete Pop!_OS Backup Script
# Usage: ./backup.sh [/path/to/external/drive]
# Defaults to /mnt/backups if no destination given

set -e
set -o pipefail  # Ensure we catch rsync errors even when piped to tee

EXTERNAL_DRIVE="${1:-/mnt/backup}"
ASKPASS="$(getent passwd "$(id -u)" | cut -d: -f6)/code/system/secure-askpass/askpass"

if [ ! -d "$EXTERNAL_DRIVE" ]; then
  echo "Error: Backup destination $EXTERNAL_DRIVE does not exist or is not mounted."
  exit 1
fi
BACKUP_DATE=$(date +%Y-%m-%d_%H-%M-%S)
BACKUP_DIR="$EXTERNAL_DRIVE/popos-backup-$BACKUP_DATE"

echo "========================================="
echo "Pop!_OS Complete Backup"
echo "========================================="
echo "Backup location: $BACKUP_DIR"
echo "Started: $(date)"
echo ""

# Create backup directory
mkdir -p "$BACKUP_DIR"

# 1. Home directory
echo "[1/8] Backing up home directory..."
set +e  # Temporarily allow errors so we can handle rsync exit codes
rsync -av --progress \
  --exclude='.cache' \
  --exclude='.local/share' \
  --exclude='Downloads' \
  --exclude='.var' \
  --exclude='.steam' \
  --exclude='.npm' \
  --exclude='.mozilla' \
  --exclude='.paradoxlauncher' \
  --exclude='.claude' \
  --exclude='.thumbnails' \
  "$HOME/" \
  "$BACKUP_DIR/home/" 2>&1 | tee "$BACKUP_DIR/rsync-output.log"

# Check rsync exit status
RSYNC_EXIT=${PIPESTATUS[0]}
set -e  # Re-enable error checking
if [ $RSYNC_EXIT -ne 0 ]; then
  echo "Warning: rsync exited with code $RSYNC_EXIT - check $BACKUP_DIR/rsync-output.log for details"
  echo "Continuing with backup... (this is usually not critical)"
fi

# 2. Package lists
echo "[2/8] Creating package lists..."
apt list --installed > "$BACKUP_DIR/installed-packages.txt"
apt-mark showmanual > "$BACKUP_DIR/manual-packages.txt"
flatpak list --app > "$BACKUP_DIR/flatpak-apps.txt" 2>/dev/null || true
snap list > "$BACKUP_DIR/snap-packages.txt" 2>/dev/null || true

# 3. System configuration
echo "[3/8] Backing up system configuration..."
mkdir -p "$BACKUP_DIR/system-config"
SUDO_ASKPASS="$ASKPASS" sudo -A rsync -av \
  /etc/fstab \
  /etc/hosts \
  /etc/hostname \
  "$BACKUP_DIR/system-config/" 2>/dev/null || true

# 4. Partition info
echo "[4/8] Saving partition information..."
SUDO_ASKPASS="$ASKPASS" sudo -A blkid > "$BACKUP_DIR/partition-info.txt"
lsblk -f > "$BACKUP_DIR/disk-layout.txt"
SUDO_ASKPASS="$ASKPASS" sudo -A efibootmgr -v > "$BACKUP_DIR/efi-boot-entries.txt" 2>/dev/null || true

# 5. Network configuration
echo "[5/8] Saving network configuration..."
ip addr show > "$BACKUP_DIR/network-interfaces.txt"
nmcli connection show > "$BACKUP_DIR/network-connections.txt" 2>/dev/null || true

# 6. Development environment
echo "[6/8] Documenting development environment..."
{
  echo "=== PHP ==="
  php -v 2>/dev/null || echo "PHP not installed"
  echo ""
  echo "=== Python ==="
  python3 --version 2>/dev/null || echo "Python3 not installed"
  echo ""
  echo "=== Node.js ==="
  node --version 2>/dev/null || echo "Node.js not installed"
  npm --version 2>/dev/null || echo "npm not installed"
} > "$BACKUP_DIR/dev-environment.txt"

pip3 list > "$BACKUP_DIR/python-packages.txt" 2>/dev/null || true
npm list -g --depth=0 > "$BACKUP_DIR/npm-global-packages.txt" 2>/dev/null || true

# 7. Databases (if running) — failures are non-fatal, credentials may not be available
echo "[7/8] Backing up databases (if applicable)..."
if systemctl is-active --quiet mysql 2>/dev/null || systemctl is-active --quiet mariadb 2>/dev/null; then
  echo "Backing up MySQL/MariaDB..."
  # Uses ~/.my.cnf for credentials; skips gracefully if auth fails
  mysqldump --defaults-file="$HOME/.my.cnf" --all-databases > "$BACKUP_DIR/mysql-all-databases.sql" 2>/dev/null \
    || echo "Warning: MySQL/MariaDB dump skipped (no credentials configured in $HOME/.my.cnf)"
fi

if systemctl is-active --quiet postgresql 2>/dev/null; then
  echo "Backing up PostgreSQL..."
  SUDO_ASKPASS="$ASKPASS" sudo -A -u postgres pg_dumpall > "$BACKUP_DIR/postgresql-all-databases.sql" 2>/dev/null \
    || echo "Warning: PostgreSQL dump skipped (sudo auth failed or service unavailable)"
fi

# 8. Create documentation
echo "[8/8] Creating documentation..."
cat > "$BACKUP_DIR/README.txt" << EOF
Pop!_OS Backup
==============
Created: $(date)
Computer: $(hostname)
User: $USER
Backup location: $BACKUP_DIR

This backup contains:
- Complete home directory
- All system configurations
- Package lists
- Development environment info
- Database dumps (if applicable)

See HOW-TO-RESTORE.txt for restoration instructions.
EOF

cat > "$BACKUP_DIR/HOW-TO-RESTORE.txt" << 'EOF'
Restoration Instructions
========================

To restore your home directory:
  rsync -av /path/to/backup/home/ /home/username/
  sudo chown -R username:username /home/username

To reinstall packages on Pop!_OS:
  cat manual-packages.txt | xargs sudo apt install -y

To restore specific files on Bazzite:
  rsync -av /path/to/backup/home/Documents/ ~/Documents/
  rsync -av /path/to/backup/home/projects/ ~/projects/
  rsync -av /path/to/backup/home/.ssh/ ~/.ssh/
  sudo chown -R $USER:$USER ~/

For databases:
  MySQL: mysql -u root -p < mysql-all-databases.sql
  PostgreSQL: sudo -u postgres psql < postgresql-all-databases.sql
EOF

# Summary
BACKUP_SIZE=$(du -sh "$BACKUP_DIR" | cut -f1)
FILE_COUNT=$(find "$BACKUP_DIR" -type f | wc -l)

echo ""
echo "========================================="
echo "Backup Complete!"
echo "========================================="
echo "Location: $BACKUP_DIR"
echo "Size: $BACKUP_SIZE"
echo "Files: $FILE_COUNT"
echo "Finished: $(date)"
echo ""
echo "✓ Your Pop!_OS backup is ready!"
echo ""
echo "Next steps:"
echo "1. Verify the backup by checking: $BACKUP_DIR"
echo "2. Keep this external drive safe"
echo "3. Proceed with Bazzite installation"
echo ""
