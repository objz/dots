
#!/bin/bash

# Fetch song info from playerctl
player_status=$(playerctl status 2>/dev/null)

if [[ "$player_status" == "Playing" || "$player_status" == "Paused" ]]; then
    # Get metadata
    title=$(playerctl metadata --format '{{title}}')
    artist=$(playerctl metadata --format '{{artist}}')
    icon=""
    # Format the output
    echo "$icon  $title - $artist"
else
    echo "No music playing"
fi

