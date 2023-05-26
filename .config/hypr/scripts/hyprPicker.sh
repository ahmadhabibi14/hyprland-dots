#!/bin/bash

# Start HyprPicker to select a color
color=$(hyprpicker)

# Check if a color was selected
if [[ -n $color ]]; then
    # Copy the color value to the clipboard using wl-copy
    echo "$color" | wl-copy

    # Show a notification using Dunst
    dunstify -u normal -i ~/.icons/Tela-ubuntu-dark/scalable/apps/color.svg -t 2000 -a ColorPicker "$color"  "Copied to your clipboard!"
else
    # Show an error notification if no color was selected
    dunstify -u critical -t 2000 "Color picking canceled!" "No color selected."
fi