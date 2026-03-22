#!/usr/bin/env bash
# =============================================================================
# Nobara Partition Restore Script
# =============================================================================
# Designed to be run from a Nobara live USB.
# Also works if run from the backup directory directly (if the system boots).
#
# Usage:
#   restore-nobara.sh [--dry-run] [/path/to/backup/dir]
#
# --dry-run  Show what would happen without writing anything.
# If a backup directory is provided, it is used directly.
# Otherwise the script auto-detects the backup drive and lets you choose.
#
# Reference: RESTORE-NOBARA.md
# =============================================================================

set -e
set -o pipefail

# ---------------------------------------------------------------------------
# Argument parsing
# ---------------------------------------------------------------------------

DRY_RUN=false
GIVEN_BACKUP_DIR=""

for arg in "$@"; do
    case "$arg" in
        --dry-run) DRY_RUN=true ;;
        /*) GIVEN_BACKUP_DIR="$arg" ;;
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

confirm() {
    local prompt="$1"
    local response
    echo -e "${YELLOW}${BOLD}$prompt${RESET}"
    echo -n "  Type 'yes' to confirm, anything else to abort: "
    read -r response
    if [[ "$response" != "yes" ]]; then
        echo "Aborted."
        exit 1
    fi
}

dd_restore() {
    local src="$1"
    local dest="$2"
    if "$DRY_RUN"; then
        info "[DRY RUN] Would run: gunzip -c $src | dd of=$dest bs=4M status=progress"
    else
        gunzip -c "$src" | sudo dd of="$dest" bs=4M status=progress
        sudo sync
    fi
}

ROOT_PART="/dev/nvme0n1p4"
EFI_PART="/dev/nvme0n1p3"
DISK="/dev/nvme0n1"

# ---------------------------------------------------------------------------
# Header
# ---------------------------------------------------------------------------

echo "========================================="
echo -e "${BOLD}Nobara Partition Restore${RESET}"
echo "========================================="
if "$DRY_RUN"; then
    warn "DRY RUN mode — no changes will be made"
fi
echo ""

# ---------------------------------------------------------------------------
# Step 1: Find the backup directory
# ---------------------------------------------------------------------------

header "Step 1: Locating backup"

BACKUP_MOUNT="/mnt/backups"

if [[ -n "$GIVEN_BACKUP_DIR" ]]; then
    if [[ ! -d "$GIVEN_BACKUP_DIR" ]]; then
        err "Provided backup directory does not exist: $GIVEN_BACKUP_DIR"
        exit 1
    fi
    BACKUP_DIR="$GIVEN_BACKUP_DIR"
    ok "Using provided backup directory: $BACKUP_DIR"
else
    # Auto-detect the backup drive
    if ! mountpoint -q "$BACKUP_MOUNT" 2>/dev/null; then
        info "Backup drive not mounted at $BACKUP_MOUNT"
        info "Scanning for NTFS partition with label 'Backups'..."

        NTFS_DEV=$(lsblk -f -o PATH,FSTYPE,LABEL 2>/dev/null \
            | awk '$2=="ntfs" && $3=="Backups" {print $1}' \
            | head -1)

        if [[ -z "$NTFS_DEV" ]]; then
            warn "Could not auto-detect backup drive by label 'Backups'."
            warn "Available partitions:"
            lsblk -f
            echo ""
            echo -n "Enter the device path for the backup drive (e.g. /dev/sde2): "
            read -r NTFS_DEV
        fi

        if [[ ! -b "$NTFS_DEV" ]]; then
            err "Device $NTFS_DEV is not a valid block device."
            exit 1
        fi

        info "Mounting $NTFS_DEV at $BACKUP_MOUNT..."
        if "$DRY_RUN"; then
            info "[DRY RUN] Would run: sudo mkdir -p $BACKUP_MOUNT && sudo mount $NTFS_DEV $BACKUP_MOUNT"
        else
            sudo mkdir -p "$BACKUP_MOUNT"
            sudo mount "$NTFS_DEV" "$BACKUP_MOUNT"
        fi
        ok "Backup drive mounted at $BACKUP_MOUNT"
    else
        ok "Backup drive already mounted at $BACKUP_MOUNT"
    fi

    # Look for Nobara backups
    NOBARA_BASE="$BACKUP_MOUNT/10_LINUX/Nobara"
    mapfile -t BACKUPS < <(ls -1d "$NOBARA_BASE"/nobara-full-backup-* 2>/dev/null | sort -r)

    if [[ ${#BACKUPS[@]} -eq 0 ]]; then
        err "No Nobara full backups found at $NOBARA_BASE/nobara-full-backup-*"
        exit 1
    fi

    echo ""
    echo "Available Nobara backups:"
    for i in "${!BACKUPS[@]}"; do
        BSIZE=$(du -sh "${BACKUPS[$i]}" 2>/dev/null | cut -f1 || echo "?")
        echo "  [$((i+1))] ${BACKUPS[$i]##*/}  ($BSIZE)"
    done
    echo "  [0] Most recent (${BACKUPS[0]##*/})"
    echo ""
    echo -n "Select backup number (0 for most recent): "
    read -r SELECTION

    if [[ "$SELECTION" == "0" ]] || [[ -z "$SELECTION" ]]; then
        BACKUP_DIR="${BACKUPS[0]}"
    elif [[ "$SELECTION" =~ ^[0-9]+$ ]] && [[ "$SELECTION" -le "${#BACKUPS[@]}" ]]; then
        BACKUP_DIR="${BACKUPS[$((SELECTION-1))]}"
    else
        err "Invalid selection: $SELECTION"
        exit 1
    fi

    ok "Selected backup: $BACKUP_DIR"
