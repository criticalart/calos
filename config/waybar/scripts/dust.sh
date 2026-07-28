#!/bin/bash

echo
DUST=$(pacman -Q | grep dust)
gum style --bold --underline "$DUST"
echo
dust -X ~/.local/share/Steam -C -r 2>/dev/null
echo
echo
gum spin --spinner "pulse" --spinner.foreground="111" --title "Press any key to exit..." -- bash -c 'read -n 1 -s'
