#!/bin/bash

# Allows computer powerbutton to be bound to system menu
sudo sed -i 's/.*HandlePowerKey=.*/HandlePowerKey=ignore/' /etc/systemd/logind.conf

# Lockout limit increase, no fat fingers for you
sudo sed -i 's|^\(auth\s\+required\s\+pam_faillock.so\)\s\+preauth.*$|\1 preauth silent deny=10 unlock_time=120|' "/etc/pam.d/system-auth"
sudo sed -i 's|^\(auth\s\+\[default=die\]\s\+pam_faillock.so\)\s\+authfail.*$|\1 authfail deny=10 unlock_time=120|' "/etc/pam.d/system-auth"

# more sudo tries
echo "Defaults passwd_tries=10" | sudo tee /etc/sudoers.d/passwd-tries
sudo chmod 440 /etc/sudoers.d/passwd-tries

# Disable USB autosuspend to prevent peripheral disconnection issues
if [[ ! -f /etc/modprobe.d/disable-usb-autosuspend.conf ]]; then
  echo "options usbcore autosuspend=-1" | sudo tee /etc/modprobe.d/disable-usb-autosuspend.conf
fi

# Install iwd explicitly if it wasn't included in archinstall
# This can happen if archinstall used ethernet
if ! command -v iwctl &>/dev/null; then
  sudo pacman -S --noconfirm --needed iwd
  sudo systemctl enable iwd.service
fi

# Prevent systemd-networkd-wait-online timeout on boot
sudo systemctl disable systemd-networkd-wait-online.service
sudo systemctl mask systemd-networkd-wait-online.service

# Turn on bluetooth by default
sudo systemctl enable bluetooth.service

# truly misc

xdg-settings set default-web-browser firefox.desktop
echo
systemctl --user enable --now hyprpolkitagent.service
sudo chmod 666 /dev/uinput
sudo systemctl enable greetd.service
elephant service enable
systemctl --user enable --now elephant.service
sudo cp ~/.local/share/calos/install/greet-config.toml /etc/greetd/config.toml
sudo cp ~/.local/share/calos/install/regreet.toml /etc/greetd/regreet.toml
sudo cp ~/.local/share/calos/install/regreet.css /etc/greetd/regreet.css
sudo cp ~/.local/share/calos/install/hyprgreet.lua /etc/greetd/hyprland.lua
sudo cp ~/.local/share/calos/install/motd /etc/motd
sudo cp ~/.local/share/calos/install/issue /etc/issue
echo "$USER ALL=(ALL:ALL) NOPASSWD: /usr/bin/systemctl start bootmsg.service" | sudo tee "/etc/sudoers.d/no-bootmsg-prompt"
sudo cp ~/.local/share/calos/install/bootmsg.service /etc/systemd/system/bootmsg.service
sudo cp ~/.local/share/calos/install/bash_profile ~/.bash_profile
mkdir -p ~/.local/share/fonts
mkdir -p ~/.local/share/icons
mv ~/.local/share/calos/install/defaultxcursor/ ~/.local/share/icons/BreezeX-Black
mv ~/.local/share/calos/install/defaulthyprcursor/ ~/.local/share/icons/Default-Hyprcursor

fc-cache
