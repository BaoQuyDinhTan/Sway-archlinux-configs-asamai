#!/bin/bash

# File to store the current temperature
TEMP_FILE="/tmp/current_temp"

# Default temperature
DEFAULT_TEMP=6500

# Minimum temperature
MIN_TEMP=1000

# Step size
STEP=500

case $1 in
    increase)
        # Check if file exists, if not assume default
        if [ ! -f "$TEMP_FILE" ]; then
            CURRENT=$DEFAULT_TEMP
        else
            CURRENT=$(cat "$TEMP_FILE")
        fi

        # Calculate new temperature
        NEW_TEMP=$((CURRENT - STEP))

        # Don't go below minimum
        if [ "$NEW_TEMP" -lt "$MIN_TEMP" ]; then
            NEW_TEMP=$MIN_TEMP
        fi

        # Save new temp
        echo "$NEW_TEMP" > "$TEMP_FILE"
        
        # Kill previous instance
        pkill wlsunset
        
        # Start new instance
        # FIX: We set Day Temp (-T) to NEW_TEMP + 1 so it is always higher than Night Temp (-t).
        # We also set location (-l 0 -L 0) to ensure it runs without needing a GPS sensor.
        wlsunset -t "$NEW_TEMP" -T "$((NEW_TEMP + 1))" -l 0 -L 0 > /dev/null 2>&1 &
        ;;
    
    reset)
        # Remove the temp file and kill wlsunset
        rm -f "$TEMP_FILE"
        pkill wlsunset
        ;;
esac
