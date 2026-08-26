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
    class = "^(Impala|Bluetui|Wiremix|com.gabm.satty|TUI.float)$",
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

hl.window_rule({
  match = {
    class = "firefox",
  },

  tag = "+browser",
})

-- System Application Rules

hl.window_rule({
  match = {
    class = "cava",
  },
  workspace = "special:home",
  suppress_event = "activatefocus",
  no_initial_focus = true,
})

hl.window_rule({
  match = {
    class = "System-Update",
  },

  float = true,
  center = true,
  dim_around = true,
  size = "900 650",
  rounding = 20,
  rounding_power = 10,
})

hl.window_rule({
  match = {
    class = "dust",
  },

  float = true,
  center = true,
  dim_around = true,
  size = "900 650",
  rounding = 20,
  rounding_power = 10,
})

hl.window_rule({
  match = {
    class = "About",
  },

  float = true,
  dim_around = true,
  size = "775 375",
  move = { "monitor_w - 800", "47" },
  animation = "slide top",
  rounding = false,
})

hl.window_rule({
  match = {
    class = "Calos"
  },

  center = true,
  float = true,
  size = "800 600",
})

hl.window_rule({
  match = {
    class = "packages"
  },

  center = true,
  float = true,
  size = "800 600",
})

hl.window_rule({
  match = {
    class = "clipse",
  },

  center = true,
  float = true,
  animation = "slide bottom",
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
  size = "800 600",
  move = { "2634", "49" },
  animation = "popin 90%",
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
  decorate = false,
  move = { "100", "(monitor_h * 0.08)" },
})

hl.window_rule({
  match = {
    tag = "browser",
  },

  opacity = "1 override 1 override",
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
    class = "^(file_chooser)$",
  },

  float = true,
  size = "800 600",
  opacity = "1 1",
  dim_around = true,
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
  ignore_alpha = 0,
  no_anim = true,
})

hl.layer_rule({
  match = {
    namespace = "notifications",
  },

  blur = true,
  ignore_alpha = 0.2,
  animation = "slide right",
})

hl.layer_rule({
  match = {
    namespace = "quickshell:overview-blur",
  },

  blur = true,
  ignore_alpha = 0.8,
})

-- Enable blur for waybar

hl.layer_rule({ match = { namespace = "waybar" }, blur = true, ignore_alpha = 0.5 })

-- custom script for the 'homepage'

require("scripts.spiral")
require("scripts.columns")

-- per-workspacee layout rules

hl.workspace_rule({
  workspace = "special:home",
  layout = "lua:spiral",
  no_rounding = true,
  decorate = true,
})

hl.workspace_rule({
  workspace = "3",
  layout = "master",
})

hl.workspace_rule({
  workspace = "2",
  layout = "lua:columns",
})

hl.workspace_rule({
  workspace = "4",
  layout = "scrolling",
})
