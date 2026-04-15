#!/bin/bash
# Apply keyboard configuration (JP layout, Caps->Ctrl, IBus/Mozc, XRDP)
# Run with sudo for system-level files.
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "=== Keyboard Setup ==="

# /etc/default/keyboard
if [ "$EUID" -ne 0 ]; then
  echo "[WARN] Not running as root. Skipping /etc/default/keyboard"
  echo "       Run: sudo cp $SCRIPT_DIR/keyboard /etc/default/keyboard && sudo dpkg-reconfigure keyboard-configuration"
else
  echo "Setting /etc/default/keyboard (JP layout, ctrl:nocaps)..."
  cp "$SCRIPT_DIR/keyboard" /etc/default/keyboard
  dpkg-reconfigure -f noninteractive keyboard-configuration
  echo "  Done."
fi

# XRDP keyboard mapping
if [ -f /etc/xrdp/xrdp_keyboard.ini ]; then
  if [ "$EUID" -ne 0 ]; then
    echo "[WARN] Skipping /etc/xrdp/xrdp_keyboard.ini (need root)"
  else
    cp "$SCRIPT_DIR/xrdp_keyboard.ini" /etc/xrdp/xrdp_keyboard.ini
    echo "Copied xrdp_keyboard.ini"
  fi
fi

# IBus/Mozc config
echo "Copying IBus/Mozc config..."
MOZC_DIR="$HOME/.config/mozc"
mkdir -p "$MOZC_DIR"
cp "$SCRIPT_DIR/ibus_config.textproto" "$MOZC_DIR/ibus_config.textproto"
echo "  Done: $MOZC_DIR/ibus_config.textproto"
echo "  Run: ibus write-cache && ibus restart"

echo ""
echo "Keyboard setup complete!"
