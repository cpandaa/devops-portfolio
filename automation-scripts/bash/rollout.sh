#!/usr/bin/env bash
set -euo pipefail
NS="${1:-demo}"
DEPLOY="${2:-demo-app}"

echo "Rolling out $DEPLOY in $NS..."
kubectl -n "$NS" rollout restart deploy/"$DEPLOY"
kubectl -n "$NS" rollout status deploy/"$DEPLOY" --timeout=120s
kubectl -n "$NS" get pods -l app="$DEPLOY" -o wide

