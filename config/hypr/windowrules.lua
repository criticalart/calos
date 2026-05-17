-----------------------------------------------------------
--██╗    ██╗██╗███╗   ██╗██████╗  ██████╗ ██╗    ██╗███████╗
--██║    ██║██║████╗  ██║██╔══██╗██╔═══██╗██║    ██║██╔════╝
--██║ █╗ ██║██║██╔██╗ ██║██║  ██║██║   ██║██║ █╗ ██║███████╗
--██║███╗██║██║██║╚██╗██║██║  ██║██║   ██║██║███╗██║╚════██║
--╚███╔███╔╝██║██║ ╚████║██████╔╝╚██████╔╝╚███╔███╔╝███████║
-- ╚══╝╚══╝ ╚═╝╚═╝  ╚═══╝╚═════╝  ╚═════╝  ╚══╝╚══╝ ╚══════╝  (not the bad one)
-----------------------------------------------------------

-- Tagging

hl.window_rule({
	match = {
		class = "^(Impala|Bluetui|Wiremix|com.gabm.satty|Calos|TUI.float)$",
	},

	tag = "+floating-window",
})

hl.window_rule({
	match = {
		title = "(Picture.?in.?[Pp]icture)$",
	},

	tag = "+pip",
})

hl.window_rule({
	match = {
		initial_title = "Discord Popout",
	},

	tag = "+pip",
})

-- System Application Rules

hl.window_rule({
	match = {
		class = "cava",
	},
	workspace = "5 silent",
})

hl.window_rule({
	match = {
		class = "System-Update",
	},

	float = true,
	center = true,
	dim_around = true,
	size = "900 650",
})

hl.window_rule({
	match = {
		class = "About",
	},

	float = true,
	dim_around = true,
	size = "775 350",
	move = { "monitor_w - 800", "(monitor_h * 0.03)" },
	animation = "slide top",
})

hl.window_rule({
	match = {
		class = "clipse",
	},

	center = true,
	float = true,
	animation = "slide bottom 10%",
	size = "800 600",
})

-- Media Defaults

hl.window_rule({
	match = {
		class = "^(ffplay|vlc|mpv|mp4|com.obsproject.Studio|.*Pinta|pqiv)$",
	},

	opacity = "1 1",
	size = "1000 800",
	center = true,
	float = true,
	rounding = 0,
	border_size = 0,
})

-- Tag-based Rules

hl.window_rule({
	match = {
		tag = "floating-window",
	},

	float = true,
	center = true,
	size = "800 600",
})

hl.window_rule({
	match = {
		tag = "pip",
	},

	float = true,
	pin = true,
	size = "600 350",
	keep_aspect_ratio = true,
	border_size = 0,
	opacity = "1 1",
	move = { "100", "(monitor_h * 0.08)" },
})

-- Screensaver default

hl.window_rule({
	match = {
		class = "Screensaver",
	},

	fullscreen = true,
	animation = "slide bottom",
})

-- Electron App Fuckery

hl.window_rule({
	match = { class = "vesktop" },

	no_initial_focus = true,
	suppress_event = "activatefocus",
	workspace = "3 silent",
})

-- Miscellaneous Rules

hl.window_rule({
	match = {
		class = "^(xdg-desktop-portal-gtk)$",
	},

	float = true,
	size = "600 400",
})

hl.window_rule({
	match = {
		title = "^(Library)$",
	},

	float = true,
	size = "800 400",
})

-- Layer Rules

hl.layer_rule({
	match = {
		namespace = "walker",
	},

	blur = true,
	animation = "popin 50%",
	ignore_alpha = 0,
})

hl.layer_rule({
	match = {
		namespace = "notifications",
	},

	blur = true,
	ignore_alpha = 0.2,
	animation = "slide right",
})

-- custom script for the 'homepage'

require("scripts.grid")
hl.workspace_rule({ workspace = "5", layout = "lua:grid" })
