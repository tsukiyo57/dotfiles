#!/bin/bash
# Install VS Code extensions from extensions.txt
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Installing VS Code extensions..."
while IFS= read -r ext; do
  [[ -z "$ext" || "$ext" == \#* ]] && continue
  echo "  Installing: $ext"
  code --install-extension "$ext" --force
done < "$SCRIPT_DIR/extensions.txt"

echo ""
echo "Copying settings.json..."
SETTINGS_DIR="$HOME/.config/Code/User"
mkdir -p "$SETTINGS_DIR"
cp "$SCRIPT_DIR/settings.json" "$SETTINGS_DIR/settings.json"
echo "  Done: $SETTINGS_DIR/settings.json"

echo ""
echo "VS Code setup complete!"
