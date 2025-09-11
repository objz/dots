#!/usr/bin/env fish

function print_usage
    echo "Usage: volctl -[device] <action> [step]"
    echo
    echo "Devices:"
    echo "  -i    Input (mic)"
    echo "  -o    Output (speaker)"
    echo "  -p    Player"
    echo
    echo "Actions:"
    echo "  i     Increase volume"
    echo "  d     Decrease volume"
    echo "  m     Toggle mute"
    echo "  n     Next track (player)"
    echo "  b     Previous track (player)"
    echo "  p     Play/Pause (player)"
    echo
    echo "Optional:"
    echo "  step  Volume step in % (default: 5)"
end

# ---------- glyphs ----------
function _vol_glyph --argument-names vol muted
    if test "$muted" = "true"
        echo ""; return
    end
    if test $vol -ge 66
        echo ""
    else if test $vol -ge 33
        echo ""
    else
        echo ""
    end
end

function _transport_glyph --argument-names action pstatus
    switch $action
        case n
            echo ""   # next
        case b
            echo ""   # previous
        case p
            if test "$pstatus" = "Playing"
                echo ""   # now playing -> show pause icon
            else
                echo ""   # now paused -> show play icon
            end
        case '*'
            echo ""
    end
end

# ---------- notifications ----------
function notify_player --argument-names action pstatus
    switch $action
        case n; set verb "next"
        case b; set verb "previous"
        case p
            if test "$pstatus" = "Playing"
                set verb "playing"
            else if test "$pstatus" = "Paused"
                set verb "paused"
            else
                set verb "toggled"
            end
    end
    set glyph (_transport_glyph $action $pstatus)
    # compact format to keep everything on one line
    set line (printf "%s  %-8s %20s" $glyph $verb "Player")
    notify-send -a "volctl" -r 91190 -t 1200 -u low \
        -h string:x-dunst-stack-tag:volctl \
        -h string:transient:1 \
        "$line"
end

function notify_vol --argument-names vol nsink muted
    set glyph (_vol_glyph $vol $muted)
    set line (printf "%s  %-4s %30s" $glyph "$vol%" "$nsink")
    notify-send -a "volctl" -r 91190 -t 900 -u low \
        -h int:value:$vol \
        -h string:x-dunst-stack-tag:volctl \
        -h string:transient:1 \
        "$line"
end

function notify_mute --argument-names is_input muted
    set dvce (test "$is_input" = "true"; and echo "Mic"; or echo "Speaker")
    set glyph (_vol_glyph 0 $muted)
    set state (test "$muted" = "true"; and echo "muted"; or echo "unmuted")
    set line (printf "%s  %-8s %20s" $glyph $state $dvce)
    notify-send -a "volctl" -r 91190 -t 1200 -u low \
        -h string:x-dunst-stack-tag:volctl \
        -h string:transient:1 \
        "$line"
end

# ---------- system info ----------
function get_default_sink;   echo "@DEFAULT_AUDIO_SINK@";   end
function get_default_source; echo "@DEFAULT_AUDIO_SOURCE@"; end

function get_volume --argument-names id
    wpctl get-volume $id | awk '{printf "%.0f\n",$2*100}'
end

function get_mute --argument-names id
    set third (wpctl get-volume $id | awk '{print $3}')
    test "$third" = "[MUTED]"; and echo "true"; or echo "false"
end

# ---------- actions ----------
function change_volume --argument-names action step id nsink
    set suffix "+"
    test "$action" = "d"; and set suffix "-"
    wpctl set-volume -l 1.0 $id "$step%$suffix"
    set vol (get_volume $id)
    set muted (get_mute $id)
    notify_vol $vol $nsink $muted
end

function toggle_mute --argument-names id is_input
    wpctl set-mute $id toggle
    set muted (get_mute $id)
    notify_mute $is_input $muted
end

function player_control --argument-names action
    switch $action
        case p
            playerctl play-pause >/dev/null 2>&1
            sleep 0.05
            set st (playerctl status 2>/dev/null)
            notify_player p $st
        case n
            playerctl next >/dev/null 2>&1
            notify_player n ""
        case b
            playerctl previous >/dev/null 2>&1
            notify_player b ""
    end
end

# ---------- main ----------
function volctl
    set step 5
    argparse i o p -- $argv

    if set -q _flag_i
        set id (get_default_source); set is_input true;  set nsink "Mic"
    else if set -q _flag_o
        set id (get_default_sink);   set is_input false; set nsink "Speaker"
    else if set -q _flag_p
        set device "playerctl"
    else
        print_usage; return 1
    end

    set action ""
    if test (count $argv) -ge 1
        set action $argv[1]
    end
    test -z "$action"; and begin; print_usage; return 1; end

    if test (count $argv) -ge 2
        set step $argv[2]
    end

    if test "$device" = "playerctl"
        player_control $action
    else
        switch $action
            case i d
                change_volume $action $step $id $nsink
            case m
                toggle_mute $id $is_input
            case '*'
                print_usage; return 1
        end
    end
end
