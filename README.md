<p align="center">
<img width="1031" height="969" alt="image" src="https://github.com/user-attachments/assets/0085e340-68ea-421f-a7fa-80d1a53eca2c" />
</p>


# -caliburnOS- Desktop Hyprland Starter
-caliburnOS- is a desktop-friendly Hyprland starter setup (Arch btw) that strives to be both feature-rich, yet nominal; a blank template that the user can build on top of. With less than 600 packages on a complete install, -caliburnOS- combines smart/minimal TUI-based defaults with smooth animations and extensive themeing. Heavy emphasis on the **Desktop** part btw. If you have a lot of screen real estate this install is perfect for you, and it functions oh-so nicely on widescreen monitors. 

tl;dr its dotfiles baby

<p align="center">
<img width="3440" height="1440" alt="image" src="https://github.com/user-attachments/assets/7bc269b3-9d8d-45c7-b6ef-bb3d13cf8ee7" />
  <i>Overview Module</i>
</p>

## Overview

* **💻 Minimal System Apps**: Striving to be as bloat-free as possible, -caliburnOS- primarily utilizes TUI applications/packages with minimal dependencies for system control. Examples include `yazi` as your file browser, `cmus` for playing local audio, and `bluetui`/`impala` for bluetooth/wifi support respectively.
* **🎮 Gaming Friendly**: -caliburnOS- ships with numerous gaming-oriented configurations, all found in the `games.conf` file within `.config/hypr`. Features include a special workspace for games (`Super + G`), a custom gaming submap (with full waybar integration) that disables keybinds of your choosing + enables passthrough (for global push-to-talk support) and Steam pre-installed (if chosen by the installer).
*  **🧲 Complete Walker/Waybar/Quickshell Integration**: Thanks to walker's extensive `dmenu` support, -caliburnOS- comes with a powerful system menu that can help toggle/restart system daemons, launch applications, run system commands and even change your current theme. A custom fork of `mechabar` (Waybar) helps you keep on eye on your active workspaces, system resources, currently playing audio and pending updates. Various system binaries communicate between the both of them so any system changes or toggle-able states reflect on waybar. **caliburnShell** is the lightweight overlay/OSD module that runs in the background, allowing for custom notifications/media controls + workspace organization. These three critical system components use less than 500MB in total and look really nice.
*  **🖌️ Style**: Speaking of _style_, -caliburnOS- ships with 10+ themes that are fully integrated into the OS. Your waybar, Neovim, terminal applications, quickshell modules, audio visuializer and walker menu all change based on the theme you pick! Check out the style section below for some examples. Shoutout to Omarchy for creating the excellent theme switcher that this is based on. Multiple beziers were either created or imported (from popular configs like caelestia) for a beautifuly animated system. Quickshell is woven beautifully in the OS, from your power menu to your theme menu to your lockscreen.
* **🖱️ Don't Forget the Mouse**: What would a desktop setup be without a mouse? Sure, there are keybinds for every system function but sometimes you just want to kick back and use your mouse to navigate your computer. Any possible feature or system action/binary can easily be accessed from `waybar`/`walker`, even running a system update! `Walker` will follow your mouse and launch dynamically based on where it is invoked, `waybar` will allow you to toggle any system state by just clicking on it and `quickshell` has complete functionality with the mouse for its theme/wallpaper/power menu. Just because you're using a window manager doesn't mean you only have to use your keyboard.
*  **⚖️ Configurable Install**: With preconfigured dotfiles, you sometimes run the risk of too little control over what you have installed on your system. The installer rectifies this by allowing you to choose what defaults you prefer, such as picking your AUR helper `yay` vs `paru` (defaults to paru because iTS BETTER) and whether or not you want to install `Steam` with full system integration.
*  **🔧 Tinker Friendly**: Some dotfiles also make it very difficult to change certain aspects of your system, from keybinds to default applications. This is your computer and you can do whatever you want with it. All configuration files are in the `~/.config` directory, with your `hyprland` configuration files being neatly sourced in separate files for easy editing. Don't like something? Great, change it! To easily browse installed packages and "de-bloat", open up your system menu and navigate to System -> Packages to see what comes preinstalled.


## Core Applications

