#!/bin/bash

while true; do
  HOUR=$(date +%H)

  if ((10#$HOUR >= 8 && 10#$HOUR < 20)); then
    ICON="󰖙"
  else
    ICON="󰖔"
  fi

  BAR_TIME=$(date +%H:%M)
  LOCAL=$(date +"%I:%M %p")

  NEW_YORK=$(TZ="America/New_York" date +"%I:%M %p")
  CHICAGO=$(TZ="America/Chicago" date +"%I:%M %p")
  DENVER=$(TZ="America/Denver" date +"%I:%M %p")
  LOS_ANGELES=$(TZ="America/Los_Angeles" date +"%I:%M %p")

  printf '{"text":"%s %s","tooltip":"󰥔 World Clock\\r├─ Local (NV)   →  %s\\r├─ New York     →  %s\\r├─ Chicago      →  %s\\r├─ Denver       →  %s\\r└─ Los Angeles  →  %s"}\n' \
    "$ICON" \
    "$BAR_TIME" \
    "$LOCAL" \
    "$NEW_YORK" \
    "$CHICAGO" \
    "$DENVER" \
    "$LOS_ANGELES"

  # Sleep until the next exact minute boundary.
  NOW=$(date +%s)
  SLEEP_TIME=$((60 - NOW % 60))

  sleep "$SLEEP_TIME"
done
