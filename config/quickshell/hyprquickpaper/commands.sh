#!/bin/bash

awww img $1 --resize stretch --transition-type grow --transition-fps 144 --transition-duration 1
ln -nsf $1 $HOME/.config/calos/current/background