fi

# Verify required files exist
for f in root.img.gz efi.img.gz checksums.sha256; do
    if [[ ! -f "$BACKUP_DIR/$f" ]]; then
        err "Required file missing from backup: $f"
        exit 1
    fi
done

# ---------------------------------------------------------------------------
# Step 2: Verify checksums
# ---------------------------------------------------------------------------

header "Step 2: Verifying checksums"

info "Verifying SHA256 checksums (re-reads both image files — takes a few minutes)..."

if "$DRY_RUN"; then
    info "[DRY RUN] Would run: cd $BACKUP_DIR && sha256sum -c checksums.sha256"
else
    if ! (cd "$BACKUP_DIR" && sha256sum -c checksums.sha256); then
        err "Checksum verification FAILED. The backup images may be corrupted."
        err "Do NOT restore from a corrupted image."
        exit 1
    fi
fi
ok "Checksums verified successfully"

# ---------------------------------------------------------------------------
# Step 3: Show target partition info
# ---------------------------------------------------------------------------

header "Step 3: Target partition information"

echo ""
echo "Current disk layout:"
lsblk -f "$DISK" 2>/dev/null || lsblk "$DISK"
echo ""

ROOT_SIZE=$(sudo blockdev --getsize64 "$ROOT_PART" 2>/dev/null || echo "unknown")
EFI_SIZE=$(sudo blockdev --getsize64 "$EFI_PART" 2>/dev/null || echo "unknown")

echo "Target partitions:"
echo "  EFI  : $EFI_PART  ($(( ${EFI_SIZE:-0} / 1024 / 1024 )) MiB)"
echo "  Root : $ROOT_PART  ($(( ${ROOT_SIZE:-0} / 1024 / 1024 / 1024 )) GiB)"
echo ""
echo "Backup images:"
ls -lh "$BACKUP_DIR/root.img.gz" "$BACKUP_DIR/efi.img.gz"
echo ""
echo "Reference fstab from backup:"
cat "$BACKUP_DIR/fstab"
echo ""

# ---------------------------------------------------------------------------
# Step 4: Check partition table
# ---------------------------------------------------------------------------

header "Step 4: Partition table check"

CURRENT_SFDISK=$(sudo sfdisk --dump "$DISK" 2>/dev/null || echo "")
SAVED_SFDISK=$(cat "$BACKUP_DIR/partition-table.sfdisk" 2>/dev/null || echo "")

