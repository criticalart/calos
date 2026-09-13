#!/bin/bash

GRN='\033[1;32m'

echo
DUST=$(pacman -Q | grep dust)
gum style --bold --underline "$DUST"
echo
dust -X ~/.local/share/Steam -C -r 2>/dev/null
echo
echo
printf '%bPress any key to exit...%b' "$GRN" "$RST"
read -n 1 -s
echo
