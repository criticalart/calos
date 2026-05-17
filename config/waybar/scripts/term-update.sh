#!/usr/bin/env bash
#
# Update system packages using pacman and AUR helper
#
# Author: Jesse Mirabel <github.com/sejjy>
# Created: August 16, 2025
# License: MIT

GRN='\033[1;32m'
BLU='\033[1;34m'
RST='\033[0m'

TIMEOUT=5
HELPER=$(command -v yay trizen pikaur paru pakku pacaur aurman aura |
  head -n 1 | xargs -- basename)

check-updates() {
  repo=$(timeout $TIMEOUT pacman -Quq | wc -l) || repo=0

  aur=0
  if [[ -n $HELPER ]]; then
    aur=$(timeout $TIMEOUT "$HELPER" -Quaq 2>/dev/null | wc -l) ||
      aur=0
  fi
}

update-packages() {
  if ((repo + aur == 0)); then
    gum spin --spinner "pulse" --spinner.foreground="4" --padding="1 0" --title "No updates found. Press any key to exit..." -- bash -c 'read -n 1 -s'
    systemctl --user restart waybar.service >/dev/null 2>&1 &
  else
    if ((repo > 0)); then
      printf '\n%bPackages pending updates:%b\n' "$BLU" "$RST"
      echo
      pacman -Qu
      gum confirm --padding="1 3" --selected.foreground="0" --prompt.foreground="4" --selected.background="2" "Perform system update?" && sudo pacman -Syu --noconfirm || exit
    fi

    if ((aur > 0)); then
      printf '\n%bAUR packages pending updates:%b\n' "$BLU" "$RST"
      echo
      paru -Qu
      echo
      gum confirm --padding="1 3" --selected.foreground="0" --prompt.foreground="4" --selected.background="2" "Update AUR packages?" && paru -Syu --noconfirm --skipreview --removemake || exit
    fi

    notify-send 'Update Complete' -i 'package-install'
    systemctl --user restart waybar.service >/dev/null 2>&1 &
    gum spin --spinner "pulse" --spinner.foreground="4" --padding="4 0" --title "Update complete! Press any key to exit..." -- bash -c 'read -n 1 -s'
  fi
}

display-tooltip() {
  local tooltip="Official: $repo"
  if [[ -n $HELPER ]]; then
    tooltip+="\nAUR($HELPER): $aur"
  fi

  if ((repo + aur == 0)); then
    echo "{ \"text\": \"󰸟\", \"tooltip\": \"No updates available\" }"
  else
    echo "{ \"text\": \"\", \"tooltip\": \"$tooltip\" }"
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