CURRENT_PARTS=$(echo "$CURRENT_SFDISK" | grep "^/dev" || true)
SAVED_PARTS=$(echo "$SAVED_SFDISK" | grep "^/dev" || true)

if [[ "$CURRENT_PARTS" == "$SAVED_PARTS" ]]; then
    ok "Partition table matches the backup — no restoration needed"
    NEED_PTABLE_RESTORE=false
else
    warn "Partition table DIFFERS from backup!"
    echo ""
    echo "Current:"
    echo "$CURRENT_PARTS"
    echo ""
    echo "Expected (from backup):"
    echo "$SAVED_PARTS"
    echo ""
    warn "If Nobara repartitioned the drive, restore the partition table first,"
    warn "then REBOOT the live USB before restoring partitions."
    NEED_PTABLE_RESTORE=true
fi

# ---------------------------------------------------------------------------
# Step 5: Restore partition table (if needed)
# ---------------------------------------------------------------------------

if "$NEED_PTABLE_RESTORE"; then
    header "Step 5: Restoring partition table"

    confirm "DESTRUCTIVE: Restore the GPT partition table on $DISK?"

    if "$DRY_RUN"; then
        info "[DRY RUN] Would run: sudo sgdisk --load-backup=$BACKUP_DIR/partition-table.sgdisk $DISK"
    else
        sudo sgdisk --load-backup="$BACKUP_DIR/partition-table.sgdisk" "$DISK"
        sudo partprobe "$DISK" 2>/dev/null || true
    fi
    ok "Partition table restored"

    echo ""
    warn "The partition table has been restored."
    warn "You should REBOOT the live USB now so the kernel re-reads the partition"
    warn "layout, then re-mount the backup drive and re-run this script."
    echo ""
    echo -n "Reboot now? (yes/no): "
    read -r reboot_now
    if [[ "$reboot_now" == "yes" ]]; then
        sudo reboot
    else
        warn "Continuing without reboot. Restore may fail if kernel hasn't re-read partitions."
    fi
fi

# ---------------------------------------------------------------------------
# Step 6: Final confirmation
# ---------------------------------------------------------------------------

header "Step 6: Final confirmation before restore"

echo ""
echo -e "${RED}${BOLD}ABOUT TO OVERWRITE:${RESET}"
echo -e "  ${RED}$EFI_PART${RESET}  — EFI system partition"
echo -e "  ${RED}$ROOT_PART${RESET}  — Root (/) partition"
echo ""
echo "Source backup: $BACKUP_DIR"
echo ""
if "$DRY_RUN"; then
    warn "DRY RUN: No data will be written."
else
    confirm "This will PERMANENTLY OVERWRITE $EFI_PART and $ROOT_PART. Are you sure?"
fi

# ---------------------------------------------------------------------------
# Step 7: Restore EFI partition
# ---------------------------------------------------------------------------

header "Step 7: Restoring EFI partition ($EFI_PART)"

info "Restoring efi.img.gz → $EFI_PART ..."
dd_restore "$BACKUP_DIR/efi.img.gz" "$EFI_PART"
ok "EFI partition restored"

# ---------------------------------------------------------------------------
# Step 8: Restore root partition
# ---------------------------------------------------------------------------

header "Step 8: Restoring root partition ($ROOT_PART)"

info "Restoring root.img.gz → $ROOT_PART ..."
info "This will take 20-40 minutes..."
dd_restore "$BACKUP_DIR/root.img.gz" "$ROOT_PART"
ok "Root partition restored"

# ---------------------------------------------------------------------------
# Step 9: Re-register EFI boot entry
# ---------------------------------------------------------------------------

header "Step 9: Registering EFI boot entry"

info "Current EFI boot entries:"
sudo efibootmgr -v 2>/dev/null || true
echo ""

info "Creating Nobara/GRUB boot entry..."
if "$DRY_RUN"; then
    info "[DRY RUN] Would run: sudo efibootmgr --create --disk $DISK --part 3 --label 'Nobara Linux' --loader '\\EFI\\nobara\\shimx64.efi'"
