#!/bin/bash

fastfetch -c ~/.config/fastfetch/config-small.jsonc
echo
gum spin --spinner "pulse" --spinner.foreground="111" --title "Press any key to exit..." -- bash -c 'read -n 1 -s'
