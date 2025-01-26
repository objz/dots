#!/usr/bin/env bash

# This script will:
#   - Use the current directory if no arguments are passed
#   - Resolve the directory via zoxide if a partial path is provided
#   - Allow explicit paths or arguments
#   - Start the helper script in the background (with the resolved directory and arguments)
#   - Kill the active Kitty window (or terminal) via hyprctl

if [[ -z "$1" ]]; then
    saved_dir="$PWD"
    args=(".")
else
    if zoxide query "$1" &>/dev/null; then
        saved_dir=$(zoxide query "$1")
    elif [[ -d "$1" ]]; then
        saved_dir="$1"
    else
        saved_dir="$PWD"
        args=("$@")
    fi

    if [[ -d "$saved_dir" ]]; then
        args=("${@:2}")
    fi
fi

~/.config/nvim/scripts/nvid_helper.sh "$saved_dir" "${args[@]}" &

TERMINAL_PID=$(hyprctl activewindow | grep "pid:" | awk '{print $2}')

if [[ -n "$TERMINAL_PID" ]]; then
    kill "$TERMINAL_PID"
else
    echo "No terminal window found to close."
fi

