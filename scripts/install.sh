#!/bin/bash
# Get the latest version from GitHub and copy it into the TouchDesigner
# and Live folders. Use on your other Mac, or after updating TD / Live.
# Usage:  bash scripts/install.sh
set -euo pipefail
source "$(dirname "$0")/paths.sh"
cd "$REPO"

git pull -q --ff-only origin main
git fetch -q --tags
echo "✓ Got latest from GitHub ($(git describe --tags --always))"

# Back up any working file that differs from what's in the repo,
# so unpushed edits are never lost.
STAMP="$(date +%Y%m%d-%H%M%S)"
for f in "${FILES[@]}"; do
  if [ -f "$TD_DIR/$f" ] && ! cmp -s "$TD_DIR/$f" "$DEVICE_DIR/$f"; then
    mkdir -p "$REPO/backups"
    cp -p "$TD_DIR/$f" "$REPO/backups/$STAMP-$f"
    echo "! $f in the TD folder had changes not on GitHub – backed up to backups/$STAMP-$f"
  fi
  cp -p "$DEVICE_DIR/$f" "$TD_DIR/$f"
done
echo "✓ Updated TouchDesigner folder"
copy_to_live
