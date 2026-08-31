#!/bin/bash

MODEL="Ryzen 7 9800X3D"
STATE="${XDG_RUNTIME_DIR}/waybar-cpu-stat"

# ───────────────────────────────────────────────
# CPU usage
# ───────────────────────────────────────────────

read -r _ user nice system idle iowait irq softirq steal _ </proc/stat

total=$((user + nice + system + idle + iowait + irq + softirq + steal))
idle_total=$((idle + iowait))

if [[ -r "$STATE" ]]; then
  read -r prev_total prev_idle <"$STATE"

  total_diff=$((total - prev_total))
  idle_diff=$((idle_total - prev_idle))

  if ((total_diff > 0)); then
    usage=$((100 * (total_diff - idle_diff) / total_diff))
  else
    usage=0
  fi
else
  usage=0
fi

printf '%s %s\n' "$total" "$idle_total" >"$STATE"

# ───────────────────────────────────────────────
# CPU topology
# ───────────────────────────────────────────────

cores=$(grep -m1 '^cpu cores' /proc/cpuinfo | cut -d: -f2)
threads=$(grep -c '^processor' /proc/cpuinfo)

# ───────────────────────────────────────────────
# CPU frequency
# ───────────────────────────────────────────────

freq=$(awk '/^cpu MHz/ { sum += $4; count++ }
    END {
        if (count)
            printf "%.1f", sum / count / 1000
        else
            print "0.0"
    }' /proc/cpuinfo)

# ───────────────────────────────────────────────
# CPU temperature
# ───────────────────────────────────────────────

temp="N/A"

for hwmon in /sys/class/hwmon/hwmon*; do
  [[ -r "$hwmon/name" ]] || continue

  read -r name <"$hwmon/name"

  if [[ "$name" == "k10temp" ]]; then
    for sensor in "$hwmon"/temp*_input; do
      [[ -r "$sensor" ]] || continue

      read -r raw <"$sensor"
      temp=$((raw / 1000))
      break
    done
    break
  fi
done

# ───────────────────────────────────────────────
# CPU cache
# ───────────────────────────────────────────────

cache=$(grep -m1 '^cache size' /proc/cpuinfo | cut -d: -f2- | xargs)

# ───────────────────────────────────────────────
# Waybar output
# ───────────────────────────────────────────────

printf '{"text":" %3s%%","tooltip":"󰘚 %s\\r│─ Cores  → %sC / %sT\\r├─ Clock  →  %s GHz\\r├─ Cache  →  %s\\r└─ Temp   →  %s°C"}\n' \
  "$usage" \
  "$MODEL" \
  "$cores" \
  "$threads" \
  "$freq" \
  "$cache" \
  "$temp"
