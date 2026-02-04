#!/bin/bash
INTERNAL="eDP-1"
EXTERNAL="HDMI-A-1"

# 1. Define the options that will appear in the menu
options="Laptop\nExternal\nBoth"

# 2. Show the menu using Rofi (matches your system style)
# It waits for you to pick an option
selected=$(echo -e "$options" | rofi -dmenu -i -p "Display Mode")

# 3. Check connection status for safety
IS_CONNECTED=$(swaymsg -t get_outputs | grep "$EXTERNAL")

# 4. Execute the command based on your choice
case $selected in
    "Laptop")
        swaymsg output $EXTERNAL disable
        swaymsg output $INTERNAL enable
        ;;
    "External")
        if [ -z "$IS_CONNECTED" ]; then
            notify-send "Error" "External monitor not detected!"
        else
            swaymsg output $INTERNAL disable
            swaymsg output $EXTERNAL enable
        fi
        ;;
    "Both")
        swaymsg output $INTERNAL enable
        if [ -n "$IS_CONNECTED" ]; then
            swaymsg output $EXTERNAL enable
        fi
        ;;
esac
