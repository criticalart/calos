# calOS
Arch/Hyprland OS based on Omarchy with extensive edits. Much less opinionated. Much less bloat. If you would like to try this on your own distro you **must** make certain changes that will be specified towards the bottom of this page. This OS was designed for myself alone and will require certain changes to work properly on your build. Desktop highly recommended. **DO NOT try this out unless you are somewhat competent with a terminal.** This does not support updates via Omarchy. You must know how to update Arch yourself and all the maintenence that comes alongside it.

## Changes

### System

* No longer forces disk encryption. You may choose any filesystem you would like. (You should still use btrfs though).
* Plymouth is no longer supported or used. In its place is a tty/drop-in script to log a specific user into Hyprland automatically with a bash_profile script. **Must be edited to properly work on your own PC.**
* **Heavily** debloated the initial install. Final package count is ~650. Many re-installs went into figuring out what can and can't be removed.
* No longer a dev-oriented build. Removed most, if not all, traces of dev environments. If you use your PC for browsing/gaming, this is for you.
* Customized boot-message shell script that allows you to launch or perform any command from the first, and only first, terminal window. Want to start your session with fastfetch or fortune displayed? Go for it. Easily customizable in your .bashrc after install.
* Snapshots are no longer forced/required. Since a specific filesystem/disk encryption is no longer forced you are free to choose your own service.
* Limine is still the default bootloader because why the fuck would you use GRUB
* While the install was heavily debloated, a few additional packages were added; firefox, gamescope and fortune-mod. Honestly you should be using the first two anyways.
* Removed anything that has to do with portability, such as battery display. This is meant for a desktop. Since that information is not relevant waybar has been edited to give more information on your system, such as temps and CPU/RAM usage.
* CAPS LOCK IS BACK. (Xcompose is out)
* yazi baby. Nautilus is out. He's so hot right now.

### Style

* Changed default theme on first launch. Make it feel more Hyprland-y.
* Removed Omarchy logo and replaced with Arch logo in almost every instance. Felt kind of weird doing this but ultimately this is an Arch distro first and foremost.
* Added more themes to the install. Parsed every theme to make sure it was uniform with the rest of the system; e.g. blueridge would overwrite your font when you switched to it, now it doesn't.
* **Made a custom starship bash prompt for every theme included in the install**. This took HOURS. A different starship prompt. For every theme. I hate being autistic.
* Animations added for workspaces and specialWorkspaceIn/Out.
* Changed default cursor to look more _uhh_ not boring.
* Cool Limine background #wow #whoa

### Usability

* Added support for specialWorkspaces for gaming and gamescope. Hit SUPER, G to easily switch between your currently running game and workspace(s). Will work alongside gamescope.
* Changed layering for waybar so it's more compatible for gaming across the board.
* Tweaked various settings and defaults. Feel free to parse them yourself, one of Omarchy's strengths is how configurable it is so if I added something it doesn't really matter, just change it.
* Changed firefox to the default browser. Get wrecked, Google.
* Some cool defaults in autostart.conf, including timers for launching applications in a specific order. Super helpful for layouts.
* Moved around the main menu. Config is now front and center for easy access to your configuration files. Removed redundant menu items.
* A ton of other shit I just don't feel like going over.

# Installation and Configuration

## How 2 Install

Have a fresh-baked Arch install going into this. **Make sure Lumine is your bootloader.**
```
sudo pacman -S git nano
```
Install git to clone the repository and nano to edit a few configuration files below.

Create your directories:
```
mkdir .local
mkdir .local/share
cd .local/share
```

From there, clone this repository:

```
git clone https://github.com/art-caliburn/calos
```
Then cd into /calos/ and ./install.sh. Wow crazy. **Don't do it yet though**, there are a few things you have to configure below:

## Required Configuration

**The following settings must be changed or you will not be able to boot.**

* Go into the /calos/install directory and find skip_username.conf. Replace "arthur" with your username. This will allow you to only have to type your password upon logging in.
* Under /calos/config/hypr **make sure to change the monitors.conf file** to match your respective resolution/refresh rate.
* I always felt that Hyprland by default was a bit too sensitive with the mouse, so I lowered the sensitivity to -0.5. Simply comment this line our or change it to your preference.
* That's all for the required configurations. I encourage you to do your own research and edit this to your heart's content.


That's all there is to it. Omarchy is an absolutely incredible tool but it's a bit too opinionated for me so I made calOS. Try it out and make your own fork/OS afterwards. Thank you DHH/basecamp for documenting everything as well as you did. Made it super easy to make this
