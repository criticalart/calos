---------------------------------------------
-- ██████╗  █████╗ ███╗   ███╗███████╗███████╗
--██╔════╝ ██╔══██╗████╗ ████║██╔════╝██╔════╝
--██║  ███╗███████║██╔████╔██║█████╗  ███████╗
--██║   ██║██╔══██║██║╚██╔╝██║██╔══╝  ╚════██║
--╚██████╔╝██║  ██║██║ ╚═╝ ██║███████╗███████║
-- ╚═════╝ ╚═╝  ╚═╝╚═╝     ╚═╝╚══════╝╚══════╝
---------------------------------------------

-- Default gaming workspace key, default is 'G' (for game get it)

hl.bind("SUPER + G", hl.dsp.workspace.toggle_special("game"))

-- Add your launchers/games to the options below as needed; defaults should cover most things probably maybe

hl.window_rule({
	name = "Game Launcher",
	match = {
		class = ".*LAUNCHER.*|XIVLauncher.Core",
	},

	float = true,
	center = true,
	persistent_size = true,
	workspace = 3,
})

hl.window_rule({
	name = "Game Window",
	match = {
		class = "steam_app_.*|dota2|eden|.*Metroid.*|Godot|Ryujinx|gamescope|ffxiv_dx11.exe", -- add your games here, follow regex!
	},

	fullscreen = true,
	workspace = "special:game",
	immediate = true,
})

-- Some launchers in wine prefixes do not follow workspace rules, this aims to fix that

hl.window_rule({
	name = "Mod Launcher",
	match = {
		title = "^(Z:.*)$",
	},

	float = false,
	workspace = 3,
})

-- Steam specific options

hl.window_rule({
	name = "Default Steam Rules",
	match = {
		class = "steam",
	},

	suppress_event = "activatefocus",
	no_initial_focus = true,
	workspace = "3 silent", -- change this to whatever workspace you want your steam to run, defaults to 3 in autostart as well
})

hl.window_rule({
	name = "Big Picture Rules", -- Big Picture mode can cause problems sometimes, be careful!
	match = {
		initial_title = "Steam Big Picture Mode",
	},

	opacity = "1 1",
	rounding = 0,
	workspace = "10",
})

hl.window_rule({
	name = "Steam Friends",
	match = {
		title = "Friends List",
	},

	float = true,
	opacity = "1 1",
	size = "800 800",
	move = "200 200",
})

hl.window_rule({
	name = "Steam Settings",
	match = {
		title = "Steam Settings",
	},

	float = true,
	opacity = "1 1",
})

hl.window_rule({
	name = "Steam Property Float",
	float = true,
	match = {
		class = "^(steam)$",
		title = "negative:^(Steam)$",
	},
})

-- Gaming Mode Submap config

hl.bind(
	"SUPER + CTRL + G",
	hl.dsp.exec_cmd(
		"notify-send 'SUPER Key Functionality Disabled' 'To revert to standard keybindings, use SUPER + CTRL + R.\nKeybind for closing applications is now SUPER + ESC.\nYou can also click the waybar icon to revert back.'"
	)
)
hl.bind("SUPER + CTRL + G", hl.dsp.submap("gaming"))

hl.define_submap("gaming", function()
	hl.bind(
		"SUPER + CTRL + R",
		hl.dsp.exec_cmd(
			"notify-send 'SUPER Key Functionality Enabled' 'All functionality has been restored to default settings.'"
		)
	)
	hl.bind("SUPER + ESCAPE", hl.dsp.window.close())
	hl.bind("SUPER + G", hl.dsp.workspace.toggle_special("game"))
	hl.bind("SUPER + ALT + SPACE", hl.dsp.exec_cmd("calos-menu"))

	-- defaults that should have the universal flag, will be removed eventually
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
	hl.bind("SUPER + SPACE", hl.dsp.exec_cmd("walker --maxheight 350 -p Launch..."))
	hl.bind("SUPER + RETURN", hl.dsp.exec_cmd("alacritty --working-directory=$(calos-cmd-terminal-cwd)"))
	-- end of universal defaults

	--submap reset
	hl.bind("SUPER + CTRL + R", hl.dsp.submap("reset"))
end)
