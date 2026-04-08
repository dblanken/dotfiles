#!/usr/bin/env bash
# =============================================================================
# Nobara Full Partition Backup
# =============================================================================
# Creates dd+gzip partition images of the Nobara root and EFI partitions,
# plus a snapshot of custom system configs. Designed to back up to a NTFS
# drive — dd images preserve all Linux permissions, UUIDs, and metadata.
#
# Run this before doing a distro reinstall (e.g. switching to BTRFS).
#
# Usage:
#   nobara-full-backup.sh [--dry-run] [/path/to/destination]
#
# --dry-run   Show what would happen without writing anything.
# destination  Base directory for the backup (default: /mnt/backup/10_LINUX/Nobara)
#
# Output:
#   /mnt/backup/10_LINUX/Nobara/nobara-full-backup-YYYY-MM-DD_HH-MM-SS/
#     root.img.gz             Root partition image (~20-35 GB)
#     efi.img.gz              EFI partition image (a few MB)
#     checksums.sha256        SHA256 of the .img.gz files
#     partition-table.sgdisk  GPT backup (sgdisk format)
#     partition-table.sfdisk  GPT dump (sfdisk text format)
#     fstab                   /etc/fstab copy
#     grub-kernel-args.txt    Active kernel parameters from grubby
#     blkid.txt               UUID and filesystem info
#     lsblk.txt               Disk layout
#     efibootmgr.txt          EFI NVRAM entries
#     system-configs/         Custom system config files
#     restore-nobara.sh       Automated restore script (self-contained)
#     RESTORE-NOBARA.md       Standalone restore guide
#
# Reference: nobara-full-backup.md
# =============================================================================

set -euo pipefail

# ---------------------------------------------------------------------------
# Argument parsing
# ---------------------------------------------------------------------------

DRY_RUN=false
GIVEN_DEST=""

