#!/usr/bin/env bash
# Simple timestamped tar.gz backup
set -euo pipefail

SRC="${1:-/etc}"
DEST_DIR="${2:-/var/backups}"
PREFIX="${3:-backup}"

mkdir -p "${DEST_DIR}"
ts="$(date +%Y%m%d-%H%M%S)"
outfile="${DEST_DIR}/${PREFIX}-${ts}.tar.gz"

echo "Backing up ${SRC} -> ${outfile}"
tar -czf "${outfile}" "${SRC}"

# Optional: keep last N backups
KEEP="${KEEP_BACKUPS:-7}"
ls -1t "${DEST_DIR}/${PREFIX}-"*.tar.gz 2>/dev/null | tail -n +$((KEEP+1)) | xargs -r rm -f
echo "Done. Kept last ${KEEP} backups."