else
    # Nobara uses GRUB with shim. Try common paths.
    MOUNTED_EFI=false
    VERIFY_EFI=$(mktemp -d)
    sudo mount "$EFI_PART" "$VERIFY_EFI" 2>/dev/null && MOUNTED_EFI=true

    SHIM_PATH=""
    for path in \
        "nobara/shimx64.efi" \
        "fedora/shimx64.efi" \
        "BOOT/BOOTX64.EFI"; do
        if "$MOUNTED_EFI" && [[ -f "$VERIFY_EFI/EFI/$path" ]]; then
            SHIM_PATH="\\EFI\\${path//\//\\}"
            ok "Found EFI loader at: $path"
            break
        fi
    done

    if "$MOUNTED_EFI"; then
        sudo umount "$VERIFY_EFI" 2>/dev/null || true
    fi
    rmdir "$VERIFY_EFI" 2>/dev/null || true

    if [[ -z "$SHIM_PATH" ]]; then
        warn "Could not auto-detect EFI loader path."
        warn "Try manually after reboot:"
        warn "  sudo efibootmgr --create --disk $DISK --part 3 --label 'Nobara Linux' --loader '\\EFI\\nobara\\shimx64.efi'"
    else
        sudo efibootmgr \
            --create \
            --disk "$DISK" \
            --part 3 \
            --label "Nobara Linux" \
            --loader "$SHIM_PATH" 2>/dev/null && ok "EFI boot entry registered" || {
            warn "efibootmgr failed — register the boot entry manually after reboot."
            warn "See RESTORE-NOBARA.md Step 9 for instructions."
        }
    fi
fi

# ---------------------------------------------------------------------------
# Step 10: Verify restored filesystem
# ---------------------------------------------------------------------------

header "Step 10: Verifying restored filesystem"

if ! "$DRY_RUN"; then
    VERIFY_MOUNT=$(mktemp -d)
    sudo mount "$ROOT_PART" "$VERIFY_MOUNT" 2>/dev/null || {
        warn "Could not mount restored root partition for verification."
        warn "Not necessarily an error — try rebooting."
    }

    if mountpoint -q "$VERIFY_MOUNT" 2>/dev/null; then
        echo "Restored fstab:"
        cat "$VERIFY_MOUNT/etc/fstab"
        echo ""

        ROOT_UUID_DISK=$(sudo blkid -s UUID -o value "$ROOT_PART" 2>/dev/null || echo "unknown")
        ROOT_UUID_FSTAB=$(grep " / " "$VERIFY_MOUNT/etc/fstab" | awk '{print $1}' | sed 's/UUID=//' | head -1)

        if [[ "$ROOT_UUID_DISK" == "$ROOT_UUID_FSTAB" ]]; then
            ok "fstab UUID matches disk UUID ($ROOT_UUID_DISK)"
        else
            warn "UUID mismatch!"
            warn "  Disk UUID   : $ROOT_UUID_DISK"
            warn "  fstab UUID  : $ROOT_UUID_FSTAB"
            warn "With a dd restore this is unexpected. Double-check the fstab."
        fi

        sudo umount "$VERIFY_MOUNT"
    fi
    rmdir "$VERIFY_MOUNT" 2>/dev/null || true
fi

# ---------------------------------------------------------------------------
# Done
# ---------------------------------------------------------------------------

echo ""
echo "========================================="
echo -e "${GREEN}${BOLD}Restore Complete!${RESET}"
echo "========================================="
if "$DRY_RUN"; then
    warn "DRY RUN — nothing was actually written. Remove --dry-run to restore for real."
else
    echo ""
    ok "Nobara has been restored from: $BACKUP_DIR"
    echo ""
    echo "Next steps:"
    echo "  1. Remove the live USB"
    echo "  2. Reboot"
    echo "  3. After booting, restore your home directory:"
    echo "     rsync -aAX /mnt/backup/10_LINUX/Nobara/home-snapshots/LATEST/ /home/dblanken/"
    echo ""
    echo -n "Reboot now? (yes/no): "
    read -r do_reboot
    if [[ "$do_reboot" == "yes" ]]; then
        sudo reboot
    fi
fi
