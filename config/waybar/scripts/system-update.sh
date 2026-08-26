#!/usr/bin/env bash

# Author: Jesse Mirabel <github.com/sejjy>
# Created: August 16, 2025
# License: MIT
# Updates by criticalart include kernel detection, aur removal and misc fixes

GRN='\033[1;32m'
BLU='\033[1;34m'
RST='\033[0m'

TIMEOUT=5

check-updates() {
  repo=$(timeout $TIMEOUT pacman -Quq | wc -l) || repo=0

}

update-packages() {

  printf '\n%bPackages pending updates:%b\n' "$BLU" "$RST"
  echo
  pacman -Qu
  local kernel_updated=0
  tput cnorm
  if pacman -Qu | grep -q -E "^(linux|linux-zen) "; then
    kernel_updated=1
  fi
  gum confirm --padding="1 3" --selected.foreground="0" --prompt.foreground="4" --selected.background="2" "Perform system update?" && sudo pacman -Su --noconfirm || exit

  if ((kernel_updated == 1)); then
    gum spin --spinner "pulse" --spinner.foreground="1" --padding="4 0" --title " Kernel updated! Please reboot system to apply changes. Press any key to exit..." -- bash -c 'read -n 1 -s'
  else
    gum spin --spinner "pulse" --spinner.foreground="4" --padding="4 0" --title "Update complete! Press any key to exit..." -- bash -c 'read -n 1 -s'
  fi
  pkill -SIGUSR2 waybar
}

display-tooltip() {
  local tooltip="Pending Packages: $repo"

  if ((repo == 0)); then
    echo "{ \"text\": \"󰸟\", \"tooltip\": \"System Up to Date\" }"
  elif pacman -Qu | grep -q -E "^(linux|linux-zen) "; then
    echo "{ \"text\": \"󰚰 \", \"tooltip\": \"$tooltip\\nKernel Update Available\" }"
  elif pacman -Qu | grep -q -E '^hyprland '; then
    echo "{ \"text\": \"󱔅\", \"tooltip\": \"$tooltip\\nHyprland Update Available\" }"
  else
    echo "{ \"text\": \"󱧑\", \"tooltip\": \"$tooltip\" }"
  fi
}

download-updates() {
  tput civis
  gum style --padding="1 1" "Checking for updates..."
  sleep 0.4

  sudo pacman -Sy --noconfirm >/dev/null 2>&1 &
  PACMAN_PID=$!

  step=1
  max_steps=17

  while kill -0 "$PACMAN_PID" 2>/dev/null; do
    pos=$(((step % max_steps) + 1))
    pct=$((pos * 100 / max_steps))
    bar=$(printf "%-${pos}s" "#" | tr ' ' '#')

    printf "\r$(gum style "[%-17s] Syncing... %d%%")" "$bar" "$pct"

    ((step++))
    sleep 0.15
  done

  printf "\r$(gum style --foreground 114 "[#################] 100%% - Databases synced!")"
  echo ""
  echo

  UPDATE=$(pacman -Qu 2>/dev/null)

  if [ -n "$UPDATE" ]; then
    gum spin -s minidot --spinner.foreground="111" --padding="1 1" --title="Updates found! Beginning upgrade..." -- sleep 1
    echo ""
    clear
  else
    gum spin --spinner "pulse" --spinner.foreground="4" --padding="0 0" --title "No updates found. Press any key to exit..." -- bash -c 'read -n 1 -s'
    exit 0
  fi

}

main() {
  local action=$1
  case $action in
  start)
    download-updates
    check-updates
    update-packages
    ;;
  *)
    check-updates
    display-tooltip
    ;;
  esac
}

main "$@"
