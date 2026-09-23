#!/bin/bash
clear
gum spin -s minidot --spinner.foreground="4" --padding="1 1" --title="Installing Vesktop..." -- sleep 2
sudo pacman -S vesktop
echo
sed -i 's/--hl.exec_cmd("uwsm app -- vesktop/hl.exec_cmd("uwsm app -- vesktop/' ~/.config/hypr/autostart.lua
sed -i 's@/\* \(.*"custom/discord",\) \*/@\1@' ~/.config/waybar/config.jsonc
clear