for arg in "$@"; do
    case "$arg" in
        --dry-run) DRY_RUN=true ;;
        /*) GIVEN_DEST="$arg" ;;
        *) echo "Unknown argument: $arg"; exit 1 ;;
    esac
done

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

RED='\033[0;31m'; YELLOW='\033[1;33m'; GREEN='\033[0;32m'
CYAN='\033[0;36m'; BOLD='\033[1m'; RESET='\033[0m'

info()   { echo -e "${CYAN}[INFO]${RESET}  $*"; }
ok()     { echo -e "${GREEN}[OK]${RESET}    $*"; }
warn()   { echo -e "${YELLOW}[WARN]${RESET}  $*"; }
err()    { echo -e "${RED}[ERROR]${RESET} $*" >&2; }
header() { echo -e "\n${BOLD}${CYAN}==> $*${RESET}"; }

run() {
    if "$DRY_RUN"; then
        info "[DRY RUN] Would run: $*"
    else
        "$@"
    fi
}

run_sudo() {
    if "$DRY_RUN"; then
        info "[DRY RUN] Would run: sudo $*"
    else
        sudo "$@"
    fi
}

# Choose compressor: pigz (parallel) if available, else gzip
if command -v pigz &>/dev/null; then
    GZIP_CMD="pigz -1"
    info "Using pigz for parallel compression"
else
    GZIP_CMD="gzip -1"
fi

# Choose progress tool: pv if available, else dd's own status=progress
dd_image() {
    local src="$1" dest_file="$2" label="$3"
    if "$DRY_RUN"; then
        info "[DRY RUN] Would run: sudo dd if=$src bs=4M status=progress | $GZIP_CMD > $dest_file"
        return
    fi
    info "Imaging $label ($src → $dest_file)..."
    if command -v pv &>/dev/null; then
        local size
        size=$(sudo blockdev --getsize64 "$src" 2>/dev/null || echo 0)
        sudo dd if="$src" bs=4M 2>/dev/null | pv --size "$size" | $GZIP_CMD > "$dest_file"
    else
        sudo dd if="$src" bs=4M status=progress 2>&1 | $GZIP_CMD > "$dest_file"
    fi
    sync
    ok "$label image complete"
}

# ---------------------------------------------------------------------------
# Check dependencies
# ---------------------------------------------------------------------------

header "Checking dependencies"

MISSING=()
for cmd in sgdisk sfdisk gzip dd sha256sum rsync efibootmgr blkid lsblk grubby; do
    if ! command -v "$cmd" &>/dev/null; then
        MISSING+=("$cmd")
    fi
done

if [[ ${#MISSING[@]} -gt 0 ]]; then
    err "Missing required tools: ${MISSING[*]}"
    echo ""
    echo "Install with:"
    echo "  sudo dnf install -y gdisk util-linux coreutils rsync efibootmgr grubby"
    exit 1
fi

ok "All required tools present"
if command -v pigz &>/dev/null; then
    ok "pigz available (parallel compression)"
else
    warn "pigz not found — using gzip (slower); install with: sudo dnf install pigz"
fi
if command -v pv &>/dev/null; then
    ok "pv available (progress display)"
else
    info "pv not found — using dd status=progress; install with: sudo dnf install pv"
fi

# ---------------------------------------------------------------------------
# Confirm sudo works
# ---------------------------------------------------------------------------

if ! sudo -n true 2>/dev/null; then
    info "Requesting sudo credentials..."
    sudo true
fi

# ---------------------------------------------------------------------------
# Setup destination
# ---------------------------------------------------------------------------

header "Setting up backup destination"

DEFAULT_BASE="/mnt/backup/10_LINUX/Nobara"
BASE="${GIVEN_DEST:-$DEFAULT_BASE}"

TIMESTAMP=$(date +%Y-%m-%d_%H-%M-%S)
BACKUP_DIR="${BASE}/nobara-full-backup-${TIMESTAMP}"

info "Backup destination: $BACKUP_DIR"

# Verify backup drive is mounted
if [[ ! -d "$BASE" ]]; then
    err "Backup base directory does not exist: $BASE"
    err "Is the backup drive mounted? Try: sudo mount /mnt/backup"
    exit 1
fi

# Check available space (root partition is 276G, actual ~66G used → image ~20-35G)
AVAIL_KB=$(df -k "$BASE" | awk 'NR==2 {print $4}')
AVAIL_GB=$(( AVAIL_KB / 1024 / 1024 ))
info "Available space on backup drive: ${AVAIL_GB} GiB"
if [[ $AVAIL_GB -lt 40 ]]; then
    warn "Less than 40 GiB free — backup may fail if root image is large."
    warn "Recommend at least 50 GiB free for a safe backup."
fi

if ! "$DRY_RUN"; then
    mkdir -p "$BACKUP_DIR"
    ok "Created: $BACKUP_DIR"
fi

# ---------------------------------------------------------------------------
# Partition info
# ---------------------------------------------------------------------------

ROOT_PART="/dev/nvme0n1p4"
EFI_PART="/dev/nvme0n1p3"
DISK="/dev/nvme0n1"

echo ""
echo "Partitions to back up:"
echo "  EFI  : $EFI_PART"
echo "  Root : $ROOT_PART"
echo "  Disk : $DISK (for partition table)"
echo ""

# ---------------------------------------------------------------------------
# Step 1: Game saves and code backup (before imaging)
# ---------------------------------------------------------------------------

header "Step 1: Game saves and code backup"

if [[ -x "$HOME/.local/bin/backup-vs.sh" ]]; then
    info "Running Vintage Story backup..."
    run "$HOME/.local/bin/backup-vs.sh"
    ok "Vintage Story backup complete"
else
    warn "backup-vs.sh not found — skipping Vintage Story save backup"
fi

if [[ -x "$HOME/.local/bin/minecraft-backup.sh" ]]; then
    info "Running Minecraft (Prism) backup..."
    run "$HOME/.local/bin/minecraft-backup.sh"
    ok "Minecraft backup complete"
else
    warn "minecraft-backup.sh not found — skipping Minecraft save backup"
fi

# rsync ~/code to backup dir
CODE_BACKUP_DIR="${BACKUP_DIR}/code-backup-$(date +%Y-%m-%d_%H-%M-%S)"
if [[ -d "$HOME/code" ]]; then
    info "Backing up ~/code via rsync..."
    if "$DRY_RUN"; then
        info "[DRY RUN] Would rsync ~/code/ → $CODE_BACKUP_DIR/"
    else
        mkdir -p "$CODE_BACKUP_DIR"
        rsync -aAX --delete \
            --exclude='*.log' \
            "$HOME/code/" "$CODE_BACKUP_DIR/" \
            2>&1 | tee "$BACKUP_DIR/code-rsync.log"
        ok "~/code backed up to $CODE_BACKUP_DIR"
    fi
else
    info "~/code not found — skipping code backup"
fi

# ---------------------------------------------------------------------------
# Step 2: Disk and partition info
# ---------------------------------------------------------------------------

header "Step 2: Disk and partition info"

if "$DRY_RUN"; then
    info "[DRY RUN] Would save: blkid.txt, lsblk.txt, efibootmgr.txt, grub-kernel-args.txt"
else
    sudo blkid > "$BACKUP_DIR/blkid.txt"
    lsblk -f > "$BACKUP_DIR/lsblk.txt"
    sudo efibootmgr -v > "$BACKUP_DIR/efibootmgr.txt" 2>/dev/null || true
    sudo grubby --info=ALL > "$BACKUP_DIR/grub-kernel-args.txt" 2>/dev/null || true
    ok "Disk info saved"
fi

# ---------------------------------------------------------------------------
# Step 3: fstab and partition table
# ---------------------------------------------------------------------------

header "Step 3: fstab and partition table"

if "$DRY_RUN"; then
    info "[DRY RUN] Would copy /etc/fstab, save sgdisk + sfdisk partition tables"
else
    cp /etc/fstab "$BACKUP_DIR/fstab"
    sudo sgdisk --backup="$BACKUP_DIR/partition-table.sgdisk" "$DISK"
    sudo sfdisk --dump "$DISK" > "$BACKUP_DIR/partition-table.sfdisk"
    ok "fstab and partition table saved"
fi

# ---------------------------------------------------------------------------
# Step 4: Custom system configs
# ---------------------------------------------------------------------------

header "Step 4: Custom system configs"

if "$DRY_RUN"; then
    info "[DRY RUN] Would copy custom udev rules, keyd config, dracut conf, dnf conf"
else
    mkdir -p "$BACKUP_DIR/system-configs/udev"
    mkdir -p "$BACKUP_DIR/system-configs/keyd"
    mkdir -p "$BACKUP_DIR/system-configs/dracut"
    mkdir -p "$BACKUP_DIR/system-configs/dnf"

    # udev rules (user-created ones only — skip Nobara/distro-provided)
    for f in \
        /etc/udev/rules.d/99-block-dying-drive.rules \
        /etc/udev/rules.d/99-xone-dongle.rules \
        /etc/udev/rules.d/99-usb-power.rules \
        /etc/udev/rules.d/99-ntsync.rules \
        /etc/udev/rules.d/60-ioschedulers.rules; do
        [[ -f "$f" ]] && sudo cp "$f" "$BACKUP_DIR/system-configs/udev/" && ok "  Saved: $f"
    done

    # keyd config
    [[ -f /etc/keyd/default.conf ]] && \
        sudo cp /etc/keyd/default.conf "$BACKUP_DIR/system-configs/keyd/" && \
        ok "  Saved: /etc/keyd/default.conf"

    # dracut EDID conf
    [[ -f /etc/dracut.conf.d/edid.conf ]] && \
        sudo cp /etc/dracut.conf.d/edid.conf "$BACKUP_DIR/system-configs/dracut/" && \
        ok "  Saved: /etc/dracut.conf.d/edid.conf"

    # EDID firmware binary (trivial to regenerate, but save it anyway)
    [[ -f /lib/firmware/edid/1920x1080.bin ]] && \
        mkdir -p "$BACKUP_DIR/system-configs/edid" && \
        sudo cp /lib/firmware/edid/1920x1080.bin "$BACKUP_DIR/system-configs/edid/" && \
        ok "  Saved: /lib/firmware/edid/1920x1080.bin"

    # dnf config
    [[ -f /etc/dnf/dnf.conf ]] && \
        sudo cp /etc/dnf/dnf.conf "$BACKUP_DIR/system-configs/dnf/" && \
        ok "  Saved: /etc/dnf/dnf.conf"

    ok "Custom configs saved to $BACKUP_DIR/system-configs/"
fi

# ---------------------------------------------------------------------------
# Step 5: Copy restore tools into backup dir
# ---------------------------------------------------------------------------

header "Step 5: Including restore tools in backup"

RESTORE_SCRIPT="$HOME/.local/bin/restore-nobara.sh"
RESTORE_DOC="$HOME/Documents/system-setup/RESTORE-NOBARA.md"

if [[ -x "$RESTORE_SCRIPT" ]]; then
    run cp "$RESTORE_SCRIPT" "$BACKUP_DIR/restore-nobara.sh"
    run chmod +x "$BACKUP_DIR/restore-nobara.sh"
    ok "restore-nobara.sh included"
else
    warn "restore-nobara.sh not found at $RESTORE_SCRIPT — skipping"
fi

if [[ -f "$RESTORE_DOC" ]]; then
    run cp "$RESTORE_DOC" "$BACKUP_DIR/RESTORE-NOBARA.md"
    ok "RESTORE-NOBARA.md included"
else
    warn "RESTORE-NOBARA.md not found at $RESTORE_DOC — skipping"
fi

# ---------------------------------------------------------------------------
# Step 6: Image the EFI partition
# ---------------------------------------------------------------------------

header "Step 6: Imaging EFI partition ($EFI_PART)"

dd_image "$EFI_PART" "$BACKUP_DIR/efi.img.gz" "EFI"

# ---------------------------------------------------------------------------
# Step 7: Image the root partition
# ---------------------------------------------------------------------------

header "Step 7: Imaging root partition ($ROOT_PART)"

info "This will take 20-40 minutes depending on drive speeds..."
dd_image "$ROOT_PART" "$BACKUP_DIR/root.img.gz" "Root"

# ---------------------------------------------------------------------------
# Step 8: SHA256 checksums
# ---------------------------------------------------------------------------

header "Step 8: Computing checksums"

if "$DRY_RUN"; then
    info "[DRY RUN] Would compute SHA256 checksums for efi.img.gz and root.img.gz"
else
    info "Computing SHA256 checksums (this re-reads the files to verify integrity)..."
    (cd "$BACKUP_DIR" && sha256sum efi.img.gz root.img.gz > checksums.sha256)
    ok "Checksums written to checksums.sha256"
    cat "$BACKUP_DIR/checksums.sha256"
fi

# ---------------------------------------------------------------------------
# Done
# ---------------------------------------------------------------------------

echo ""
echo "========================================="
echo -e "${GREEN}${BOLD}Backup Complete!${RESET}"
echo "========================================="

if "$DRY_RUN"; then
    warn "DRY RUN — nothing was written. Remove --dry-run to run for real."
else
    echo ""
    ok "Backup saved to: $BACKUP_DIR"
    echo ""
    echo "Backup contents:"
    ls -lh "$BACKUP_DIR"
    echo ""
    echo "To verify the backup:"
    echo "  cd $BACKUP_DIR && sha256sum -c checksums.sha256"
    echo ""
    echo "To restore from a live USB:"
    echo "  bash $BACKUP_DIR/restore-nobara.sh"
fi
