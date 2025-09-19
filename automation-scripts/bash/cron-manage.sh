#!/usr/bin/env bash
# Add/list/remove crontab entries for current user
set -euo pipefail

usage() {
  cat <<EOF
Usage:
  $(basename "$0") add  "<schedule>" "<command>"
  $(basename "$0") list
  $(basename "$0") rm   "<search-string>"
Examples:
  $(basename "$0") add  "0 2 * * *" "/usr/local/bin/backup.sh"
  $(basename "$0") rm   "backup.sh"
EOF
  exit 1
}

cmd="${1:-}"; shift || true

case "${cmd}" in
  add)
    [[ $# -eq 2 ]] || usage
    schedule="$1"; command="$2"
    (crontab -l 2>/dev/null || true; echo "${schedule} ${command}") | crontab -
    echo "Added cron: ${schedule} ${command}"
    ;;
  list|"")
    crontab -l || true
    ;;
  rm)
    [[ $# -eq 1 ]] || usage
    needle="$1"
    crontab -l | grep -v -- "${needle}" | crontab -
    echo "Removed entries matching: ${needle}"
    ;;
  *)
    usage
    ;;
esac

