#!/usr/bin/env bash
# systemd service helper: start/stop/restart/status/enable/disable
set -euo pipefail

usage() {
  cat <<EOF
Usage: $(basename "$0") <start|stop|restart|status|enable|disable> <service>
Ex:    $(basename "$0") restart nginx
EOF
  exit 1
}

[[ $# -eq 2 ]] || usage
ACTION="$1"; SVC="$2"

if ! command -v systemctl >/dev/null 2>&1; then
  echo "systemctl not found. Is this a systemd host?" >&2
  exit 2
fi

sudo systemctl "${ACTION}" "${SVC}"
sudo systemctl is-active --quiet "${SVC}" && echo "Service '${SVC}' is active." || echo "Service '${SVC}' is NOT active."

