#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -eE

export PATH="$HOME/.local/share/calos/bin:$PATH"
OMARCHY_INSTALL=~/.local/share/calos/install

clear
echo "Installation Starting..."
echo
echo "Please note, this install script will make the current user the default for the login process, bypassing the input user prompt."
sleep 1
echo "If you would like to change that, make sure to edit (or remove) /etc/systemd/system/getty@tty1.service.d/skip-username.conf (requires sudo)"
sleep 1
echo "Only do this if you would like to allow multiple user/DE logins or change the default user login!"
sleep 5
echo
echo
echo "Ready?"
echo
echo

echo "ExecStart=-/sbin/agetty -o '-p -- $USER' --noclear --skip-login - "'$TERM' | tee -a install/skip-username.conf

sleep 1

# Preparation
source $OMARCHY_INSTALL/preflight/show-env.sh
source $OMARCHY_INSTALL/preflight/trap-errors.sh
source $OMARCHY_INSTALL/preflight/guard.sh
source $OMARCHY_INSTALL/preflight/chroot.sh
source $OMARCHY_INSTALL/preflight/repositories.sh

# Packaging
source $OMARCHY_INSTALL/packages.sh
source $OMARCHY_INSTALL/packaging/fonts.sh
source $OMARCHY_INSTALL/packaging/lazyvim.sh
source $OMARCHY_INSTALL/packaging/tuis.sh

# Configuration
source $OMARCHY_INSTALL/config/config.sh
source $OMARCHY_INSTALL/config/theme.sh
source $OMARCHY_INSTALL/config/branding.sh
source $OMARCHY_INSTALL/config/git.sh
source $OMARCHY_INSTALL/config/gpg.sh
source $OMARCHY_INSTALL/config/timezones.sh
source $OMARCHY_INSTALL/config/increase-sudo-tries.sh
source $OMARCHY_INSTALL/config/increase-lockout-limit.sh
source $OMARCHY_INSTALL/config/ssh-flakiness.sh
source $OMARCHY_INSTALL/config/detect-keyboard-layout.sh
# source $OMARCHY_INSTALL/config/xcompose.sh
source $OMARCHY_INSTALL/config/mise-ruby.sh
# source $OMARCHY_INSTALL/config/mimetypes.sh
source $OMARCHY_INSTALL/config/localdb.sh
source $OMARCHY_INSTALL/config/hardware/network.sh
source $OMARCHY_INSTALL/config/hardware/fix-fkeys.sh
source $OMARCHY_INSTALL/config/hardware/bluetooth.sh
source $OMARCHY_INSTALL/config/hardware/usb-autosuspend.sh
source $OMARCHY_INSTALL/config/hardware/ignore-power-button.sh
source $OMARCHY_INSTALL/config/hardware/nvidia.sh

# Login
source $OMARCHY_INSTALL/login/limine.sh

sudo cp ~/.local/share/calos/install/boot.jpg /boot/boot.jpg
sudo cp ~/.local/share/calos/install/bash_profile ~/.bash_profile

echo "Creating login service."

sudo mkdir /etc/systemd/system/getty@tty1.service.d
sudo cp ~/.local/share/calos/install/skip-username.conf /etc/systemd/system/getty@tty1.service.d/skip-username.conf
sudo cp ~/.local/share/calos/install/issue /etc/issue
sudo cp ~/.local/share/calos/install/motd /etc/motd
yay -S --noconfirm --needed rose-pine-hyprcursor
echo "arthur ALL=(ALL:ALL) NOPASSWD: /usr/bin/systemctl start bootmsg.service" | sudo tee "/etc/sudoers.d/no-bootmsg-prompt"
sudo cp ~/.local/share/calos/install/bootmsg.service /etc/systemd/system/bootmsg.service
echo
echo "Boot message service added and enabled."

xdg-settings set default-web-browser firefox.desktop

# Reboot
echo
echo
echo "Installation completed. Reboot to access system."

if sudo test -f /etc/sudoers.d/99-omarchy-installer; then
  sudo rm -f /etc/sudoers.d/99-omarchy-installer &>/dev/null
  echo -e "\nRemember to remove USB installer!\n\n"
fi
