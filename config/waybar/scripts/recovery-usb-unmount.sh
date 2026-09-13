#!/bin/bash

if ! mountpoint -q /mnt/usb; then
  exit 0
fi

if gum confirm "Are you sure you want to unmount the Recovery USB?"; then
  sudo umount /mnt/usb/
  echo
  gum style --foreground "#CDA861" "Recovery USB unmounted successfully."
  sleep 1
  pkill -RTMIN+13 -x waybar
fi
