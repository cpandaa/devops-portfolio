#!/usr/bin/env bash
# Safe-ish Docker cleanup with confirmation flag
set -euo pipefail

CONFIRM="${1:-}"
[[ "${CONFIRM}" == "--yes" ]] || { echo "Dry run. Use --yes to actually prune."; docker system df; exit 0; }

docker image prune -af
docker container prune -f
docker volume prune -f
docker builder prune -af

echo "Docker resources pruned."

