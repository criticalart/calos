#!/bin/bash

if makoctl mode | grep -q 'do-not-disturb'; then
  echo '{"text": "󰂛", "tooltip": "Notifications Silenced", "class": "active"}'
else
  echo '{"text": ""}'
fi
