#!/bin/bash

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Launch Polybar, using default config location ~/.config/polybar/config
if [ "$device" == "laptop" ]; then
    polybar laptop &
else
    #polybar left &
    #polybar right &
    polybar main &
fi

echo "Polybar launched..."
