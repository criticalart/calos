#!/bin/bash

# copies over the branding images for easy editing/access
mkdir -p ~/.config/calos/branding
mkdir -p ~/Pictures/Wallpapers
mkdir -p ~/.cache/quickshell/thumbs
mkdir -p ~/.cache/quickshell/themes
~/.config/quickshell/theme/cache.sh ~/.config/quickshell/theme/
cp ~/.local/share/calos/install/icon.txt ~/.config/calos/branding/fastfetch.txt
cp ~/.local/share/calos/install/logo.txt ~/.config/calos/branding/screensaver.txt
cp ~/.local/share/calos/install/blank.txt ~/.config/calos/branding/mini-fast.txt
cp ~/.local/share/calos/install/shutdown.mp3 ~/.config/calos/branding/shutdown.mp3
cp ~/.local/share/calos/install/start.mp3 ~/.config/calos/branding/start.mp3
cp ~/.local/share/calos/install/themechange.mp3 ~/.config/calos/themechange.mp3
cp ~/.local/share/calos/install/off.png ~/.config/calos/branding/off.png
cp ~/.local/share/calos/install/defwall1.png ~/Pictures/Wallpapers/wall1.png
cp ~/.local/share/calos/install/defwall2.jpg ~/Pictures/Wallpapers/wall2.png
WALLFIX=$(echo "$HOME/Pictures/Wallpapers/")
CACHEFIX=$(echo "$HOME/.cache/quickshell/thumbs/")
THEMEFIX=$(echo "$HOME/.config/calos/themes")
THACHEFIX=$(echo "$HOME/.cache/quickshell/themes")
REGCSS=$(echo "file:///home/$USER/.config/calos/current/theme/regreet.css")
REGTOML=$(echo "/home/$USER/.config/calos/current/background")

sed -i "s|wallthemefix|$WALLFIX|" ~/.config/quickshell/wallselect/config.json
sed -i "s|cachpath|$CACHEFIX|" ~/.config/quickshell/wallselect/config.json
sed -i "s|themepath|$THEMEFIX|" ~/.config/quickshell/theme/config.json
sed -i "s|thachepath|$THACHEFIX|" ~/.config/quickshell/theme/config.json
sed -i "s|regreetcssreplace|$REGCSS|" ~/.local/share/calos/install/regreet.css
sed -i "s|regreetbgreplace|$REGCSS|" ~/.local/share/calos/install/regreet.toml

# allows regreet to read your theme directory and browse up to it. recommended to change after install

chmod o+x ~ ~/.local ~/.local/share
chmod -R o+rX ~/.local/share/calos/themes
