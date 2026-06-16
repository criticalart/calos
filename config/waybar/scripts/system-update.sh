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
  if ((repo == 0)); then
    gum spin --spinner "pulse" --spinner.foreground="4" --padding="1 0" --title "No updates found. Press any key to exit..." -- bash -c 'read -n 1 -s'
  else
    if ((repo > 0)); then
      printf '\n%bPackages pending updates:%b\n' "$BLU" "$RST"
      echo
      pacman -Qu
      local kernel_updated=0
      if pacman -Qu | grep -q -E "^(linux|linux-zen) "; then
        kernel_updated=1
      fi
      gum confirm --padding="1 3" --selected.foreground="0" --prompt.foreground="4" --selected.background="2" "Perform system update?" && sudo pacman -Syu --noconfirm || exit
    fi

    if ((kernel_updated == 1)); then
      gum spin --spinner "pulse" --spinner.foreground="1" --padding="4 0" --title " Kernel updated! Please reboot system to apply changes. Press any key to exit..." -- bash -c 'read -n 1 -s'
    else
      gum spin --spinner "pulse" --spinner.foreground="4" --padding="4 0" --title "Update complete! Press any key to exit..." -- bash -c 'read -n 1 -s'
    fi
    pkill -SIGUSR2 waybar
  fi
}

display-tooltip() {
  local tooltip="Pending Packages: $repo"

  if ((repo == 0)); then
    echo "{ \"text\": \"󰸟\", \"tooltip\": \"System Up to Date\" }"
  elif pacman -Qu | grep -q -E "^(linux|linux-zen) "; then
    echo "{ \"text\": \"󰚰 \", \"tooltip\": \"$tooltip\\nKernel Update Available\" }"
  elif pacman -Qu | grep -q -E "hyprland"; then
    echo "{ \"text\": \"󱔅\", \"tooltip\": \"$tooltip\\nHyprland Update Available\" }"
  else
    echo "{ \"text\": \"󰇚\", \"tooltip\": \"$tooltip\" }"
  fi
}

main() {
  local action=$1
  case $action in
  start)
    gum spin -s minidot --spinner.foreground="4" --padding="1 1" --title="Initializing update script..." -- sleep 1.2
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
