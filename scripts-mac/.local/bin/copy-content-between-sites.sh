#!/usr/bin/env bash
#
# Copy the database and files from one Pantheon site/environment to another,
# then reconcile the destination against ITS OWN code (drush deploy) and clear cache.
#
# Source and destination are DIFFERENT Pantheon sites, so this uses the cross-site
# backup -> signed-URL -> import workflow (env:clone-content / multidev:create are
# same-site only). import:database / import:files replace ONLY the DB and files on the
# destination -- they do NOT touch code, so the destination keeps its own (PR) codebase.
#
# Usage:
#   ./copy-content-between-sites.sh <source-site.env> <dest-site.env> [-y]
# Example:
#   ./copy-content-between-sites.sh yalesites-yale-edu.live yalesites-platform.pr-1321
#
# Prerequisites:
#   - Terminus installed (tested with 4.3.0) and authenticated:
#       terminus auth:login --machine-token=<token>
#     (or export TERMINUS_TOKEN and this script logs in for you)
#   - Write access to the destination site.
#
# Notes:
#   - -y / --yes skips the confirmation prompt.
#   - Set TERMINUS="lando terminus" to run through Lando.
#   - ~500MB per-element limit on URL imports. If an element is larger, Pantheon may
#     reject the URL import; fall back to a local copy:
#       DB:    terminus backup:get SRC --element=db --to=/tmp/db.sql.gz
#              then import via the destination's mysql/drush connection.
#       files: use rsync over the source's SFTP (terminus connection:info --field=sftp_command).
#
set -eo pipefail

TERMINUS="${TERMINUS:-terminus}"
ELEMENTS=(database files)   # copied in this order; DB first so deploy has data

usage() {
  echo "Usage: $0 <source-site.env> <dest-site.env> [-y]" >&2
  echo "Example: $0 yalesites-yale-edu.live yalesites-platform.pr-1321" >&2
  exit 1
}

SRC=""; DEST=""; ASSUME_YES=0
for arg in "$@"; do
  case "$arg" in
    -y|--yes)  ASSUME_YES=1 ;;
    -h|--help) usage ;;
    *) if   [ -z "$SRC" ];  then SRC="$arg"
       elif [ -z "$DEST" ]; then DEST="$arg"
       else usage; fi ;;
  esac
done

if [ -z "$SRC" ] || [ -z "$DEST" ]; then usage; fi
case "$SRC"  in *.*) ;; *) echo "Source must be site.env (e.g. yalesites-yale-edu.live)" >&2; exit 1 ;; esac
case "$DEST" in *.*) ;; *) echo "Destination must be site.env (e.g. yalesites-platform.pr-1321)" >&2; exit 1 ;; esac

# --- Auth (whoami exits 0 even when logged out; check stdout content) ---
if [ -n "$TERMINUS_TOKEN" ]; then
  $TERMINUS -n auth:login --machine-token="$TERMINUS_TOKEN" >/dev/null
fi
if [ -z "$($TERMINUS auth:whoami 2>/dev/null)" ]; then
  echo "Not logged in to Terminus. Run: terminus auth:login --machine-token=<token>" >&2
  echo "or export TERMINUS_TOKEN and re-run." >&2
  exit 1
fi

echo "==> Waking destination: $DEST"
$TERMINUS -n env:wake "$DEST"

# --- Destructive-action guard ---
if [ "$ASSUME_YES" -ne 1 ]; then
  echo
  echo "This OVERWRITES the database and files on:  $DEST"
  echo "with a fresh backup taken from:             $SRC"
  echo "(code on $DEST is NOT touched.)"
  read -r -p "Proceed? [y/N] " reply
  case "$reply" in y|Y|yes|YES) ;; *) echo "Aborted."; exit 1 ;; esac
fi

for element in "${ELEMENTS[@]}"; do
  echo "==> Creating $element backup on $SRC"
  $TERMINUS -n backup:create "$SRC" --element="$element"

  echo "==> Fetching signed URL for $element"
  url=$($TERMINUS backup:get "$SRC" --element="$element")

  echo "==> Importing $element into $DEST"
  if [ "$element" = "database" ]; then
    $TERMINUS -n import:database "$DEST" "$url" -y
  else
    $TERMINUS -n import:files "$DEST" "$url" -y
  fi
done

echo "==> Reconciling $DEST with its code (drush deploy)"
$TERMINUS -n drush "$DEST" -- deploy -v -y

echo "==> Clearing caches on $DEST"
$TERMINUS -n env:clear-cache "$DEST"

echo "Done. Content copied from $SRC to $DEST."
