#!/bin/bash

BATTERY_PATH=$(printf '%s\n' /sys/class/power_supply/hidpp_battery_* 2>/dev/null | head -n 1)

if [ ! -d "$BATTERY_PATH" ]; then
  printf '{"text":"","tooltip":"󰍽 G502X Plus: Charging"}\n'
  exit 0
fi

BATTERY=$(cat "$BATTERY_PATH/capacity")

if ((BATTERY >= 85)); then
  ICON=""
elif ((BATTERY >= 60)); then
  ICON=""
elif ((BATTERY >= 30)); then
  ICON=""
elif ((BATTERY >= 11)); then
  ICON=""
else
  ICON=""
fi

printf '{"text":"%s","tooltip":"󰍽 G502X Plus: %s%%"}\n' "$ICON" "$BATTERY"
