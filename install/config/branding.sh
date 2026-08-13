#!/bin/bash

# copies over the branding images for easy editing/access
mkdir -p ~/.config/calos/branding
cp ~/.local/share/calos/install/icon.txt ~/.config/calos/branding/about.txt
cp ~/.local/share/calos/install/logo.txt ~/.config/calos/branding/screensaver.txt
cp ~/.local/share/calos/install/blank.txt ~/.config/calos/branding/blank.txt
cp ~/.local/share/calos/install/shutdown.mp3 ~/.config/calos/branding/shutdown.mp3
cp ~/.local/share/calos/install/start.mp3 ~/.config/calos/branding/start.mp3
cp ~/.local/share/calos/install/themechange.mp3 ~/.config/calos/themechange.mp3
cp ~/.local/share/calos/install/off.png ~/.config/calos/branding/off.png
