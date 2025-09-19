#!/usr/bin/env bash
# Check TLS cert expiry in days; supports host:port (default 443)
set -euo pipefail

usage(){ echo "Usage: $(basename "$0") <host[:port]> [min_days=14]"; exit 1; }
TARGET="${1:-}"; MIN="${2:-14}"
[[ -n "${TARGET}" ]] || usage
HOST="${TARGET%:*}"; PORT="${TARGET#*:}"
[[ "${HOST}" == "${PORT}" ]] && PORT=443

end_date=$(echo | timeout 5 openssl s_client -servername "${HOST}" -connect "${HOST}:${PORT}" 2>/dev/null | openssl x509 -noout -enddate | cut -d= -f2)
[[ -n "${end_date}" ]] || { echo "Failed to read certificate." >&2; exit 2; }
end_epoch=$(date -d "${end_date}" +%s)
now_epoch=$(date +%s)
days_left=$(( (end_epoch - now_epoch) / 86400 ))

echo "Cert for ${HOST}:${PORT} expires in ${days_left} days (min: ${MIN})"
(( days_left < MIN )) && exit 1 || exit 0

