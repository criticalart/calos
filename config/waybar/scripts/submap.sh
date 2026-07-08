#!/bin/bash

if hyprctl submap | grep -q 'gaming'; then
  echo '{"text": "󰺷", "tooltip": "Game Mode Enabled\nSUPER + CTRL + G or click to disable", "class": "active"}'
else
  echo '{"text": ""}'
fi
