~/.local/share/calos/themes/theme-update.sh
cp ~/.local/share/calos/applications/hidden/* ~/.local/share/applications/
cp ~/.local/share/calos/applications/nvim.desktop ~/.local/share/applications/

cp ~/.local/share/calos/applications/capture.desktop ~/.local/share/applications/
CAPTUREFIX=$(echo "$HOME/.local/share/icons/capture.png")
sed -i "s|capturefix|$CAPTUREFIX|" ~/.local/share/applications/capture.desktop

rm -rf ~/.local/share/calos/applications
rm -rf ~/.local/share/calos/config
rm -rf ~/.local/share/calos/.git
sudo updatedb
clear
echo
cat ~/.local/share/calos/install/logo-complete.txt | tte --xterm-colors --frame-rate 120 spray
echo
rm -rf ~/.local/share/calos/install
rm ~/.local/share/calos/README.md
