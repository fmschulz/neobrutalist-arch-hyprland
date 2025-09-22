#!/usr/bin/env bash
set -euo pipefail

if [[ $EUID -ne 0 ]]; then
  echo "Please run as root (sudo)." >&2
  exit 1
fi

TARGET_USER=${SUDO_USER:-$(logname)}
TOTAL=7
STEP=0
print_step() {
  STEP=$((STEP + 1))
  echo -e "\n[$STEP/$TOTAL] $1"
}

print_step "Installing greetd, tuigreet, and seatd"
pacman -S --needed --noconfirm greetd tuigreet seatd

print_step "Stopping existing services"
systemctl disable --now greetd.service || true
systemctl disable --now seatd.service || true

print_step "Writing /etc/greetd/config.toml"
install -d -m 755 /etc/greetd
cat >/etc/greetd/config.toml <<'CFG'
[terminal]
vt = 1
switch = true

[default_session]
command = "/usr/bin/tuigreet --cmd Hyprland --time --remember --remember-session --remember-user --asterisks --theme border=#000000 text=#000000 prompt=#FB5607 highlight=#FF006E"
user = "root"
CFG

print_step "Ensuring seat group membership"
if ! id -nG "$TARGET_USER" | grep -qw seat; then
  usermod -aG seat "$TARGET_USER"
fi

print_step "Enabling seatd"
systemctl enable --now seatd.service

print_step "Enabling greetd"
systemctl reset-failed greetd.service || true
systemctl enable --now greetd.service

print_step "Setting graphical.target as default"
systemctl set-default graphical.target

echo -e "\nTuigreet configured. Reboot to apply: sudo reboot"
