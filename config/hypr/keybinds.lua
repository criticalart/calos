----------------------------------------------------------------
--██╗  ██╗███████╗██╗   ██╗██████╗ ██╗███╗   ██╗██████╗ ███████╗
--██║ ██╔╝██╔════╝╚██╗ ██╔╝██╔══██╗██║████╗  ██║██╔══██╗██╔════╝
--█████╔╝ █████╗   ╚████╔╝ ██████╔╝██║██╔██╗ ██║██║  ██║███████╗
--██╔═██╗ ██╔══╝    ╚██╔╝  ██╔══██╗██║██║╚██╗██║██║  ██║╚════██║
--██║  ██╗███████╗   ██║   ██████╔╝██║██║ ╚████║██████╔╝███████║
--╚═╝  ╚═╝╚══════╝   ╚═╝   ╚═════╝ ╚═╝╚═╝  ╚═══╝╚═════╝ ╚══════╝
----------------------------------------------------------------

local terminal = "alacritty"
local browser = "firefox"

-----------------------------
---- SYSTEM APPLICATIONS ----
-----------------------------

hl.bind("SUPER + SPACE", hl.dsp.exec_cmd("walker --maxheight 350 -p Launch..."))
hl.bind("SUPER + RETURN", hl.dsp.exec_cmd(terminal .. " --working-directory=$(calos-cmd-terminal-cwd)"))
hl.bind("SUPER + N", hl.dsp.exec_cmd(terminal .. " --class Neovim -e nvim"))
hl.bind("SUPER + S", hl.dsp.exec_cmd(terminal .. " --class 'BTOP++ System Monitor' -e btop"))
hl.bind("SUPER + Y", hl.dsp.exec_cmd(terminal .. " --class yazi -e yazi"))
hl.bind("SUPER + SUPER_L", hl.dsp.exec_cmd("calos-menu"), { release = true })
hl.bind("SUPER + B", hl.dsp.exec_cmd(browser))
hl.bind("SUPER + D", hl.dsp.exec_cmd("vesktop"))

---------------------------
---- SYSTEM MANAGEMENT ----
---------------------------

require("scripts.ctrlbinds") -- allows "CTRL + " shortcuts to work with SUPER, such as copy/paste and new tabs
hl.bind("SUPER + BACKSPACE", hl.dsp.exec_cmd("calos-toggle-opacity"))
hl.bind("SUPER + CTRL + T", hl.dsp.exec_cmd("walker -H -N -n -m menus:calosthemes --minwidth 300 --height 600"))
hl.bind("SUPER + CTRL + B", hl.dsp.exec_cmd("calos-theme-bg-next"))
hl.bind("SUPER + CTRL + C", hl.dsp.exec_cmd(terminal .. " --class clipse -e clipse"))
hl.bind("SUPER + CTRL + W", hl.dsp.exec_cmd("calos-toggle-waybar"))
hl.bind(
	"SUPER + CTRL + U",
	hl.dsp.exec_cmd(terminal .. " --class=System-Update -e ~/.config/waybar/scripts/term-update.sh start")
)
hl.bind("SUPER + CTRL + N", hl.dsp.exec_cmd("calos-toggle-nightlight"))
hl.bind("SUPER + CTRL + S", hl.dsp.exec_cmd("calos-menu system"))
hl.bind("SUPER + H", hl.dsp.focus({ workspace = 5 })) -- equivalent to the "home page"
hl.bind("SUPER + CTRL + L", hl.dsp.exec_cmd("calos-launch-screensaver"))
hl.bind("CAPS + Caps_Lock", hl.dsp.exec_cmd("swayosd-client --caps-lock"))
hl.bind("CTRL + ALT + DELETE", hl.dsp.exec_cmd("calos-cmd-close-all-windows")) -- will close all windows on current workspace
hl.bind("XF86PowerOff", hl.dsp.exec_cmd("calos-menu system"))

---------------------------
---- BROWSER SHORTCUTS ----
---------------------------

