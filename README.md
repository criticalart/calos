<p align="center">
<img width="697" height="564" alt="editme" src="https://github.com/user-attachments/assets/05789ba6-3832-400f-995e-082534f3ab7d" />  
</p>


# calOS Hyprland Starter
CalOS is a desktop-friendly Hyprland starter setup (Arch btw) that strives to be both feature-rich, yet nominal; a blank template that the user can build on top of (and it also looks really cool). With less than 600 packages on a complete install, calOS combines smart/minimal TUI-based defaults with smooth animations and extensive themeing.

tl;dr its dotfiles baby

<p align="center">
<img width="3440" height="1440" alt="image" src="https://github.com/user-attachments/assets/90e38647-dd65-407b-90ee-3639d1078d50" />
</p>

## Overview

* **🎮 Gaming Friendly**: calOS ships with numerous gaming-oriented configurations, all found in the `games.conf` file within `.config/hypr`. Features include a special workspace specifically for games, a custom gaming submap (with full waybar integration) that disables keybinds of your choosing + enables passthrough (for global vesktop/discord push to talk support) and Steam pre-installed (if chosen by the installer).
* **💻 Minimal System Apps**: Striving to be as bloat-free as possible, calOS primarily utilizes TUI applications/packages with minimal dependencies for system control. This includes `yazi` as your file browser, `cmus` for music, with `bluetui` and `impala` for bluetooth/wifi support.
*  **🧲 Total Walker/Waybar Integration**: Thanks to walker's extensive `dmenu` support, calOS has a powerful system menu that can help toggle/restart system daemons, launch applications, run system commands and even change your font/style. A custom fork of `mechabar` (Waybar) helps you keep on eye on your active workspaces, system resources, currently playing audio and pending updates. Easter egg included.
*  **🖌️ Style**: Speaking of _style_, calOS ships with 10+ themes that are fully integrated into the OS. Your waybar, Neovim, terminal applications, audio visuializer and walker menu all change based on the theme you pick! Check out the style section below for some examples. Shoutout to Omarchy for creating the excellent theme switcher that this is based on. Animations are all about being smooth and fast.
*  ⚖️ **Configurable Install**: With preconfigured dotfiles, you sometimes run the risk of too little control over what you have installed on your system. The installer tries to rectify this by allowing you to choose what defaults you want to use, such as picking your AUR helper `yay` vs `paru` (defaults to paru because iTS BETTER) and whether or not you want to install `Steam` with full system integration.
*  **🔧 Tinker Friendly**: Some dotfiles also make it very difficult to change certain aspects of your system, from keybinds to default applications. This is your computer and you can do whatever you want with it. All configuration files are in the `~/.config` directory, with your `hyprland` configuration files being neatly sourced in separate files for easy editing. Don't like something? Great, change it! To easily browse installed packages and "debloat", open up your system menu and navigate to System -> Packages to see what comes preinstalled.


## Core Applications

| Component | Application |
| --- | --- |
| **Compositor** | [Hyprland](https://hyprland.org/) |
| **Bar** | [Waybar](https://github.com/sejjy/mechabar) |
| **Wallpapers**| [swww](https://github.com/LGFae/swww) |
| **Notifications**| [mako](https://github.com/emersion/mako) |
| **Terminal** | [Alacritty](https://alacritty.org/) |
| **Launcher** | [Walker](https://github.com/abenz1267/walker) |
| **Font** | whatever u want ;) |


## Keybinds

For the uninitiated, your **Super** key is your windows key. Stop calling it the windows key.

### General

| Keybind | Action |
| --- | --- |
| `Super + Return` | Open Terminal |
| `Super + Q` | Kill Active Window |
| `Super + Escape` | Open System Menu |
| `Super + Alt + Space` | Open System Menu |
| `Super + B` | Browser (Firefox) |
| `Super + K` | List Keybinds |
| `Super + Space` | Application Launcher |
| `Super + Y` | Yazi |
| `Super + N` | Neovim |
| `Super + S` | BTop++ Monitor |

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


### Style

<details>
<summary>Sexy Theme Switching Example</summary>

https://github.com/user-attachments/assets/07587456-a2ed-4ae3-8ec3-8985569445b8

</details>

Many, many, many (autistic) hours were spent tweaking each theme CalOS ships with to compliment the entire OS. Your waybar, audio visualizer, terminal and system monitoring tools will all change based on the theme you're feeling. This took so long you son of a bitch you better use this feature

<p align="center">
<img width="3440" height="1440" alt="image" src="https://github.com/user-attachments/assets/6b212088-7e7b-4a73-aea7-413f2f004816" />
<img width="3440" height="1440" alt="image" src="https://github.com/user-attachments/assets/c4a07c54-fd81-4713-b5a3-f6bbe4f7a10a" />
<img width="3440" height="1440" alt="image" src="https://github.com/user-attachments/assets/e0c7e999-cfa9-46d4-84dd-7ba250ae107f" />
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

* It is imperative that you familiarize yourself with your new system. One of the best ways is to look through the various configuration files.
* If you are a lazy sack of shit just read through the ~/.config/hypr configuration files as those are what you use to interact with your system.

## Why Paru?

* its better just try it don't be a bitch
