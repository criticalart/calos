#!/bin/bash

# Copy over Omarchy configs
mkdir -p ~/.config
cp -R ~/.local/share/calos/config/* ~/.config/

# Use default bashrc from Omarchy
cp ~/.local/share/calos/default/bashrc ~/.bashrc
