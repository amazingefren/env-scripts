#!/bin/bash

lock="swaylock --screenshots --effect-blur 6x6 --fade-in 0.2 --clock --indicator --effect-vignette 0.2:0.7 --indicator-radius 125 --indicator-thickness 6 --ring-color 333333 --key-hl-color ff0000 --line-color 222222 --effect-greyscale --inside-color 181818de"

if [[ "$1" == "--start" ]]; then
    killall swayidle
    swayidle -w timeout 300 "$lock" before-sleep "$lock" &>/dev/null &
    dunstify "Caffeine Disabled" -r 120120120
    exit 0
elif pgrep -x "swayidle" > /dev/null; then
    dunstify "Caffeine Enabled" -r 120120120
    killall swayidle
    exit 0
else
    dunstify "Caffeine Disabled" -r 120120120
    swayidle -w timeout 300 "$lock" before-sleep "$lock" &>/dev/null &
    exit 0
fi
