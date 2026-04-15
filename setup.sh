#!/bin/bash
# =============================================================================
# DGX Spark (ARM64 Ubuntu 24.04) - Post-reinstall Setup Script
# =============================================================================
# Usage:
#   git clone https://github.com/tsukiyo57/dotfiles.git ~/dotfiles
#   cd ~/dotfiles
#   chmod +x setup.sh
#   ./setup.sh [--all | --vscode | --keyboard | --browser | --docker | --comfyui]
# =============================================================================

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# --------------------------------------------------------------------------
# Helpers
# --------------------------------------------------------------------------
info()  { echo "[INFO]  $*"; }
warn()  { echo "[WARN]  $*"; }
step()  { echo ""; echo "======================================"; echo "  $*"; echo "======================================"; }

# --------------------------------------------------------------------------
# System packages
# --------------------------------------------------------------------------
install_packages() {
  step "Installing system packages"
  sudo apt-get update -qq
  sudo apt-get install -y \
    ibus ibus-mozc \
    xrdp \
    vainfo \
    docker.io \
    docker-compose-v2 \
    ffmpeg \
    python3-pip \
    curl wget git \
    alsa-utils  # for arecord (whisper recording)
  sudo usermod -aG docker "$USER"
  info "System packages installed."
  warn "Log out and back in for docker group to take effect."
}

# --------------------------------------------------------------------------
# VS Code extensions + settings
# --------------------------------------------------------------------------
install_vscode() {
  step "VS Code extensions & settings"
  if ! command -v code &>/dev/null; then
    warn "VS Code not found. Install it first, then re-run this section."
    return
  fi
  bash "$DOTFILES_DIR/vscode/install.sh"
}

# --------------------------------------------------------------------------
# Keyboard (JP + Caps->Ctrl + IBus/Mozc)
# --------------------------------------------------------------------------
install_keyboard() {
  step "Keyboard configuration"
  bash "$DOTFILES_DIR/keyboard/install.sh"
}

# --------------------------------------------------------------------------
# Browser wrapper scripts (hardware decode, best-effort)
# --------------------------------------------------------------------------
install_browser() {
  step "Browser launcher scripts"
  mkdir -p "$HOME/.local/bin"
  cp "$DOTFILES_DIR/browser/chromium-hw" "$HOME/.local/bin/chromium-hw"
  cp "$DOTFILES_DIR/browser/firefox-hw"  "$HOME/.local/bin/firefox-hw"
  chmod +x "$HOME/.local/bin/chromium-hw" "$HOME/.local/bin/firefox-hw"

  # Copy nvidia-vaapi-driver to user lib dir (if installed system-wide)
  DRIVER_SRC="/usr/lib/aarch64-linux-gnu/dri/nvidia_drv_video.so"
  DRIVER_DST="$HOME/.local/lib/dri/nvidia_drv_video.so"
  if [ -f "$DRIVER_SRC" ]; then
    mkdir -p "$(dirname "$DRIVER_DST")"
    cp "$DRIVER_SRC" "$DRIVER_DST"
    info "Copied nvidia-vaapi-driver to $DRIVER_DST"
  else
    warn "$DRIVER_SRC not found. Install: sudo apt install nvidia-vaapi-driver"
  fi
  info "Browser scripts installed to ~/.local/bin/"
}

# --------------------------------------------------------------------------
# Docker (n8n)
# --------------------------------------------------------------------------
install_docker() {
  step "Docker services (n8n)"
  DOCKER_DIR="$HOME/docker-services"
  mkdir -p "$DOCKER_DIR"
  cp "$DOTFILES_DIR/docker/docker-compose.yml" "$DOCKER_DIR/docker-compose.yml"

  info "docker-compose.yml copied to $DOCKER_DIR"
  info "Create $DOCKER_DIR/.env with:"
  cat <<'EOF'
  NOTION_TOKEN=secret_...
  NOTION_DATABASE_ID=...
  NOTION_DIGEST_DATABASE_ID=...
  GEMINI_API_KEY=...
EOF
  info "Then run: cd $DOCKER_DIR && docker compose up -d"
}

# --------------------------------------------------------------------------
# SearXNG (Docker)
# --------------------------------------------------------------------------
install_searxng() {
  step "SearXNG"
  SEARXNG_DIR="$HOME/searxng"
  mkdir -p "$SEARXNG_DIR"
  cp "$DOTFILES_DIR/searxng/settings.yml" "$SEARXNG_DIR/settings.yml"
  warn "Edit $SEARXNG_DIR/settings.yml and replace REPLACE_WITH_RANDOM_SECRET:"
  info "  openssl rand -hex 32"
  info ""
  info "SearXNG Docker run:"
  info "  docker run -d --name searxng --network host \\"
  info "    -v $SEARXNG_DIR/settings.yml:/etc/searxng/settings.yml \\"
  info "    searxng/searxng:latest"
}

# --------------------------------------------------------------------------
# ComfyUI custom nodes
# --------------------------------------------------------------------------
install_comfyui() {
  step "ComfyUI custom nodes"
  bash "$DOTFILES_DIR/comfyui/install.sh"
}

# --------------------------------------------------------------------------
# Whisper server
# --------------------------------------------------------------------------
install_whisper() {
  step "Whisper assistant"
  WHISPER_DIR="$HOME/.local/bin"
  mkdir -p "$WHISPER_DIR"
  cp "$DOTFILES_DIR/whisper/launch.sh" "$WHISPER_DIR/whisper-server"
  chmod +x "$WHISPER_DIR/whisper-server"
  info "Installed: whisper-server → $WHISPER_DIR/whisper-server"
  info "Run: whisper-server"
  info "VS Code extension will connect to http://localhost:4444"
}

# --------------------------------------------------------------------------
# Main
# --------------------------------------------------------------------------
case "${1:-}" in
  --all)
    install_packages
    install_vscode
    install_keyboard
    install_browser
    install_docker
    install_searxng
    install_comfyui
    install_whisper
    ;;
  --vscode)    install_vscode ;;
  --keyboard)  install_keyboard ;;
  --browser)   install_browser ;;
  --docker)    install_docker ;;
  --searxng)   install_searxng ;;
  --comfyui)   install_comfyui ;;
  --whisper)   install_whisper ;;
  *)
    echo "Usage: $0 [--all | --vscode | --keyboard | --browser | --docker | --searxng | --comfyui | --whisper]"
    echo ""
    echo "  --all        Run all setup steps"
    echo "  --vscode     Install VS Code extensions and settings"
    echo "  --keyboard   Apply JP keyboard + IBus/Mozc configuration"
    echo "  --browser    Install chromium-hw / firefox-hw launcher scripts"
    echo "  --docker     Set up n8n docker-compose"
    echo "  --searxng    Set up SearXNG config"
    echo "  --comfyui    Install ComfyUI custom nodes"
    echo "  --whisper    Install Whisper server launch script"
    ;;
esac
