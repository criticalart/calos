#!/bin/bash

if mountpoint -q /mnt/usb; then
  printf '{"text":"","tooltip":"Recovery USB mounted"}\n'
else
  printf '{"text":"","tooltip":""}\n'
fi
