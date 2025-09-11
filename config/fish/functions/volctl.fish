#!/usr/bin/env fish

function print_usage
    echo "Usage: volctl -[device] <action> [step]"
    echo
    echo "Devices:"
    echo "  -i    Input (mic)"
    echo "  -o    Output (speaker)"
    echo "  -p    Player (with playerctl)"
    echo
    echo "Actions:"
    echo "  i     Increase volume"
    echo "  d     Decrease volume"
    echo "  m     Toggle mute"
    echo "  n     Next track (players only)"
    echo "  b     Previous track (players only)"
    echo "  p     Play/Pause toggle (players only)"
    echo
    echo "Optional:"
    echo "  step  Volume step (default: 5)"
end

function notify_vol --argument-names vol nsink
    set angle (math "((($vol + 2) / 5) * 5)")
    set ico "$HOME/.config/dunst/icons/vol/vol-$angle.svg"
    set bar (string repeat -n (math "$vol / 15") ".")
    notify-send -a "volctl" -r 91190 -t 800 -i "$ico" "$vol$bar" "$nsink"
end

function notify_mute --argument-names is_input muted
    if test "$is_input" = "true"
        set dvce "mic"
    else
        set dvce "speaker"
    end

    if test "$muted" = "true"
        notify-send -a "volctl" -r 91190 -t 800 -i "$HOME/.config/dunst/icons/vol/muted-$dvce.svg" "muted"
    else
        notify-send -a "volctl" -r 91190 -t 800 -i "$HOME/.config/dunst/icons/vol/unmuted-$dvce.svg" "unmuted"
    end
end

function get_default_sink
    wpctl status | awk '/\*.*Audio\/Sink/ {print $3; exit}'
end

function get_default_source
    wpctl status | awk '/\*.*Audio\/Source/ {print $3; exit}'
end

function get_volume --argument-names id
    wpctl get-volume $id | awk '{printf "%.0f\n",$2*100}'
end

function get_mute --argument-names id
    wpctl get-volume $id | awk '{print $3}'
end

function change_volume --argument-names action step id nsink
    set delta "+"
    test "$action" = "d"; and set delta "-"
    wpctl set-volume $id "$delta$step%" 
    set vol (get_volume $id)
    notify_vol $vol $nsink
end

function toggle_mute --argument-names id is_input
    wpctl set-mute $id toggle
    set muted (get_mute $id)
    notify_mute $is_input $muted
end

function player_control --argument-names action player
    switch $action
        case i d
            set delta "+"
            test "$action" = "d"; and set delta "-"
            playerctl --player=$player volume (math "0.05$delta")
            set vol (playerctl --player=$player volume | awk '{printf "%.0f\n",$1*100}')
            notify_vol $vol $player
        case m
            playerctl --player=$player play-pause
        case n
            playerctl --player=$player next
        case b
            playerctl --player=$player previous
        case p
            playerctl --player=$player play-pause
    end
end

# --- main ---
set step 5
argparse i o p= -- $argv

if set -q _flag_i
    set id (get_default_source)
    set is_input true
    set nsink "Mic"
else if set -q _flag_o
    set id (get_default_sink)
    set is_input false
    set nsink "Speaker"
else if set -q _flag_p
    set device "playerctl"
    set player $_flag_p
else
    print_usage
    exit 1
end

set action $argv[1]
set step (math "$argv[2] ? $argv[2] : $step")

if test "$device" = "playerctl"
    player_control $action $player
else
    switch $action
        case i d
            change_volume $action $step $id $nsink
        case m
            toggle_mute $id $is_input
        case '*'
            print_usage
    end
end
