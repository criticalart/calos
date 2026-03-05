#!/bin/bash

fastfetch -c ~/.config/fastfetch/config-small.jsonc
gum spin --spinner "pulse" --spinner.foreground="111" --title " " -- bash -c 'read -n 1 -s'
