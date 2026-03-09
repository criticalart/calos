rm ~/.local/share/calos/bin/calos-tui-install
cp ~/.local/share/calos/applications/hidden/* ~/.local/share/applications/
cp ~/.local/share/calos/applications/nvim.desktop ~/.local/share/applications/
rm -rf ~/.local/share/calos/applications
rm -rf ~/.local/share/calos/config
rm -rf ~/.local/share/calos/.git
sudo updatedb
clear
cat ~/.local/share/calos/install/logo-complete.txt | tte --xterm-colors --frame-rate 120 spray
echo
rm -rf ~/.local/share/calos/install
rm ~/.local/share/calos/README.md
