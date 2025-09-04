#!/bin/bash

  # We overwrite the whole thing knowing the limine-update will add the entries for us
  sudo tee /boot/limine.conf <<EOF >/dev/null
### Read more at config document: https://github.com/limine-bootloader/limine/blob/trunk/CONFIG.md
timeout: 3
verbose: yes
default_entry: 1
wallpaper: boot():/boot.jpg
 
EOF

  sudo pacman -S --noconfirm --needed limine-mkinitcpio-hook
  sudo limine-update
