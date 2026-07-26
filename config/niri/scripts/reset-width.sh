#!/bin/sh

# Niri has reset-window-height, but no matching reset-column-width action.
# Restore the configured default width for the focused output instead.
if niri msg --json focused-output | grep -Eq '"name"[[:space:]]*:[[:space:]]*"DP-5"'; then
    exec niri msg action set-column-width "100%"
else
    exec niri msg action set-column-width "50%"
fi
