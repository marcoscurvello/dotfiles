#!/usr/bin/env bash

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$DOTFILES_DIR"

if ! command -v nix >/dev/null 2>&1 && [[ -f /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]]; then
  # shellcheck source=/dev/null
  source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
fi

if ! command -v nix >/dev/null 2>&1; then
  echo "Nix is required. Run ./dotfiles nix first." >&2
  exit 1
fi

exec nix --extra-experimental-features "nix-command flakes" run .#rebuild "$@"
