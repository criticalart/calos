-------------------------------------------------------------------------------
-- █████╗ ██╗   ██╗████████╗ ██████╗ ███████╗████████╗ █████╗ ██████╗ ████████╗
--██╔══██╗██║   ██║╚══██╔══╝██╔═══██╗██╔════╝╚══██╔══╝██╔══██╗██╔══██╗╚══██╔══╝
--███████║██║   ██║   ██║   ██║   ██║███████╗   ██║   ███████║██████╔╝   ██║
--██╔══██║██║   ██║   ██║   ██║   ██║╚════██║   ██║   ██╔══██║██╔══██╗   ██║
--██║  ██║╚██████╔╝   ██║   ╚██████╔╝███████║   ██║   ██║  ██║██║  ██║   ██║
--╚═╝  ╚═╝ ╚═════╝    ╚═╝    ╚═════╝ ╚══════╝   ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═╝   ╚═╝
-------------------------------------------------------------------------------

local terminal = "alacritty"
local home = os.getenv("HOME")
local boot = home .. "/.local/share/calos/bin/calos-boot"

hl.on("hyprland.start", function()
	-- Daemon autostart
	hl.exec_cmd("uwsm app -s b -t service -- hypridle")
	hl.exec_cmd("uwsm app -s b -t service -- hyprsunset")
	hl.exec_cmd("uwsm app -s b -t service -- mako")
	hl.exec_cmd("uwsm app -t service -- walker --gapplication-service")
	hl.exec_cmd("uwsm app -s b -t service -- awww-daemon")
	hl.exec_cmd("uwsm app -s b -t service -- swayosd-server")
	hl.exec_cmd("firststart")
	hl.exec_cmd("clipse -listen")
	hl.exec_cmd(boot)

	-- Homepage
	hl.exec_cmd("sleep 2 && " .. terminal .. " --class cmus -e cmus", { workspace = "special:home silent" })
	hl.exec_cmd(terminal .. " --class btop -e btop", { workspace = "special:home silent" })
	hl.exec_cmd("sleep 1 && " .. terminal .. " --class $USER@$HOSTNAME", { workspace = "special:home silent" })
	hl.exec_cmd(
		"sleep 3 && " .. terminal .. " --class cava -e cava -p " .. home .. "/.config/calos/current/theme/cava/config",
		{ workspace = "special:home silent" }
	)

	-- Application autostart
	--hl.exec_cmd("uwsm app -- steam", { workspace = "3 silent" })
end)
