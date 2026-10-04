# Shared settings for the multiMapper_m4l scripts.
# Edit these if Live/TouchDesigner live somewhere else on another Mac.

TD_DIR="/Applications/TouchDesigner.app/Contents/Resources/tfs/Samples/TDAbleton/Live 11+/TouchDesigner"
LIVE_DIR="/Applications/Ableton Live 12 Suite.app/Contents/App-Resources/MIDI Remote Scripts/TouchDesigner"

# Files that make up the device (TD folder = working folder)
FILES=("TDA_Multi_Mapper.amxd" "mappingSub.maxpat")

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DEVICE_DIR="$REPO/device"
REMOTE_URL="https://github.com/Son0f4Glitch/multiMapper_m4l.git"

copy_to_live() {
  if [ -d "$LIVE_DIR" ]; then
    for f in "${FILES[@]}"; do cp -p "$DEVICE_DIR/$f" "$LIVE_DIR/$f"; done
    echo "✓ Updated MIDI Remote Scripts folder"
  else
    echo "! MIDI Remote Scripts folder not found, skipped: $LIVE_DIR"
  fi
}
