#!/usr/bin/env fish

argparse -n 'install.fish' -X 0 \
    'h/help' \
    'noconfirm' \
    'opt' \
    'nvidia' \
    'update' \
    'install' \
    -- $argv
or exit 2

function show_help
    echo 'usage: fish ./install.fish [--install|--update] [--noconfirm] [--opt] [--nvidia]'
    echo
    echo 'modes:'
    echo '  --install                  fresh install (default)'
    echo '  --update                   update packages, configs, and submodules'
    echo
    echo 'options:'
    echo '  -h, --help                 show this help message and exit'
    echo '  --noconfirm                do not confirm package installation or overwrites'
    echo '  --opt                      install optional packages (e.g. Discord)'
    echo '  --nvidia                   install NVIDIA (open dkms) + apply VRAM profile fix'
end

function log
    set_color cyan
    echo ":: $argv"
    set_color normal
end

function warn
    set_color yellow
    echo "!! $argv"
    set_color normal
end

function die
    set_color red
    echo "error: $argv"
    set_color normal
    exit 1
end

function section -a title
    set_color magenta
    echo
    echo "== $title =="
    set_color normal
end

function as_root
    if test (id -u) -eq 0
        $argv
    else
        command sudo $argv
    end
end

function run -a desc
    set -l cmd $argv[2..]
    if test -n "$desc"
        log $desc
    end
    $cmd
    or die "Failed: $desc"
end

function try_run -a desc
    set -l cmd $argv[2..]
    if test -n "$desc"
        log $desc
    end
    $cmd
    if test $status -ne 0
        warn "Failed (continuing): $desc"
        return 1
    end
    return 0
end

function confirm -a prompt default_answer
    set -l suffix '[Y/n]'
    if test "$default_answer" = 'no'
        set suffix '[y/N]'
    end

    while true
        read -l -P "$prompt $suffix " reply
        if test -z "$reply"
            if test "$default_answer" = 'no'
                return 1
            end
            return 0
        end

        switch (string lower -- $reply)
            case y yes
                return 0
            case n no
                return 1
        end
    end
end

function resolve_path -a path
    if type -q realpath
        realpath "$path"
    else if type -q readlink
        readlink -f "$path"
    else
        echo "$path"
    end
end

function remove_path -a target
    if test -z "$target"
        die 'Refusing to remove empty path'
    end
    rm -rf -- "$target"
end

function confirm_overwrite -a target
    if test -e "$target" -o -L "$target"
        if test "$auto_overwrite" = '1'
            log "$target exists. Overwriting (auto)."
            remove_path "$target"
            return 0
        end

        if confirm "$target exists. Overwrite?" yes
            remove_path "$target"
            return 0
        else
            log "Skipping $target"
            return 1
        end
    end
    return 0
end

function link_config -a source target
    if not test -e "$source"
        warn "Missing $source. Skipping."
        return 0
    end

    set -l resolved_source (resolve_path "$source")

    if test -L "$target"; and type -q readlink
        set -l current (readlink "$target")
        if test "$current" = "$resolved_source"
            log "$target already linked"
            return 0
        end
    end

    mkdir -p (dirname "$target")

    if confirm_overwrite "$target"
        ln -s "$resolved_source" "$target"
        log "Linked $target"
    end
end

function maybe_backup_config -a config_dir
    log 'Before continuing, consider backing up your config directory.'
    if test "$auto_overwrite" = '1'
        return 0
    end

    if not confirm "Create backup at $config_dir.bak?" yes
        return 0
    end

    if not test -d "$config_dir"
        warn "Config directory $config_dir not found. Skipping backup."
        return 0
    end

    set -l do_backup 1
    if test -e "$config_dir.bak"
        if confirm "Backup exists at $config_dir.bak. Overwrite?" no
            remove_path "$config_dir.bak"
        else
            log 'Skipping backup.'
            set do_backup 0
        end
    end

    if test $do_backup -eq 1
        run "Backing up $config_dir" cp -a "$config_dir" "$config_dir.bak"
    end
end

function require_cmd -a cmd
    type -q $cmd
    or die "Missing required command: $cmd"
end

function systemd_unit_exists -a scope unit
    switch $scope
        case user
            set -l dirs /etc/systemd/user /usr/lib/systemd/user ~/.config/systemd/user
        case system
            set -l dirs /etc/systemd/system /usr/lib/systemd/system
        case '*'
            return 1
    end

    for dir in $dirs
        if test -e "$dir/$unit"
            return 0
        end
    end
    return 1
end

if set -q _flag_h
    show_help
    exit 0
end

