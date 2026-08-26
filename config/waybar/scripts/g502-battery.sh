#!/bin/bash

BAT="/sys/class/power_supply/hidpp_battery_1"

capacity=$(<"$BAT/capacity")

if [[ "$status" == "Charging" ]]; then
  icon="󰂄"
else
  if ((capacity <= 10)); then
    icon="  "
  elif ((capacity <= 25)); then
    icon="  "
  elif ((capacity <= 50)); then
    icon="  "
  elif ((capacity <= 75)); then
    icon="  "
  else
    icon="  "
  fi
fi

printf '{"text":"%s","tooltip":"󰍽 G502X Plus: %s%%"}\n' "$icon" "$capacity"
