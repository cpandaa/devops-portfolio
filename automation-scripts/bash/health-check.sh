#!/usr/bin/env bash
# Basic system health with thresholds; exit nonzero on breach (good for cron)
set -euo pipefail

CPU_MAX="${CPU_MAX:-85}"     # percent
MEM_MAX="${MEM_MAX:-90}"     # percent
DISK_MAX="${DISK_MAX:-90}"   # percent on /

cpu() { mpstat 1 1 | awk '/Average/ && $12 ~ /[0-9.]+/ {print 100-$12}' 2>/dev/null || top -bn1 | awk '/Cpu/ {print 100-$8}'; }
mem() { free | awk '/Mem:/ {printf "%.0f", ($3/$2)*100}'; }
disk(){ df -P / | awk 'NR==2 {print int($5)}'; }

CPU=$(printf "%.0f" "$(cpu)")
MEM=$(mem)
DSK=$(disk)

echo "CPU=${CPU}% MEM=${MEM}% DISK=${DSK}% (limits: ${CPU_MAX}/${MEM_MAX}/${DISK_MAX})"

[[ ${CPU} -le ${CPU_MAX} ]] && [[ ${MEM} -le ${MEM_MAX} ]] && [[ ${DSK} -le ${DISK_MAX} ]] && exit 0
echo "Threshold breached." >&2
exit 1

