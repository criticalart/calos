#!/bin/bash

TOTAL=$(awk '/MemTotal:/ {print $2}' /proc/meminfo)
AVAILABLE=$(awk '/MemAvailable:/ {print $2}' /proc/meminfo)
CACHED=$(awk '/^Cached:/ {print $2}' /proc/meminfo)

USED=$((TOTAL - AVAILABLE))

gib() {
  awk -v kb="$1" 'BEGIN {printf "%.1f", kb / 1048576}'
}

TOTAL_GIB=$(gib "$TOTAL")
USED_GIB=$(gib "$USED")
AVAILABLE_GIB=$(gib "$AVAILABLE")
CACHED_GIB=$(gib "$CACHED")

USAGE=$(awk -v used="$USED" -v total="$TOTAL" \
  'BEGIN {printf "%.1f", (used / total) * 100}')

printf '%s\n' \
  "{\"text\":\"󰘚 ${USED_GIB}GiB\",\"tooltip\":\"󰘚 Memory\\r│─ Used       →  ${USED_GIB} / ${TOTAL_GIB} GiB\\r├─ Usage      →  ${USAGE}%\\r├─ Available  →  ${AVAILABLE_GIB} GiB\\r└─ Cached     →  ${CACHED_GIB} GiB\"}"
