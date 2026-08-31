hl.on("hyprland.start", function()
  hl.exec_cmd("regreet; hyprctl dispatch 'hl.dsp.exit()'")
end)
hl.config({
  misc = {
    disable_hyprland_logo = true,
    disable_splash_rendering = true,
    disable_hyprland_guiutils_check = true,
  },
})

hl.env("GTK_USE_PORTAL", "0")
hl.env("GDK_DEBUG", "no-portals")