if set -q _flag_install; and set -q _flag_update
    die 'Choose either --install or --update'
end

set -l mode install
if set -q _flag_update
    set mode update
end

set -g auto_overwrite 0
if set -q _flag_noconfirm
    set auto_overwrite 1
end

set -l pacman_confirm_flags
set -l aur_confirm_flags
set -l makepkg_flags -si
if set -q _flag_noconfirm
    set pacman_confirm_flags --noconfirm
    set aur_confirm_flags --noconfirm
    set makepkg_flags $makepkg_flags --noconfirm
end

set -l script_dir (dirname (status filename))
set -l repo_dir (resolve_path "$script_dir")
cd "$repo_dir"; or die "Failed to enter $repo_dir"

set -l config_dir $HOME/.config
if set -q XDG_CONFIG_HOME
    set config_dir $XDG_CONFIG_HOME
end

set -l aur_helper paru
if set -q AUR_HELPER
    set aur_helper $AUR_HELPER
end

set -l pkglist "$repo_dir/pkglist.txt"
set -l pkgopt "$repo_dir/pkgopt.txt"

set_color magenta
echo ' ░▒▓██████▓▒░░▒▓███████▓▒░       ░▒▓█▓▒░▒▓████████▓▒░      '
echo '░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░      ░▒▓█▓▒░      ░▒▓█▓▒░      '
echo '░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░      ░▒▓█▓▒░    ░▒▓██▓▒░       '
echo '░▒▓█▓▒░░▒▓█▓▒░▒▓███████▓▒░       ░▒▓█▓▒░  ░▒▓██▓▒░         '
echo '░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░░▒▓██▓▒░           '
echo '░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░             '
echo ' ░▒▓██████▓▒░░▒▓███████▓▒░ ░▒▓██████▓▒░░▒▓████████▓▒░      '
set_color normal
log "Mode: $mode"

section 'Preflight'
require_cmd git
require_cmd pacman
if test (id -u) -ne 0
    require_cmd sudo
end

if test "$mode" = 'install'
    maybe_backup_config "$config_dir"
end

section 'Repository'
if git rev-parse --is-inside-work-tree >/dev/null 2>&1
    if test -f "$repo_dir/.gitmodules"
        run 'Syncing submodules' git submodule sync --recursive
        run 'Initializing/updating submodules' git submodule update --init --recursive
    else
        log 'No .gitmodules found, skipping submodules.'
    end
else
    warn 'Not a git worktree; skipping submodules.'
end

section 'Packages'
if not pacman -Q $aur_helper >/dev/null 2>&1
    log "$aur_helper not installed. Installing..."
    run "Installing build dependencies" as_root pacman -S --needed git base-devel $pacman_confirm_flags

    set -g tmp_dir (mktemp -d)
    run "Cloning $aur_helper" git clone "https://aur.archlinux.org/$aur_helper.git" "$tmp_dir/$aur_helper"
    cd "$tmp_dir/$aur_helper"; or die "Failed to enter $tmp_dir/$aur_helper"
    run "Building and installing $aur_helper" makepkg $makepkg_flags
    cd "$repo_dir"; or die "Failed to return to $repo_dir"
    remove_path "$tmp_dir"

    run "Configuring $aur_helper metadata" $aur_helper -Y --gendb
    run "Enabling devel tracking" $aur_helper -Y --devel --save
end

if test "$mode" = 'update'
    run 'Updating system packages' $aur_helper -Syu --needed $aur_confirm_flags
end

run 'Installing pkgfile' as_root pacman -S --needed pkgfile $pacman_confirm_flags

if test -f "$pkglist"
    run 'Installing packages from pkglist.txt' $aur_helper -S --needed - $aur_confirm_flags < "$pkglist"
else
    log 'pkglist.txt not found. Skipping.'
end

log 'Installing Niri essentials (packages only)...'
$aur_helper -S --needed dunst $aur_confirm_flags; or die 'Failed to install dunst'
$aur_helper -S --needed xdg-desktop-portal xdg-desktop-portal-gtk xdg-desktop-portal-gnome gnome-keyring $aur_confirm_flags; or die 'Failed to install portals/keyring'
$aur_helper -S --needed polkit-gnome $aur_confirm_flags; or die 'Failed to install polkit-gnome'
$aur_helper -S --needed xwayland-satellite $aur_confirm_flags; or die 'Failed to install xwayland-satellite'

if set -q _flag_nvidia
    run 'Installing NVIDIA (open dkms) and userspace' as_root pacman -S --needed dkms linux-headers nvidia-open-dkms nvidia-utils lib32-nvidia-utils nvidia-settings $pacman_confirm_flags
