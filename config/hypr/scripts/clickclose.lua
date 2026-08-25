local close_on_click = {
  About = true,
  Impala = true,
  Bluetui = true,
}

local close_bind = hl.bind("mouse:272", hl.dsp.window.close(), {
  non_consuming = true,
})

close_bind:set_enabled(false)

local close_enabled = false

hl.on("window.active", function(w)
  local should_enable = w ~= nil and close_on_click[w.class] == true

  if should_enable ~= close_enabled then
    close_bind:set_enabled(should_enable)
    close_enabled = should_enable
  end
end)
