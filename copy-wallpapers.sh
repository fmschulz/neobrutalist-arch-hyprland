#!/usr/bin/env bash

# Script to copy wallpapers from NixOS setup
# Run this from the dotfiles directory

echo "Copying wallpapers from NixOS setup..."

if [[ -d "home-manager/wallpapers" ]]; then
  cp home-manager/wallpapers/* arch-hyprland-setup/wallpapers/
  echo "✓ Wallpapers copied successfully!"
  echo "Available wallpapers:"
  ls -la arch-hyprland-setup/wallpapers/
else
  echo "❌ home-manager/wallpapers directory not found"
  echo "Please run this script from the dotfiles root directory"
  exit 1
fi
