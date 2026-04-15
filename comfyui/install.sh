#!/bin/bash
# Install ComfyUI custom nodes listed in custom_nodes.txt
# Prerequisites: ComfyUI installed at ~/ComfyUI, ComfyUI-Manager already installed
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
COMFYUI_DIR="${COMFYUI_DIR:-$HOME/ComfyUI}"
CUSTOM_NODES_DIR="$COMFYUI_DIR/custom_nodes"

if [ ! -d "$COMFYUI_DIR" ]; then
  echo "ERROR: ComfyUI not found at $COMFYUI_DIR"
  echo "Set COMFYUI_DIR env var or install ComfyUI first."
  exit 1
fi

echo "Installing ComfyUI custom nodes into $CUSTOM_NODES_DIR..."
mkdir -p "$CUSTOM_NODES_DIR"

# ComfyUI-Manager must be installed first for batch install
MANAGER_DIR="$CUSTOM_NODES_DIR/ComfyUI-Manager"
if [ ! -d "$MANAGER_DIR" ]; then
  echo "Installing ComfyUI-Manager..."
  git clone https://github.com/ltdrdata/ComfyUI-Manager.git "$MANAGER_DIR"
fi

echo ""
echo "The following nodes are listed in custom_nodes.txt:"
cat "$SCRIPT_DIR/custom_nodes.txt"
echo ""
echo "Install remaining nodes via ComfyUI-Manager UI at http://localhost:8188"
echo "(Manager > Install Custom Nodes > search and install each)"
echo ""
echo "Or use cm-cli if available:"
echo "  python $COMFYUI_DIR/custom_nodes/ComfyUI-Manager/cm-cli.py install-list $SCRIPT_DIR/custom_nodes.txt"
