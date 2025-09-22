#!/usr/bin/env bash
set -euo pipefail

if [[ $EUID -ne 0 ]]; then
  echo "Please run as root (sudo)." >&2
  exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_USER=${SUDO_USER:-$(logname)}

exec "$SCRIPT_DIR/scripts/setup/configure-regreet.sh" "$TARGET_USER"
