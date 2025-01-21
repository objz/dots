#!/usr/bin/env bash

# This script will:
#   - Remember the current directory
#   - Start the helper script in the background (with the original arguments)
#   - Kill the active Kitty window (or terminal) via hyprctl

saved_dir="$PWD"

# Save all arguments in an array
args=("$@")

# Run the helper in the background so it continues after we kill this kitty
~/.config/nvim/scripts/nvid_helper.sh "$saved_dir" "${args[@]}" &

# Close the active window 
TERMINAL_PID=$(hyprctl activewindow | grep "pid:" | awk '{print $2}')

if [[ -n "$TERMINAL_PID" ]]; then
    kill "$TERMINAL_PID"
else
    echo "No terminal window found to close."
fi
