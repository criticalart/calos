#!/bin/bash
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
