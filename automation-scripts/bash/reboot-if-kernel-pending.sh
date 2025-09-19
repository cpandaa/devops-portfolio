#!/usr/bin/env bash
# Reboot if kernel update pending (Ubuntu/Debian) or kexec-notify on RHEL
set -euo pipefail

if [[ -f /var/run/reboot-required ]]; then
  echo "Reboot required flag present."
  sudo /sbin/reboot
else
  echo "No reboot-required flag detected."
fi

