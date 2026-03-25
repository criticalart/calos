#!/bin/bash
set -eE

export PATH="$HOME/.local/share/calos/bin:$PATH"
CALOS_INSTALL=~/.local/share/calos/install

# Install Initialization

sudo pacman -S --noconfirm --needed gum

clear
echo
cat ~/.local/share/calos/install/logo-complete.txt
echo
gum style --border normal --border-foreground="4" --padding="1 3" "Welcome to $(gum style --bold --foreground 212 'calOS')!" " " "This script will turn your base Arch Linux install into a clean, minimal, and functional Hyprland setup." "The installer will install/enable $(gum style --foreground 212 'Chaotic-AUR') as well as $(gum style --italic 'Paru') to function as your AUR helper." "There will be an option towards the end of the install to switch to yay as your AUR helper." " " "Make sure you are running this installation script on a $(gum style --foreground 212 'fresh Arch Linux installation')!"
echo
sleep 6
gum confirm --padding="1 3" --selected.foreground="0" --prompt.foreground="4" --selected.background="2" "Proceed with Install?" && gum spin -s minidot --spinner.foreground="4" --title="Installation starting..." -- sleep 2 || exit 1
echo

# Scripts for error reporting and repository edits

source $CALOS_INSTALL/preinstall/errors.sh
source $CALOS_INSTALL/preinstall/repositories.sh
sudo pacman -S --noconfirm --needed base-devel
sudo pacman -S --noconfirm --needed paru
clear

# System critical AUR packages

gum style --border normal --border-foreground="4" --padding="1 3" "$(gum style --foreground 212 'Chaotic-AUR') repository added to $(gum style --italic '/etc/pacman.conf') and Paru has been installed." " " "The installer will now begin downloading and building AUR packages required for basic system functionality." "This is the most time-consuming portion of the install. Time spent will vary based on your hardware."
sleep 6
echo
gum spin -s minidot --spinner.foreground="4" --title="Resuming install..." -- sleep 4
sudo pacman -S --noconfirm --needed yaru-icon-theme clipse wayland
paru -S --noconfirm --needed python-terminaltexteffects rose-pine-hyprcursor elephant elephant-desktopapplications elephant-menus elephant-calc walker --skipreview --removemake --cleanafter
clear

# Main packages, configuration and scripts

gum style --border normal --border-foreground="4" --padding="1 3" "AUR system packages built and installed successfully! Build files will be cleansed post-installation." " " "The installer will now download/install all required packages and link required configuration files."
echo
sleep 4
gum spin -s minidot --spinner.foreground="4" --title="Resuming install..." -- sleep 4
source $CALOS_INSTALL/packages.sh
source $CALOS_INSTALL/lazyvim.sh
source $CALOS_INSTALL/config/config.sh
source $CALOS_INSTALL/config/theme.sh
source $CALOS_INSTALL/config/branding.sh
calos-tui-install "Dust" "bash -c 'dust -r; read -n 1 -s'" float https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/png/qdirstat.png
clear

# NVIDIA checks, AMD fixes

gum style --border normal --border-foreground="4" --padding="1 3" "The installer will now prompt you to select your GPU architecture." " " "If $(gum style --bold --foreground 212 'AMD') is selected the installer will download and enable rocm-smi support for system monitor integration." "Choosing $(gum style --bold --foreground 212 'NVIDIA') will download required dependencies/headers as well as update hyprland configurations."
echo
sleep 2
GPU=$(gum choose --item.foreground 250 "AMD" "NVIDIA")
[[ "$GPU" == "AMD" ]] && gum spin -s minidot --spinner.foreground="4" --title="AMD selected! Installing dependencies..." -- sleep 3 && sudo pacman -S --noconfirm --needed rocm-smi-lib || source $CALOS_INSTALL/nvidia.sh
clear

# Limine bootloader setup

gum style --border normal --border-foreground="4" --padding="1 3" "The installer will now check which bootloader you have installed." "The default recommended bootloader is $(gum style --bold --foreground 212 'Limine'), but calOS will function on any." " " "If Limine is detected the installer will enable various features, such as automated mkinitcpio/dual-booting/ricing."
sleep 6
echo
gum spin -s minidot --spinner.foreground="4" --title="Resuming install..." -- sleep 4
source $CALOS_INSTALL/limine.sh
clear


# Miscellaneous scripting

gum style --border normal --border-foreground="4" --padding="1 3" "The installer will now apply miscellaneous fixes/scripts to your architecture." "These include custom login/boot scripts, systemctl configs and enhancing system functionality."
sleep 4
echo
gum spin -s minidot --spinner.foreground="4" --title="Resuming install..." -- sleep 4
source $CALOS_INSTALL/misc.sh
clear

# AUR helper

gum style --border normal --border-foreground="4" --padding="1 3" "Please specify which $(gum style --italic 'AUR Helper') you would like to utilize on your system." " " "By default the installer ships with and utilizes $(gum style --bold --foreground 212 'Paru')." "Paru is relatively faster than $(gum style --bold --foreground 212 'yay') with built-in PKGBUILD viewing in terminal." " " "If you would like to switch back to yay, please specify below."
echo
sleep 4
HELPER=$(gum choose --item.foreground 250 "Paru" "yay")
[[ "$HELPER" == "yay" ]] && gum spin -s minidot --spinner.foreground="4" --title="Paru will now be replaced with yay..." -- sleep 3 && sudo pacman -S --noconfirm --needed yay && sudo pacman -Rns paru --noconfirm || gum spin -s line --title="Paru will remain your AUR helper. Resuming install..." -- sleep 3
clear

# Steam Installation

gum style --border normal --border-foreground="4" --padding="1 3" "Would you like to install/setup $(gum style --bold --foreground 212 'Steam')?" "Installing Steam from this script will automatically set proper autostart/uwsm configurations." "You may always install Steam manually post-installation."
sleep 4
echo
gum confirm --padding="1 3" --selected.foreground="0" --prompt.foreground="4" --selected.background="2" "Install Steam?" && gum spin -s minidot --spinner.foreground="4" --title="Initializing Steam script..." -- sleep 3 && source ./steam.sh || echo "Steam will not be installed."
sleep 1

# Installation Cleanup

gum style --border normal --border-foreground="4" --padding="1 3" "The installer will now begin removing unnecessary files created during install." "Please keep all remaining files in $(gum style --italic '~/.local/share/calos') for system stability."
sleep 3
echo
gum spin -s minidot --spinner.foreground="4" --title="Cleaning up installation..." -- sleep 4
source $CALOS_INSTALL/cleanup.sh
gum spin -s minidot --spinner.foreground="4" --title="Finalizing install..." -- sleep 2

# Installation Completion and Optional Steam Install

gum style --border normal --border-foreground="4" --padding="1 3" "$(gum style --bold --foreground 212 'Installation complete!') Reboot to access system." " " "Make sure to read through your configuration files to familarize yourself with the OS, especially in $(gum style --italic '~/.config/hypr')." "Please configure your $(gum style --italic '~/.config/hypr/monitors.conf') file in order to set a proper resolution and refresh rate." " " "The default editor is Neovim, which can be launched with $(gum style --italic 'SUPER + N')." "Please open Neovim once to initialize lazyvim scripts, this will only occur on the first launch." " " "For any additional inquiries, please refer to the Github documentation."
sleep 5
echo
rm ~/.local/share/calos/steam.sh
rm ~/.local/share/calos/install.sh
gum confirm --padding="1 3" --selected.foreground="0" --prompt.foreground="4" --selected.background="2" "Would you like to reboot to BIOS?" && systemctl reboot --firmware-setup
