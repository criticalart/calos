local close_on_click = {
  About = true,
  Impala = true,
  Bluetui = true,
  Wiremix = true,
  dust = true,
  packages = true,
  clipse = true,
  kernel = true,
}

hl.bind("mouse:273", function()
  local w = hl.get_active_window()

  if w and close_on_click[w.class] then
    hl.dispatch(hl.dsp.window.close())
  end
end, {
  non_consuming = true,
})
