#!/bin/bash

if hyprctl hyprsunset temperature | grep -q '4000'; then
  echo '{"text": "", "tooltip": "Bluelight Filter On", "class": "active"}'
else
  echo '{"text": ""}'
fi
