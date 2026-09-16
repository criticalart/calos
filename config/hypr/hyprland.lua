---------------------------------------------------------------------
--██╗  ██╗██╗   ██╗██████╗ ██████╗ ██╗      █████╗ ███╗   ██╗██████╗
--██║  ██║╚██╗ ██╔╝██╔══██╗██╔══██╗██║     ██╔══██╗████╗  ██║██╔══██╗
--███████║ ╚████╔╝ ██████╔╝██████╔╝██║     ███████║██╔██╗ ██║██║  ██║
--██╔══██║  ╚██╔╝  ██╔═══╝ ██╔══██╗██║     ██╔══██║██║╚██╗██║██║  ██║
--██║  ██║   ██║   ██║     ██║  ██║███████╗██║  ██║██║ ╚████║██████╔╝
--╚═╝  ╚═╝   ╚═╝   ╚═╝     ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═══╝╚═════╝
---------------------------------------------------------------------
---------------------------- Base Config ----------------------------
---------------------------------------------------------------------

-- Source the .config directory for themeing support, editing this breaks themes!

local home = os.getenv("HOME")
local theme = home .. "/.config/calos/current/theme/borders.lua"
local colors = dofile(theme)

-- The following options are recommended defaults

hl.config({
  general = {
    locale = "en_US", -- change this to your locale
    allow_tearing = true,

    col = {
      active_border = colors.borderactive,
      inactive_border = colors.borderinactive,
    },

    resize_on_border = false,
    layout = "dwindle",
  },
  ecosystem = {
    no_donation_nag = true, -- sorry vaxry :(
    no_update_news = true,
  },

  xwayland = {
    enabled = true,
    force_zero_scaling = true,
  },

  dwindle = {
    preserve_split = true,
    force_split = 2,
  },

  misc = {
    disable_hyprland_logo = true,
    disable_splash_rendering = true,
    disable_watchdog_warning = true,
    close_special_on_empty = true,
    focus_on_activate = true,
  },
})

hl.workspace_rule({
  workspace = "w[tv1]",
  gaps_out = { top = 60, right = 750, bottom = 60, left = 750 },
})

hl.workspace_rule({
  workspace = "w[tv2]",
  gaps_out = { top = 40, right = 60, bottom = 40, left = 60 },
  gaps_in = 30
})

hl.workspace_rule({
  workspace = "w[tv3]",
  gaps_out = { top = 15, right = 20, bottom = 15, left = 20 },
  gaps_in = 10
})

hl.workspace_rule({
  workspace = "1",
  persistent = true,
})

hl.workspace_rule({
  workspace = "special:steamcord",
  gaps_out = { top = 5, right = 5, bottom = 100, left = 5 },
  gaps_in = 3,
})

hl.window_rule({
  -- Ignore maximize requests from all apps. You'll probably like this.
  name = "suppress-maximize-events",
  match = { class = ".*" },

  suppress_event = "maximize",
})

hl.window_rule({
  -- Fix some dragging issues with XWayland
  name = "fix-xwayland-drags",
  match = {
    class = "^$",
    title = "^$",
    xwayland = true,
    float = true,
    fullscreen = false,
    pin = false,
  },

  no_focus = true,
})

-- Sourced config files

require("appearance")
require("autostart")
require("games")
require("input")
require("keybinds")
require("monitors")
require("windowrules")
require("scripts.zoom")
require("scripts.clickclose")

-- ENV Variables

hl.env("GTK_USE_PORTAL", "1")
hl.env("GDK_DEBUG", "portals")
