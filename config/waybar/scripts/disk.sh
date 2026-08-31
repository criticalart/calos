#!/bin/bash

# ───────────────────────────────────────────────
# Root filesystem (/)
# ───────────────────────────────────────────────

TOTAL=$(df -B1 / | awk 'NR==2 {print $2}')
USED=$(df -B1 / | awk 'NR==2 {print $3}')
FREE=$(df -B1 / | awk 'NR==2 {print $4}')
PERCENT=$(df -P / | awk 'NR==2 {print $5}')

# ───────────────────────────────────────────────
# /dev/sdb3
# ───────────────────────────────────────────────

SDB3_TOTAL=$(df -B1 /dev/sda1 | awk 'NR==2 {print $2}')
SDB3_USED=$(df -B1 /dev/sda1 | awk 'NR==2 {print $3}')
SDB3_FREE=$(df -B1 /dev/sda1 | awk 'NR==2 {print $4}')

# ───────────────────────────────────────────────
# Conversion
# ───────────────────────────────────────────────

tib() {
  awk -v bytes="$1" 'BEGIN {printf "%.1f", bytes / 1099511627776}'
}

gb() {
  awk -v bytes="$1" 'BEGIN {printf "%.1f", bytes / 1000000000}'
}

# Root filesystem
TOTAL_TIB=$(tib "$TOTAL")
FREE_TIB=$(tib "$FREE")

TOTAL_GB=$(gb "$TOTAL")
USED_GB=$(gb "$USED")
FREE_GB=$(gb "$FREE")

# /dev/sdb3
SDB3_TOTAL_GB=$(gb "$SDB3_TOTAL")
SDB3_USED_GB=$(gb "$SDB3_USED")
SDB3_FREE_GB=$(gb "$SDB3_FREE")

# ───────────────────────────────────────────────
# Waybar output
# ───────────────────────────────────────────────

printf '%s\n' \
  "{\"text\":\" ${FREE_TIB}TiB\",\"tooltip\":\" Primary NVME\\r│─ Total  →  ${TOTAL_GB} GB\\r├─ Used   →  ${USED_GB} GB\\r└─ Free   →  ${FREE_GB} GB\\r\\r Storage SSD\\r│─ Total  →  ${SDB3_TOTAL_GB} GB\\r├─ Used   →  ${SDB3_USED_GB} GB\\r└─ Free   →  ${SDB3_FREE_GB} GB\"}"
