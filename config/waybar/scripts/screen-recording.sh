#!/bin/bash

if pgrep -f "gpu-screen-recorder" >/dev/null; then
  echo '{"text": "", "tooltip": "Stop Recording", "class": "active"}'
else
  echo '{"text": ""}'
fi
