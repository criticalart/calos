<p align="center">
<img width="697" height="564" alt="editme" src="https://github.com/user-attachments/assets/05789ba6-3832-400f-995e-082534f3ab7d" />  
</p>


# calOS Hyprland Starter
CalOS is a desktop-friendly Hyprland starter setup (Arch btw) that strives to be both feature-rich, yet nominal; a blank template that the user can build on top of. With less than 600 packages on a complete install, calOS combines smart/minimal TUI-based defaults with smooth animations and extensive themeing.

tl;dr its dotfiles baby

<p align="center">
<img width="3440" height="1440" alt="image" src="https://github.com/user-attachments/assets/78fd0520-30ce-468e-b17e-e95a1a1013eb" />
</p>

## Overview

* **💻 Minimal System Apps**: Striving to be as bloat-free as possible, calOS primarily utilizes TUI applications/packages with minimal dependencies for system control. Examples include `yazi` as your file browser, `cmus` for playing local audio, and `bluetui`/`impala` for bluetooth/wifi support respectively.
* **🎮 Gaming Friendly**: calOS ships with numerous gaming-oriented configurations, all found in the `games.conf` file within `.config/hypr`. Features include a special workspace for games (`Super + G`), a custom gaming submap (with full waybar integration) that disables keybinds of your choosing + enables passthrough (for global push-to-talk support) and Steam pre-installed (if chosen by the installer).
*  **🧲 Complete Walker/Waybar Integration**: Thanks to walker's extensive `dmenu` support, calOS comes with a powerful system menu that can help toggle/restart system daemons, launch applications, run system commands and even change your current theme. A custom fork of `mechabar` (Waybar) helps you keep on eye on your active workspaces, system resources, currently playing audio and pending updates. Easter egg included.
*  **🖌️ Style**: Speaking of _style_, calOS ships with 10+ themes that are fully integrated into the OS. Your waybar, Neovim, terminal applications, audio visuializer and walker menu all change based on the theme you pick! Check out the style section below for some examples. Shoutout to Omarchy for creating the excellent theme switcher that this is based on. Multiple beziers were either created or imported (from popular configs like caelestia) for a beautifuly animated system.
*  **⚖️ Configurable Install**: With preconfigured dotfiles, you sometimes run the risk of too little control over what you have installed on your system. The installer rectifies this by allowing you to choose what defaults you prefer, such as picking your AUR helper `yay` vs `paru` (defaults to paru because iTS BETTER) and whether or not you want to install `Steam` with full system integration.
*  **🔧 Tinker Friendly**: Some dotfiles also make it very difficult to change certain aspects of your system, from keybinds to default applications. This is your computer and you can do whatever you want with it. All configuration files are in the `~/.config` directory, with your `hyprland` configuration files being neatly sourced in separate files for easy editing. Don't like something? Great, change it! To easily browse installed packages and "debloat", open up your system menu and navigate to System -> Packages to see what comes preinstalled.


## Core Applications

| Component | Application |
| --- | --- |
| **Compositor** | [Hyprland](https://hyprland.org/) |
| **Launcher** | [Walker](https://github.com/abenz1267/walker) |
| **Waybar** | [Mechabar](https://github.com/sejjy/mechabar) |
| **Terminal** | [Alacritty](https://alacritty.org/) |
| **Wallpaper**| [Awww](https://github.com/LGFae/swww) |
| **Notifications**| [mako](https://github.com/emersion/mako) |
| **Browser** | [Firefox](https://github.com/mozilla-firefox/firefox) |


## Keybinds

For the uninitiated, your **Super** key is your windows key. Stop calling it the windows key.

### General

| Keybind | Action |
| --- | --- |
| `Super + Enter` | Open Terminal |
| `Super + Q` | Kill Active Window |
| `Super + Escape` | Open System Menu |
| `Super + Alt + Space` | Open System Menu (Alt) |
| `Super + B` | Browser (Firefox) |
| `Super + K` | List Keybinds |
| `Super + Space` | Application Launcher |
| `Super + Y` | Yazi (File Manager(|
| `Super + N` | Neovim |
| `Super + G` | Toggle Game Window |
| `Super + S` | BTop++ System Monitor |
| `Super + Backspace` | Toggle Opacity |


### System

System keybinds use **CTRL** and  **SUPER**.

| Keybind | Action |
| --- | --- |
| `Super + CTRL + L` | Screensaver |
| `Super + CTRL + N` | Toggle Bluelight Filter |
| `Super + CTRL + W` | Toggle Waybar On/Off |
| `Super + CTRL + C` | Clipboard History |
| `Super + CTRL + S` | Power Options (Reboot/Shutdown) |
| `Super + CTRL + T` | Theme Menu |
| `Super + CTRL + G` | Toggle Game Mode On/Off |
| `Super + CTRL + B` | Cycle Background |


### Window Management

| Keybind | Action |
| --- | --- |
| `Super + (1,2,3)` | Switch Between [Number] Workspace |
| `Super + F` | Toggle Floating Window On/Off |
| `Super + Arrow Keys` | Switch Active Window |
| `Super + Shift + Arrow Keys` | Swap Active Window |
| `Super + Shift + (1,2,3)` | Move Active Window to [Number] Workspace |


## Style

<details>
<summary>Sexy Theme Switching Example</summary>

https://github.com/user-attachments/assets/0449763a-7b47-4c28-baa5-220d985f0a81

</details>

Many, many, many (autistic) hours were spent tweaking each theme CalOS ships with to compliment the entire OS. Your waybar, audio visualizer, terminal and system monitoring tools will all change based on the theme you're feeling. This took so long you son of a bitch you better use the themes

<p align="center">
<img width="3440" height="1440" alt="image" src="https://github.com/user-attachments/assets/f0d1f0b0-f0b2-4ce5-85e3-e188bae29b5d" />
<img width="3440" height="1440" alt="image" src="https://github.com/user-attachments/assets/ab0eca78-8598-48f3-a5da-cf2f5f79cb3e" />
<img width="3440" height="1440" alt="image" src="https://github.com/user-attachments/assets/e56d55e4-9a9e-45ca-9a27-f7b2d0b060ba" />
</p>


# Installation and Configuration

## How 2 Install

**You must have a fresh Arch install going into this.** Feel free to use any settings you want; from disk encryption to file system type. **Limine is heavily encouraged to be used as your bootloader as the installer enables extra features if it detects it.** Other bootloaders will function just fine, however. The only required settings are a **user with root** (which you should be using anyway, you dummy) and **pipewire to be installed**. 

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

* Try to familiarize yourself with all the keybinds to really get the most out of the system. Use `Super + K` to bring up your keybinds, sorted by importance.
* If you are a lazy sack of shit just read through the ~/.config/hypr configuration files as those are what you use to interact with your system.

## Why Paru?

* its better just try it don't be a bitch
