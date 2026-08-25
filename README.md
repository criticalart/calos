<p align="center">
<img width="1518" height="1440" alt="image" src="https://github.com/user-attachments/assets/22813c2f-f939-45dd-9dab-f64ea11b1840" />
</p>


# calOS Hyprland Starter
CalOS is a desktop-friendly Hyprland starter setup (Arch btw) that strives to be both feature-rich, yet nominal; a blank template that the user can build on top of. With less than 600 packages on a complete install, calOS combines smart/minimal TUI-based defaults with smooth animations and extensive themeing. As of v0.8.5 quickshell integration has been complete, bringing a ton of smooth animations and polish for minimal system overhead.

tl;dr its dotfiles baby

<p align="center">
  <img width="3440" height="1440" alt="image" src="https://github.com/user-attachments/assets/7bb9867f-e02e-42dd-884d-031fe719cd7a" />
  <i>Homescreen / Task Manager / Overview Script</i>
</p>

## Overview

* **💻 Minimal System Apps**: Striving to be as bloat-free as possible, calOS primarily utilizes TUI applications/packages with minimal dependencies for system control. Examples include `yazi` as your file browser, `cmus` for playing local audio, and `bluetui`/`impala` for bluetooth/wifi support respectively.
* **🎮 Gaming Friendly**: calOS ships with numerous gaming-oriented configurations, all found in the `games.conf` file within `.config/hypr`. Features include a special workspace for games (`Super + G`), a custom gaming submap (with full waybar integration) that disables keybinds of your choosing + enables passthrough (for global push-to-talk support) and Steam pre-installed (if chosen by the installer).
*  **🧲 Complete Walker/Waybar Integration**: Thanks to walker's extensive `dmenu` support, calOS comes with a powerful system menu that can help toggle/restart system daemons, launch applications, run system commands and even change your current theme. A custom fork of `mechabar` (Waybar) helps you keep on eye on your active workspaces, system resources, currently playing audio and pending updates. Easter egg included.
*  **🖌️ Style**: Speaking of _style_, calOS ships with 10+ themes that are fully integrated into the OS. Your waybar, Neovim, terminal applications, audio visuializer and walker menu all change based on the theme you pick! Check out the style section below for some examples. Shoutout to Omarchy for creating the excellent theme switcher that this is based on. Multiple beziers were either created or imported (from popular configs like caelestia) for a beautifuly animated system. Quickshell is woven beautifully in the OS, from your power menu to your theme menu.
*  **⚖️ Configurable Install**: With preconfigured dotfiles, you sometimes run the risk of too little control over what you have installed on your system. The installer rectifies this by allowing you to choose what defaults you prefer, such as picking your AUR helper `yay` vs `paru` (defaults to paru because iTS BETTER) and whether or not you want to install `Steam` with full system integration.
*  **🔧 Tinker Friendly**: Some dotfiles also make it very difficult to change certain aspects of your system, from keybinds to default applications. This is your computer and you can do whatever you want with it. All configuration files are in the `~/.config` directory, with your `hyprland` configuration files being neatly sourced in separate files for easy editing. Don't like something? Great, change it! To easily browse installed packages and "de-bloat", open up your system menu and navigate to System -> Packages to see what comes preinstalled.


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
| SUPER | Open System Menu |
| `Super + Enter` | Open Terminal |
| `Super + Q` | Kill Active Window |
| `Super + Escape` | Open Homepage |
| `Super + Alt + Space` | Open System Menu (Alt) |
| `Super + B` | Browser (Firefox) |
| `Super + Space` | Application Launcher |
| `Super + Y` | Yazi (File Manager)|
| `Super + N` | Neovim |
| `Super + G` | Toggle Game Window |
| `Super + S` | BTop++ System Monitor |
| `Super + Backspace` | Toggle Opacity |


### System

System keybinds use **CTRL** and  **SUPER**.

| Keybind | Action |
| --- | --- |
| `Super + CTRL + L` | Screensaver |
| `Super + CTRL + N` | Toggle Bluelight |
| `Super + CTRL + W` | Toggle Waybar |
| `Super + CTRL + C` | Clipboard History |
| `Super + CTRL + S` | Power Options |
| `Super + CTRL + T` | Theme Menu |
| `Super + CTRL + G` | Toggle Game Mode |
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

<p align="center">
<img width="3440" height="1440" alt="image" src="https://github.com/user-attachments/assets/a04c4d61-e8bf-44d2-a9ce-066c91bce0aa" />
  <i>Theme Menu</i>
</p>

<details>
<summary>Sexy Theme Switching Example</summary>

https://github.com/user-attachments/assets/0449763a-7b47-4c28-baa5-220d985f0a81

</details>

Many, many, many (autistic) hours were spent tweaking each theme CalOS ships with to compliment the entire OS. Your waybar, audio visualizer, terminal and system monitoring tools will all change based on the theme you're feeling. This took so long you son of a bitch you better use the themes

<p align="center">
  <img width="3440" height="1440" alt="image" src="https://github.com/user-attachments/assets/42c7fe7a-1705-4a97-b31d-9d87717562be" />
  <br>
  <i>Launcher with Dynamic Location</i>
  <br><br>

  <img width="3440" height="1439" alt="image" src="https://github.com/user-attachments/assets/69962ad9-850a-403f-b7cd-264b2c045e42" />
  <br>
  <i>Quickshell Powermenu</i>
  <br><br>

  <img width="3440" height="1440" alt="image" src="https://github.com/user-attachments/assets/80845475-fd08-4c1f-9a88-6f2a22d6574c" />
  <br>
  <i>Glorious Window Management</i>
  <br><br>

  <img width="3440" height="1440" alt="image" src="https://github.com/user-attachments/assets/24e09b2a-c260-4ecc-898b-84b783278f14" />
  <br>
  <i>ok maybe a bit too much quickshell</i>
</p>


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

## Why Paru?

* its better just try it don't be a bitch
