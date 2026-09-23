#!/bin/bash

if hyprctl submap | grep -q 'gaming'; then
  echo '{"text": "󰺷", "tooltip": "     Game Mode Enabled\n󰘳 SUPER Functionality Limited\nToggle using SUPER + CTRL + G", "class": "active"}'
else
  echo '{"text": ""}'
fi
