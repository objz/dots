#!/usr/bin/env fish

argparse -n 'install.fish' -X 0 \
    'h/help' \
    'noconfirm' \
    'opt' \
    -- $argv
or exit

# Print help
if set -q _flag_h
    echo 'usage: ./install.sh [-h] [--noconfirm] [--opt]'
    echo
    echo 'options:'
    echo '  -h, --help                  show this help message and exit'
    echo '  --noconfirm                 do not confirm package installation'
    echo '  --opt                       install optional packages (e.g. Discord)'
    exit
end

function _out -a colour text
    set_color $colour
    echo $argv[3..] -- ":: $text"
    set_color normal
end

function log -a text
    _out cyan $text $argv[2..]
end

function input -a text
    _out blue $text $argv[2..]
end

function confirm-overwrite -a path
    if test -e $path -o -L $path
        if set -q noconfirm
            input "$path already exists. Overwrite? [Y/n]"
            log 'Removing...'
            rm -rf $path
        else
            read -l -p "input '$path already exists. Overwrite? [Y/n] ' -n" confirm || exit 1
            if test "$confirm" = 'n' -o "$confirm" = 'N'
                log 'Skipping...'
                return 1
            else
                log 'Removing...'
                rm -rf $path
            end
        end
    end
    return 0
end

# Variables
set -q _flag_noconfirm && set noconfirm '--noconfirm'
set -l aur_helper paru
set -q XDG_CONFIG_HOME && set -l config $XDG_CONFIG_HOME || set -l config $HOME/.config
set -q XDG_STATE_HOME && set -l state $XDG_STATE_HOME || set -l state $HOME/.local/state

# Startup prompt
set_color magenta
echo '╭──────────────────────╮'
echo '│        _     _       │'
echo '│   ___ | |__ (_)____  │'
echo '│  / _ \| |_ \| |_  /  │'
echo '│ | (_) | |_) | |/ /   │'
echo '│  \___/|_.__// /___|  │'
echo '│           |__/       │'
echo '│      		     │'
echo '╰──────────────────────╯'
set_color normal
log 'Before continuing, please ensure you have made a backup of your config directory.'

# Prompt for backup
if ! set -q _flag_noconfirm
    log '[1] Two steps ahead of you!  [2] Make one for me please!'
    read -l -p "input '=> ' -n" choice || exit 1

    if contains -- "$choice" 1 2
        if test $choice = 2
            log "Backing up $config..."

            if test -e $config.bak -o -L $config.bak
                read -l -p "input 'Backup already exists. Overwrite? [Y/n] ' -n" overwrite || exit 1
                if test "$overwrite" = 'n' -o "$overwrite" = 'N'
                    log 'Skipping...'
                else
                    rm -rf $config.bak
                    cp -r $config $config.bak
                end
            else
                cp -r $config $config.bak
            end
        end
    else
        log 'No choice selected. Exiting...'
        exit 1
    end
end

# Install paru if not already installed
if ! pacman -Q $aur_helper &> /dev/null
    log "$aur_helper not installed. Installing..."

    sudo pacman -S --needed git base-devel $noconfirm
    cd /tmp
    git clone https://aur.archlinux.org/$aur_helper.git
    cd $aur_helper
    makepkg -si
    cd ..
    rm -rf $aur_helper

    $aur_helper -Y --gendb
    $aur_helper -Y --devel --save
end

# Cd into dir
cd (dirname (status filename)) || exit 1

# somewhere here I do pre commands
# like pkgfile for example
#

# Install packages
log 'Installing packages...'
$aur_helper -S --needed - < packages.txt $noconfirm


# Enable services
log 'Generating pkgfile database...'
sudo pkgfile --update
sudo systemctl enable --now pkgfile-update.timer



# Starship
if confirm-overwrite $config/starship.toml
    log 'Installing starship config...'
    ln -s (realpath starship.toml) $config/starship.toml
end

# Fish
if confirm-overwrite $config/fish
    log 'Installing fish config...'
    ln -s (realpath fish) $config/fish
end

# Optional installs
if set -q _flag_opt
    log 'Installing optional software...'

    log 'Installing Discord...'
    $aur_helper -S --needed discord equicord-installer-bin $noconfirm

    sudo Equilotl -install -location /opt/discord
    sudo Equilotl -install-openasar -location /opt/discord

    $aur_helper -Rns equicord-installer-bin $noconfirm
end

log 'Done!'
