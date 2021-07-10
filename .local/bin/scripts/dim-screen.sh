#!/bin/bash

# Example notifier script -- lowers screen brightness, then waits to be killed
# and restores previous brightness on exit.

## CONFIGURATION ##############################################################

# Brightness will be lowered to this value.
min_brightness=0.7

###############################################################################

set_brightness() {
    xrandr --output "eDP-1" --brightness $1
}

fade_brightness() {
    set_brightness $1
}

trap 'exit 0' TERM INT
trap "set_brightness 1; kill %%" EXIT
fade_brightness $min_brightness
sleep 2147483647 &
wait
