#!/bin/bash

while true; do
  HOUR=$(date +%H)

  if [ "$HOUR" -ge 8 ] && [ "$HOUR" -lt 20 ]; then
    ICON="󰖙"
  else
    ICON="󰖔"
  fi

  BAR_TIME=$(date +%H:%M)
  LOCAL=$(date +"%I:%M %p")

  NEW_YORK=$(TZ="America/New_York" date +"%I:%M %p")
  LOS_ANGELES=$(TZ="America/Los_Angeles" date +"%I:%M %p")
  DENVER=$(TZ="America/Denver" date +"%I:%M %p")
  CHICAGO=$(TZ="America/Chicago" date +"%I:%M %p")

  printf '%s\n' \
    "{\"text\":\"${ICON} ${BAR_TIME}\",\"tooltip\":\"󰥔 World Clock\\r│─ Local (NV)   →  ${LOCAL}\\r│─ New York     →  ${NEW_YORK}\\r├─ Chicago      →  ${CHICAGO}\\r├─ Denver       →  ${DENVER}\\r└─ Los Angeles  →  ${LOS_ANGELES}\"}"

  # Sleep until the next minute
  sleep $((60 - $(date +%S)))
done
