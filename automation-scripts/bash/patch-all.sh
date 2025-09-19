#!/usr/bin/env bash
# patch-all.sh — Patch a RHEL/CentOS 7.9 VM safely
# Usage:
#   sudo ./patch-all.sh [--dry-run] [--no-kernel] [--reboot] [--log /var/log/patch-YYYYMMDD.log]
# Notes:
#   - Requires yum (RHEL/CentOS 7.x). Tested for 7.9.
#   - Uses needs-restarting (yum-utils) to detect reboot requirement.

set -euo pipefail

DRY_RUN=false
EXCLUDE_KERNEL=false
DO_REBOOT=false
LOG_FILE=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --dry-run) DRY_RUN=true; shift ;;
    --no-kernel) EXCLUDE_KERNEL=true; shift ;;
    --reboot) DO_REBOOT=true; shift ;;
    --log) LOG_FILE="${2:-}"; shift 2 ;;
    -h|--help)
      grep '^# ' "$0" | sed 's/^# //'; exit 0 ;;
    *) echo "Unknown arg: $1" >&2; exit 2 ;;
  esac
done

need_root(){ [[ $EUID -eq 0 ]] || { echo "[ERROR] Run as root (sudo)." >&2; exit 1; }; }
need_root

if [[ ! -r /etc/redhat-release ]] || ! grep -qE 'release 7\.9' /etc/redhat-release; then
  echo "[ERROR] This script is restricted to RHEL/CentOS 7.9." >&2
  echo "Detected: $(cat /etc/redhat-release 2>/dev/null || echo 'unknown')" >&2
  exit 1
fi

logrun() {
  if [[ -n "$LOG_FILE" ]]; then
    mkdir -p "$(dirname "$LOG_FILE")"
    echo "+ $*" | tee -a "$LOG_FILE"
    eval "$@" 2>&1 | tee -a "$LOG_FILE"
  else
    echo "+ $*"
    eval "$@"
  fi
}

# Ensure yum-utils for needs-restarting
if ! command -v needs-restarting >/dev/null 2>&1; then
  logrun yum install -y yum-utils
fi

echo "[INFO] Starting patch run on $(cat /etc/redhat-release)"
[[ -n "$LOG_FILE" ]] && echo "=== patch-all $(date -Is) ===" | tee -a "$LOG_FILE"

# Clean metadata to avoid stale caches
logrun yum clean all

# Build update command
UPDATE_CMD="yum -y update"
if $EXCLUDE_KERNEL; then
  UPDATE_CMD="yum -y --exclude=kernel* update"
fi
if $DRY_RUN; then
  # --assumeno simulates the transaction
  UPDATE_CMD="yum --assumeno update"
  $EXCLUDE_KERNEL && UPDATE_CMD="yum --assumeno --exclude=kernel* update"
fi

# Execute
logrun $UPDATE_CMD
# Autoremove isn't standard on yum 3; remove old kernels via package-cleanup if desired (optional)
if ! $DRY_RUN; then
  if command -v package-cleanup >/dev/null 2>&1; then
    # Keep latest 2 kernels (safe default)
    logrun package-cleanup --oldkernels --count=2 -y || true
  fi
fi

echo "[INFO] Update phase complete."

# Reboot requirement
NEED_REBOOT=false
if command -v needs-restarting >/dev/null 2>&1; then
  # needs-restarting -r exits 1 if reboot is required
  if ! needs-restarting -r >/dev/null 2>&1; then
    NEED_REBOOT=true
  fi
fi

if $NEED_REBOOT; then
  echo "[INFO] Reboot recommended."
  if $DO_REBOOT && ! $DRY_RUN; then
    echo "[INFO] Rebooting now..."
    logrun systemctl reboot
  fi
else
  echo "[INFO] No reboot required."
fi

echo "[SUCCESS] Patching finished."
