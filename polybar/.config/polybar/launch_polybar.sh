#!/bin/bash

CONFIG_PATH="$HOME/.config/polybar/config.ini"

if type "xrandr"; then
  for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
    MONITOR=$m polybar --reload toph --config=$CONFIG_PATH &
  done
else
  polybar --reload toph --config=$CONFIG_PATH &
fi