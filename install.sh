#!/usr/bin/env bash
#
# Sync the dotfiles into $HOME with GNU Stow.
#
# Usage:
#   ./install.sh            Stow the packages
#   ./install.sh --adopt    Stow and adopt existing files
#
set -euo pipefail

repo="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
target="${HOME}"

packages=(foot nvim opencode tmux zsh)

if ! command -v stow >/dev/null 2>&1; then
  echo "Error: stow is not installed. Install it with your package manager." >&2
  exit 1
fi

cd "$repo"
stow --target="$target" --restow "$@" "${packages[@]}"
