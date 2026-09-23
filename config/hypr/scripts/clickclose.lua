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

  if not w then
    return
  end

  -- Close specific window classes regardless of cursor position
  if close_on_click[w.class] then
    hl.dispatch(hl.dsp.window.close())
    return
  end

  -- Close/toggle only when right-clicking the upper-right 10%
  local cursor = hl.get_cursor_pos()

  local x = w.at.x
  local y = w.at.y
  local width = w.size.x
  local height = w.size.y

  local hitbox_width = width * 0.10
  local hitbox_height = height * 0.10

  local in_upper_right =
      cursor.x >= x + width - hitbox_width and
      cursor.x <= x + width and
      cursor.y >= y and
      cursor.y <= y + hitbox_height

  if in_upper_right then
    if w.class == "vesktop" then
      hl.dispatch(hl.dsp.workspace.toggle_special("discord"))
    else
      hl.dispatch(hl.dsp.window.close())
    end
  end
end, {
  non_consuming = true,
})
