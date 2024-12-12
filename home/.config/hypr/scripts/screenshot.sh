#!/usr/bin/env sh

# Restores the shader after a screenshot has been taken
restore_shader() {
	if [ -n "$shader" ]; then
		hyprshade on "$shader"
	fi
}

# Saves the current shader and turns it off
save_shader() {
	shader=$(hyprshade current)
	hyprshade off
	trap restore_shader EXIT
}

save_shader # Saving the current shader

# Default directories if XDG variables are not set
XDG_PICTURES_DIR="${XDG_PICTURES_DIR:-$HOME/Pictures}"

# Define directories and paths
confDir="$HOME/.config"  # Replace this with the directory your configuration files are stored in
swpy_dir="${confDir}/swappy"
save_dir="${2:-$XDG_PICTURES_DIR/Screenshots}"
save_file=$(date +'%y%m%d_%Hh%Mm%Ss_screenshot.png')
temp_screenshot="/tmp/screenshot.png"

# Ensure directories exist
mkdir -p "$save_dir"
mkdir -p "$swpy_dir"

# Write the configuration for swappy
cat <<EOF >"$swpy_dir/config"
[Default]
save_dir=$save_dir
save_filename_format=$save_file
EOF

# Error message for invalid actions
print_error() {
	cat <<"EOF"
    ./screenshot.sh <action>
    ...valid actions are...
        p  : print all screens
        s  : snip current screen
        sf : snip current screen (frozen)
        m  : print focused monitor
EOF
}

# Case statement for different actions
case $1 in
p) # Print all outputs
	grimblast copysave screen "$temp_screenshot" && restore_shader && swappy -f "$temp_screenshot" ;;
s) # Drag to manually snip an area / click on a window to print it
	grimblast copysave area "$temp_screenshot" && restore_shader && swappy -f "$temp_screenshot" ;;
sf) # Frozen screen, drag to manually snip an area / click on a window to print it
	grimblast --freeze copysave area "$temp_screenshot" && restore_shader && swappy -f "$temp_screenshot" ;;
m) # Print focused monitor
	grimblast copysave output "$temp_screenshot" && restore_shader && swappy -f "$temp_screenshot" ;;
*) # Invalid option
	print_error ;;
esac

# Cleanup temporary screenshot
rm "$temp_screenshot"

# Notify the user if a screenshot was saved
if [ -f "${save_dir}/${save_file}" ]; then
	notify-send -a "t1" -i "${save_dir}/${save_file}" "Saved in ${save_dir}"
fi
