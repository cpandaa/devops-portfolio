#!/usr/bin/env bash
# Cross-distro package installer
set -euo pipefail

usage(){ echo "Usage: $(basename "$0") <pkg1> [pkg2 ...]"; exit 1; }
[[ $# -ge 1 ]] || usage

PKGS=("$@")
if command -v apt-get >/dev/null; then
  sudo apt-get update -y
  sudo DEBIAN_FRONTEND=noninteractive apt-get install -y "${PKGS[@]}"
elif command -v dnf >/dev/null; then
  sudo dnf install -y "${PKGS[@]}"
elif command -v yum >/dev/null; then
  sudo yum install -y "${PKGS[@]}"
elif command -v zypper >/dev/null; then
  sudo zypper install -y "${PKGS[@]}"
else
  echo "Unsupported distro." >&2; exit 2
fi

