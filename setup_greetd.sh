#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET="$SCRIPT_DIR/setup_regreet.sh"

if [[ ! -x "$TARGET" ]]; then
  echo "Expected helper $TARGET missing or not executable." >&2
  exit 1
fi

exec "$TARGET"
