function randwall --description 'Random wallpaper via swww'
    set -l WALL_DIR "$argv[1]"
    test -z "$WALL_DIR"; and set WALL_DIR "$HOME/Pictures/wallpapers"

    if not pgrep -u (id -u) -x swww-daemon >/dev/null
        swww init
        sleep 0.4
    end

    set -l img (find "$WALL_DIR" -type f \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.webp' \) \
        -print0 | shuf -z -n1 | string split0)

    if test -z "$img"
        echo "randwall: no images found in $WALL_DIR"
        return 1
    end

    swww img "$img" \
        --transition-type any \
        --transition-step 60 \
        --transition-fps 120 \
        --invert-y \
        --resize crop

    # for out in (swww query | string match -r '^\w[\w-]*' | sort -u)
    #     set -l oimg (find "$WALL_DIR" -type f \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.webp' \) \
    #         -print0 | shuf -z -n1 | string split0)
    #     swww img "$oimg" -o "$out" \
    #         --transition-type any --transition-step 60 --transition-fps 120 --invert-y --resize crop
    # end
end