| Component | Application |
| --- | --- |
| **Compositor** | [Hyprland](https://hyprland.org/) |
| **Launcher** | [Walker](https://github.com/abenz1267/walker) |
| **Waybar** | [Mechabar](https://github.com/sejjy/mechabar) |
| **Terminal** | [Alacritty](https://alacritty.org/) |
| **Wallpaper**| [Awww](https://codeberg.org/LGFae/awww) |
| **Notifications**| [mako](https://github.com/emersion/mako) |
| **Browser** | [Firefox](https://github.com/mozilla-firefox/firefox) |


## Keybinds

For the uninitiated, your **Super** key is your windows key. Stop calling it the windows key.

### General

| Keybind | Action |
| --- | --- |
| `Super (L / R)` | Open System Menu |
| `Super + Enter` | Open Terminal |
| `Super + Q` | Kill Active Window |
| `Super + Escape` | Open Homepage |
| `Super + B` | Browser (Firefox) |
| `Super + Space` | Application Launcher |
| `Super + Y` | Yazi (File Manager)|
| `Super + N` | Neovim |
| `Super + G` | Toggle Game Window |
| `Super + S` | BTop++ System Monitor |
| `Super + Backspace` | Toggle Opacity |
| `CTRL + ALT + DEL` | Power Menu |


### System

System keybinds use **CTRL** and  **SUPER**.

| Keybind | Action |
| --- | --- |
| `Super + CTRL + L` | Lockscreen |
| `Super + CTRL + N` | Toggle Bluelight |
| `Super + CTRL + W` | Toggle Waybar |
| `Super + CTRL + C` | Clipboard History |
| `Super + CTRL + S` | Power Options |
| `Super + CTRL + T` | Theme Menu |
| `Super + CTRL + G` | Toggle Game Mode |
| `Super + CTRL + B` | Background Menu |


### Window Management

| Keybind | Action |
| --- | --- |
| `Super + (1,2,3)` | Switch Between [Number] Workspace |
| `Super + F` | Toggle Floating Window On/Off |
| `Super + Arrow Keys` | Switch Active Window |
| `Super + Shift + Arrow Keys` | Swap Active Window |
| `Super + Shift + (1,2,3)` | Move Active Window to [Number] Workspace |
| `SUPER + L_Click` | Drag Window |
| `SUPER + R_Click` | Resize Floating Window |


## Style

<p align="center">
  <img width="3440" height="1440" alt="image" src="https://github.com/user-attachments/assets/781ae445-6cc4-4ffe-ab73-2787461f20c8" />
  <i>Theme Menu</i>
</p>

<p align="center">
<img width="3440" height="1440" alt="image" src="https://github.com/user-attachments/assets/e885b0d0-16a8-4b97-8e93-80860bf7983d" />
  <br>
  <i>Launcher with Dynamic Location</i>
  <br><br>

<img width="3440" height="1440" alt="image" src="https://github.com/user-attachments/assets/7c0b1d34-0435-4935-9a3e-ea28131e84a3" />
  <br>
  <i>Quickshell Powermenu</i>
  <br><br>

<img width="3440" height="1440" alt="image" src="https://github.com/user-attachments/assets/b51ec43b-6fb6-4165-b94a-4de90dd12d90" />
  <br>
  <i>Glorious Window Management</i>
  <br><br>
  
<img width="3440" height="1440" alt="image" src="https://github.com/user-attachments/assets/ddd5bd24-b951-4663-8de1-d11a4e1fac7b" />
  <br>
  <i>ok maybe a bit too much quickshell</i>
</p>

Many, many, many (autistic) hours were spent tweaking each theme -caliburnOS- ships with to compliment the entire OS. The entire shell (`waybar`, `quickshell`, `walker`), any terminal based application (through `alacritty`), the greeter theme (using some `greetd-regreeter` hacks) and even `vesktop` all have their own unique color scheme based on the system's theme. A sleek `theme-preview` quickshell menu displays them all.


# Installation and Configuration

## How 2 Install

**You must have a fresh Arch install going into this.** Feel free to use any settings you want; from disk encryption to file system type. **Limine is heavily encouraged to be used as your bootloader as the installer enables extra features if it detects it.** Other bootloaders will function just fine, however. The only required settings are a **user with root** (which you should be using anyway, you dummy) and **pipewire/bluetooth to be installed** (waybar will not like you if they're not). 

```
sudo pacman -S git
```
Install git to clone the repository into the specified directory.

Create your directories:
```
mkdir -pv ~/.local/share
cd ~/.local/share
```

From there, clone this repository:

```
git clone https://github.com/criticalart/calos
```
Then `cd` into /calos/ and run `./install.sh.` Wow crazy. 

## Post Installation

* Try to familiarize yourself with all the keybinds to really get the most out of the system. 
* If you are a lazy sack of shit just read through the ~/.config/hypr configuration files as those are what you use to interact with your system.
* When logging in for the first time make sure you select the `uwsm-managed` version of Hyprland as -caliburnOS- relies heavily on `uwsm` for system service management. Once selected the first time, it will default to it permanently.

## Why Paru?

* its better just try it don't be a bitch
