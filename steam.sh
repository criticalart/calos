#!/bin/bash
clear
gum style --border normal --border-foreground="4" --padding="1 3" "Steam will now be installed. If prompted to select your repository/drivers choose the following:" "Only use the $(gum style --italic 'extra/multilib') repository. Do not use $(gum style --italic 'Chaotic-aur')." " " "For AMD GPUs, please use $(gum style --bold --foreground 212 'vulkan-radeon'). For the second prompt, if asked, use $(gum style --bold --foreground 212 'lib32-vulkan-radeon')." "NVIDIA GPUs should already have total proper driver support from this installer."
echo
sleep 8
gum spin -s minidot --spinner.foreground="4" --padding="1 1" --title="Installing Steam..." -- sleep 2
sudo pacman --needed -S steam
echo
sed -i 's/^\(\s*\)--\(hl.exec_cmd("uwsm app -- steam".*\)/\1\2/' ~/.config/hypr/autostart.lua
clear
