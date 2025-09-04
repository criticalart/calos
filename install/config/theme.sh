#!/bin/bash

gsettings set org.gnome.desktop.interface gtk-theme "Adwaita-dark"
gsettings set org.gnome.desktop.interface color-scheme "prefer-dark"
gsettings set org.gnome.desktop.interface icon-theme "Yaru-blue"

# Setup theme links
mkdir -p ~/.config/calos/themes
for f in ~/.local/share/calos/themes/*; do ln -nfs "$f" ~/.config/calos/themes/; done

# Set initial theme
mkdir -p ~/.config/calos/current
ln -snf ~/.config/calos/themes/futurism ~/.config/calos/current/theme
ln -snf ~/.config/calos/current/theme/backgrounds/3-futurism.png ~/.config/calos/current/background

# Set specific app links for current theme
ln -snf ~/.config/calos/current/theme/neovim.lua ~/.config/nvim/lua/plugins/theme.lua

mkdir -p ~/.config/btop/themes
ln -snf ~/.config/calos/current/theme/btop.theme ~/.config/btop/themes/current.theme

mkdir -p ~/.config/mako
ln -snf ~/.config/calos/current/theme/mako.ini ~/.config/mako/config
