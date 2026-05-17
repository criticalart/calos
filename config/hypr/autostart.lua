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

local cava_launch = "sleep 2 && "
	.. terminal
	.. " --class cava -e cava -p "
	.. home
	.. "/.config/calos/current/theme/cava/config"
local startjingle = "sleep 2 && ffplay -autoexit -nodisp " .. home .. "/.config/start.mp3"

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
	hl.exec_cmd(startjingle)

	-- Homepage
	hl.exec_cmd(terminal .. " --class cmus -e cmus", { workspace = "5 silent" })
	hl.exec_cmd("sleep 3 && " .. terminal .. " --class btop -e btop", { workspace = "5 silent" })
	hl.exec_cmd("sleep 1 && " .. terminal .. " --class $USER@$HOSTNAME", { workspace = "5 silent" })
	hl.exec_cmd(cava_launch)

	-- Application autostart
	--hl.exec_cmd("uwsm app -- vesktop", { workspace = "3 silent" })
	--hl.exec_cmd("uwsm app -- steam", { workspace = "3 silent" })
end)
