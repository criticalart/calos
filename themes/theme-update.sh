#!/bin/bash

gum style --border normal --border-foreground="4" --padding="1 3" "This script will $(gum style --bold --foreground 212 'delete') your current theme cache, link your theme folders and regenerate the cache." " " "You should run this if you encounter any issues with the theme selector or if you have added a new theme." "When installing new themes $(gum style --foreground 212 'you must make sure the layout is exactly the same') between themes." "Look at the current theme folder to explore the correct layout." "" "Make sure to delete old symlinks from ~/.config/calos/themes/ !"

gum confirm --padding="1 3" --selected.foreground="0" --prompt.foreground="4" --selected.background="2" "Would you like to execute the script?" && clear || exit 1
echo "Deleting cache..."
sleep 0.2
rm ~/.cache/quickshell/themes/*
echo
echo "Done!"
echo
echo
echo "Re-linking themes..."
for f in ~/.local/share/calos/themes/*; do ln -nfs "$f" ~/.config/calos/themes/; done
echo
echo "Done!"
echo
echo
echo "Regenerating cache..."
~/.config/quickshell/theme/cache.sh ~/.config/quickshell/theme/
clear
echo "Themes updated! Remember to check /calos/ in your .config directory to remove old symlinks".
