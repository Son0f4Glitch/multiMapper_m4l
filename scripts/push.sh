#!/bin/bash
# Push the current device from the TouchDesigner folder to GitHub.
# Usage:  bash scripts/push.sh "what changed" [version]
# e.g.    bash scripts/push.sh "Added slot 5 scaling" 10.11
set -euo pipefail
source "$(dirname "$0")/paths.sh"
cd "$REPO"

MSG="${1:-}"
VERSION="${2:-}"
if [ -z "$MSG" ]; then
  echo 'Usage: bash scripts/push.sh "what changed" [version]'; exit 1
fi

# 1. Copy the working files from the TD folder into the repo
mkdir -p "$DEVICE_DIR"
for f in "${FILES[@]}"; do
  if [ ! -f "$TD_DIR/$f" ]; then echo "✗ Missing: $TD_DIR/$f"; exit 1; fi
  cp -p "$TD_DIR/$f" "$DEVICE_DIR/$f"
done

# 2. Commit (only if something changed)
git add -A
if git diff --cached --quiet; then
  echo "• No changes in the device files since the last push."
else
  git commit -q -m "$MSG"
  echo "✓ Committed: $MSG"
fi

# 3. Tag the version
if [ -n "$VERSION" ]; then
  TAG="v${VERSION#v}"
  if git rev-parse -q --verify "refs/tags/$TAG" >/dev/null; then
    echo "✗ Tag $TAG already exists – pick a new version number."; exit 1
  fi
  git tag -a "$TAG" -m "$MSG"
  echo "✓ Tagged $TAG"
fi

# 4. Push to GitHub
git push -q -u origin main --follow-tags
echo "✓ Pushed to GitHub"

# 5. Keep Live's MIDI Remote Scripts copy in sync
copy_to_live
