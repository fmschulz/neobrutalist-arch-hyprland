#!/usr/bin/env bash
set -euo pipefail

options=("Sleep" "Reboot" "Shutdown")
choice=$(printf '%s\n' "${options[@]}" | wofi --dmenu --prompt "Power" --width 220 --height 200)

[[ -z "$choice" ]] && exit 0

case "$choice" in
  Sleep)
    systemctl suspend
    ;;
  Reboot)
    systemctl reboot
    ;;
  Shutdown)
    systemctl poweroff
    ;;
  *)
    exit 0
    ;;
esac
