#!/bin/bash

get_temp() {
  local hwmon_name="$1"
  local sensor="$2"

  for hwmon in /sys/class/hwmon/hwmon*; do
    [ -f "$hwmon/name" ] || continue

    if [ "$(<"$hwmon/name")" = "$hwmon_name" ]; then
      if [ -f "$hwmon/$sensor" ]; then
        local value
        value=$(<"$hwmon/$sensor")
        echo $((value / 1000))
        return
      fi
    fi
  done

  echo "N/A"
}

CPU=$(get_temp k10temp temp1_input)
GPU=$(get_temp amdgpu temp1_input)
GPU_HOT=$(get_temp amdgpu temp2_input)
NVME=$(get_temp nvme temp1_input)
SYSTEM=$(get_temp prom21_xhci temp1_input)

printf '%s\n' \
  "{\"text\":\"  ${GPU}°C\",\"tooltip\":\" System Temperature\\r├─ CPU      →  ${CPU}°C\\r├─ GPU      →  ${GPU}°C\\r├─ Hotspot  →  ${GPU_HOT}°C\\r├─ NVMe     →  ${NVME}°C\\r└─ System   →  ${SYSTEM}°C\"}"
