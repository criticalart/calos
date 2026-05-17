#!/bin/bash

echo
notify-send "Launching Steam Big Picture Mode"
steam steam://open/bigpicture
sleep 1
hyprctl dispatch 'hl.dsp.focus({ workspace = "10" })'
sleep 5
hyprctl dispatch 'hl.dsp.window.fullscreen({ fullscreen, set, window = "title:Steam Big Picture Mode" })'
exit
