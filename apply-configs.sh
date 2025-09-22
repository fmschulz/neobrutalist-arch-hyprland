#!/usr/bin/env bash

# Apply neo-brutalist Hyprland design configs on Arch (no package installs)
# Safe to re-run; copies configs and wallpapers, enables user services.

set -euo pipefail

BLUE='\033[0;34m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'
log() { echo -e "${BLUE}▶${NC} $*"; }
ok() { echo -e "${GREEN}✓${NC} $*"; }
warn() { echo -e "${YELLOW}⚠${NC} $*"; }
die() {
  echo -e "${RED}✖${NC} $*"
  exit 1
}

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

log "Applying Hyprland design configs (no package installs)"

# Ensure target dirs
mkdir -p ~/.config ~/.local/bin ~/Pictures/wallpapers ~/Pictures/screenshots

# Copy configs
if [[ -d "${SCRIPT_DIR}/configs" ]]; then
  rsync -a --delete "${SCRIPT_DIR}/configs/" ~/.config/
  ok "Configs synced to ~/.config"
else
  die "configs/ not found next to this script"
fi

# Make scripts executable
if [[ -d ~/.config/scripts ]]; then
  chmod +x ~/.config/scripts/* || true
  ok "Scripts marked executable"
fi

# Wallpapers
if [[ -d "${SCRIPT_DIR}/wallpapers" ]]; then
  rsync -a "${SCRIPT_DIR}/wallpapers/" ~/Pictures/wallpapers/
  ok "Wallpapers copied"
else
  warn "wallpapers/ not found; skipping"
fi

# Minimal shell integration: source custom bashrc if present
if [[ -f ~/.config/bash/bashrc ]]; then
  if ! grep -q "\.config/bash/bashrc" ~/.bashrc 2>/dev/null; then
    {
      echo "# Source custom Arch Hyprland bashrc"
      echo "if [ -f ~/.config/bash/bashrc ]; then source ~/.config/bash/bashrc; fi"
    } >>~/.bashrc
    ok "Linked ~/.config/bash/bashrc from ~/.bashrc"
  else
    ok "~/.bashrc already sources custom bashrc"
  fi
fi

# Enable key user services if installed
systemctl --user daemon-reload || true
systemctl --user enable --now pipewire pipewire-pulse wireplumber 2>/dev/null || warn "PipeWire services not available"

ok "Done. Log out/in or start Hyprland to see changes."