hl.bind("SUPER + SHIFT + B", hl.dsp.exec_cmd(browser))
hl.bind("SUPER + SHIFT + N", hl.dsp.exec_cmd(browser .. " --private-window"))
hl.bind("SUPER + SHIFT + T", hl.dsp.exec_cmd(browser .. " --new-window https://twitch.tv"))
hl.bind("SUPER + SHIFT + R", hl.dsp.exec_cmd(browser .. " --new-window https://reddit.com"))
hl.bind("SUPER + SHIFT + Y", hl.dsp.exec_cmd(browser .. " --new-window https://youtube.com"))
hl.bind("SUPER + SHIFT + G", hl.dsp.exec_cmd(browser .. " --new-window https://github.com"))

------------------------------
---- NOTIFICATION CONTROL ----
------------------------------

hl.bind("SUPER + COMMA", hl.dsp.exec_cmd("makoctl dismiss"))
hl.bind("SUPER + SHIFT + COMMA", hl.dsp.exec_cmd("makoctl dismiss --all"))
hl.bind(
	"SUPER + CTRL + COMMA",
	hl.dsp.exec_cmd(
		"makoctl mode -t do-not-disturb && makoctl mode | grep -q 'do-not-disturb' && notify-send 'Silenced notifications' || notify-send 'Enabled notifications'"
	)
)

--------------------------------
---- WORKSPACE MANIPULATION ----
--------------------------------

for i = 1, 9 do
	hl.bind("SUPER + " .. i, hl.dsp.focus({ workspace = i }))
	hl.bind("SUPER + SHIFT + " .. i, hl.dsp.window.move({ workspace = i }))
end

hl.bind("SUPER + 0", hl.dsp.focus({ workspace = 10 }))
hl.bind("SUPER + SHIFT + 0", hl.dsp.window.move({ workspace = 10 }))

hl.bind("SUPER + left", hl.dsp.focus({ direction = "left" }))
hl.bind("SUPER + right", hl.dsp.focus({ direction = "right" }))
hl.bind("SUPER + up", hl.dsp.focus({ direction = "up" }))
hl.bind("SUPER + down", hl.dsp.focus({ direction = "down" }))

hl.bind("SUPER + SHIFT + LEFT", hl.dsp.window.swap({ direction = "l" }))
hl.bind("SUPER + SHIFT + RIGHT", hl.dsp.window.swap({ direction = "r" }))
hl.bind("SUPER + SHIFT + UP", hl.dsp.window.swap({ direction = "u" }))
hl.bind("SUPER + SHIFT + DOWN", hl.dsp.window.swap({ direction = "d" }))

-----------------------
---- MOUSE CONTROL ----
-----------------------

require("scripts.scroll")
hl.bind("SUPER + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind("SUPER + mouse:273", hl.dsp.window.resize(), { mouse = true })

------------------------
---- WINDOW CONTROL ----
------------------------

hl.bind("SUPER + Q", hl.dsp.window.close())
hl.bind("SUPER + F", hl.dsp.window.float({ action = "toggle" }))
hl.bind("SUPER + J", hl.dsp.layout("togglesplit"))
hl.bind("SUPER + P", hl.dsp.window.pseudo())
hl.bind("SUPER + TAB", hl.dsp.window.cycle_next({ next = false }))

------------------------
---- SCREEN CAPTURE ----
------------------------

hl.bind("SUPER + SHIFT +S", hl.dsp.exec_cmd("hyprshot -m region --freeze"))
hl.bind("PRINT", hl.dsp.exec_cmd("hyprshot -m output"))
hl.bind("SUPER + CONTROL + P", hl.dsp.exec_cmd("pkill hyprpicker || hyprpicker -a"))
hl.bind("SUPER + PRINT", hl.dsp.exec_cmd("calos-cmd-screenrecord"))

-----------------------
---- FN KEYS MEDIA ----
-----------------------

hl.bind("XF86AudioNext", hl.dsp.exec_cmd("swayosd-client --playerctl next"))
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("swayosd-client --playerctl play-pause"))
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("swayosd-client --playerctl play-pause"))
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("swayosd-client --playerctl previous"))
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("swayosd-client --output-volume raise"))
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("swayosd-client --output-volume lower"))
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("swayosd-client --output-volume mute-toggle"))
