#!/bin/bash

# Check if limine is the bootloader

if [ -n "$(find /boot | grep -i 'limine')" ]; then

  # Check for alternative limine configuration files and if found, remove them for limine-mkinitcpio functionality

  if test -f /boot/limine/limine.conf; then
    sudo rm /boot/limine/limine.conf
  else
    echo "Configuration file not found, checking alternative locations..."
  fi

  if test -f /boot/EFI/limine/limine.conf; then
    sudo rm /boot/EFI/limine/limine.conf
  else
    echo "No alternative Limine configurations found, resuming install..."
  fi

  # Set default limine.conf location for limine-mkinitcpio-hook to properly function

  sudo tee /boot/limine.conf <<EOF >/dev/null
### Read more at config document: https://github.com/limine-bootloader/limine/blob/trunk/CONFIG.md
timeout: 3
verbose: no
default_entry: 2
wallpaper: boot():/boot.jpg
 
EOF

  # Finalize bootloader setup

  echo
  echo "Limine detected! Proceeding with feature install."
  sleep 2
  sudo cp ~/.local/share/calos/install/boot.jpg /boot/boot.jpg
  paru -S --noconfirm --needed limine-mkinitcpio-hook --skipreview
  sudo limine-update

else
  echo "Limine not installed. Installation will resume without additional settings."
  sleep 3
  clear
fi
