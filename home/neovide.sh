#!/bin/bash

# Retrieve the PID of the active terminal
TERMINAL_PID=$(hyprctl activewindow | grep "pid:" | awk '{print $2}')

# Launch Neovide detached from the terminal
neovide --fork "$@"
NEOVIDE_PID=$!

# Close the terminal window if a valid PID was found
if [[ -n "$TERMINAL_PID" ]]; then
    kill "$TERMINAL_PID"
else
    echo "No terminal window found to close."
fi