end

if set -q _flag_opt
    log 'Installing optional software...'
    $aur_helper -S --needed discord equicord-installer-bin $aur_confirm_flags; or die 'Failed to install Discord'
    $aur_helper -Rns equicord-installer-bin $aur_confirm_flags; or die 'Failed to remove equicord-installer-bin'

    if test -f "$pkgopt"
        run 'Installing optional packages from pkgopt.txt' $aur_helper -S --needed - $aur_confirm_flags < "$pkgopt"
    else
        log 'pkgopt.txt not found. Skipping.'
    end
end

section 'Post-install config'
run 'Generating pkgfile database' as_root pkgfile --update
try_run 'Enabling pkgfile-update timer' as_root systemctl enable --now pkgfile-update.timer

set -l portals_dir "$config_dir/xdg-desktop-portal"
set -l portals_conf "$portals_dir/portals.conf"
log "Writing $portals_conf"
mkdir -p "$portals_dir"
begin
    printf '%s\n' \
        '[preferred]' \
        'org.freedesktop.impl.portal.FileChooser=gtk;' \
        > "$portals_conf"
end
or die "Failed to write $portals_conf"

if type -q dconf
    try_run 'Setting GNOME interface color-scheme to prefer-dark' dconf write /org/gnome/desktop/interface/color-scheme '"prefer-dark"'
else
    warn 'dconf not found. Skipping GNOME color-scheme.'
end

try_run 'Enabling dunst (user)' systemctl --user enable --now dunst.service
try_run 'Enabling xwayland-satellite (user)' systemctl --user enable --now xwayland-satellite.service
try_run 'Enabling vicinae (user)' systemctl --user enable --now vicinae.service
if systemd_unit_exists system ly@.service
    try_run 'Enabling ly (system, tty2)' as_root systemctl enable --now ly@tty2.service
else if systemd_unit_exists system ly@tty2.service
    try_run 'Enabling ly (system, tty2)' as_root systemctl enable --now ly@tty2.service
else
    warn 'ly@.service unit not found. Skipping.'
end

if set -q _flag_nvidia
    try_run 'Enabling nvidia-persistenced' as_root systemctl enable --now nvidia-persistenced.service

    log 'Applying NVIDIA VRAM profile fix...'
    set -l nvp_dir /etc/nvidia/nvidia-application-profiles-rc.d
    set -l nvp_file "$nvp_dir/50-limit-free-buffer-pool-in-wayland-compositors.json"
    run 'Creating NVIDIA profiles directory' as_root mkdir -p "$nvp_dir"
    begin
        printf '%s\n' \
        '{' \
        '    "rules": [' \
        '        {' \
        '            "pattern": {' \
        '                "feature": "procname",' \
        '                "matches": "niri"' \
        '            },' \
        '            "profile": "Limit Free Buffer Pool On Wayland Compositors"' \
        '        }' \
        '    ],' \
        '    "profiles": [' \
        '        {' \
        '            "name": "Limit Free Buffer Pool On Wayland Compositors",' \
        '            "settings": [' \
        '                {' \
        '                    "key": "GLVidHeapReuseRatio",' \
        '                    "value": 0' \
        '                }' \
        '            ]' \
        '        }' \
        '    ]' \
        '}' | as_root tee "$nvp_file" >/dev/null
    end
    or die "Failed to write $nvp_file"
end

section 'Dotfiles'
set -l repo_config_dir "$repo_dir/config"

if test -d "$repo_config_dir"
    set -l repo_entries $repo_config_dir/*
    if test (count $repo_entries) -eq 1; and test "$repo_entries[1]" = "$repo_config_dir/*"
        warn "No config entries found in $repo_config_dir. Skipping."
    else
        for entry in $repo_entries
            set -l name (basename "$entry")
            if test "$name" = 'firefox'
                continue
            end
            link_config "$entry" "$config_dir/$name"
        end
    end
else
    warn "Missing $repo_config_dir. Skipping."
end

set -l ff_source "$repo_config_dir/firefox/userChrome.css"
if test -e "$ff_source"
    set -l ff_profiles (ls -d ~/.mozilla/firefox/*.default-release 2>/dev/null)
    if test -n "$ff_profiles"
        set -l ff_profile $ff_profiles[1]
        set -l ff_chrome "$ff_profile/chrome"
        mkdir -p "$ff_chrome"
        link_config "$ff_source" "$ff_chrome/userChrome.css"
    else
        warn 'No Firefox default-release profile found. Skipping userChrome.css.'
    end
else
    warn "Missing $ff_source. Skipping Firefox config."
end

log 'Done.'
