#!/usr/bin/env bash
# Open TCP port(s) with ufw or firewalld
set -euo pipefail

usage(){ echo "Usage: $(basename "$0") <port> [port...]" ; exit 1; }
[[ $# -ge 1 ]] || usage

if command -v ufw >/dev/null; then
  for p in "$@"; do sudo ufw allow "${p}/tcp"; done
  sudo ufw reload
elif command -v firewall-cmd >/dev/null; then
  for p in "$@"; do sudo firewall-cmd --permanent --add-port="${p}/tcp"; done
  sudo firewall-cmd --reload
else
  echo "No supported firewall tool found (ufw or firewalld)." >&2
  exit 2
fi

