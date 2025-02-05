#!/usr/bin/env zsh

# ───────────────────────────────────────────
# 🌐  Startup Configuration
# ───────────────────────────────────────────
if uwsm check may-start; then
    exec uwsm start hyprland.desktop
fi

# ───────────────────────────────────────────
# ⚡️ Powerlevel10k Theme & Zsh Setup
# ───────────────────────────────────────────
ZSH=~/.oh-my-zsh/
ZSH_THEME="powerlevel10k/powerlevel10k"

[[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]] && \
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"

[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh
typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet  # Suppress warnings

# ───────────────────────────────────────────
# 🛠  Plugins
# ───────────────────────────────────────────
plugins=(git sudo zsh-256color zsh-autosuggestions zsh-syntax-highlighting)
source $ZSH/oh-my-zsh.sh

# ───────────────────────────────────────────
# 🌍  Environment Variables
# ───────────────────────────────────────────
export PATH=$HOME/go/bin:$JAVA_HOME/bin:$PATH
export EDITOR=nvim
export XDG_DATA_DIRS=$XDG_DATA_DIRS:/var/lib/flatpak/exports/share:~/.local/share/flatpak/exports/share

# Set open file descriptor limit
ulimit -n 4096

# ───────────────────────────────────────────
# 🚀  Package Management
# ───────────────────────────────────────────
if pacman -Qi yay &>/dev/null; then
   aurhelper="yay"
elif pacman -Qi paru &>/dev/null; then
   aurhelper="paru"
fi

# Install packages (from Arch or AUR)
function in {
    local -a inPkg=("$@")
    local -a arch=() aur=()

    for pkg in "${inPkg[@]}"; do
        if pacman -Si "${pkg}" &>/dev/null; then
            arch+=("${pkg}")
        else
            aur+=("${pkg}")
        fi
    done

    (( ${#arch[@]} )) && sudo pacman -S "${arch[@]}"
    (( ${#aur[@]} )) && ${aurhelper} -S "${aur[@]}"
}

# ───────────────────────────────────────────
# 📂  Directory Navigation Shortcuts
# ───────────────────────────────────────────
eval "$(zoxide init zsh --cmd cd)"
alias ..='cd ..'
alias ...='cd ../..'
alias .3='cd ../../..'
alias .4='cd ../../../..'
alias .5='cd ../../../../..'
alias mkdir='mkdir -p'

# ───────────────────────────────────────────
# 🔄  Package Management Aliases
# ───────────────────────────────────────────
alias pr='$aurhelper -Rns'     # Remove package and unneeded dependencies
alias ps='$aurhelper -Syu'     # System update
alias pl='$aurhelper -Qs'      # Search installed packages
alias lr='$aurhelper -Ss'      # Search available packages
alias ca='$aurhelper -Sc'      # Clean package cache
alias cu='$aurhelper -Qtdq | $aurhelper -Rns -'  # Remove orphaned packages

# ───────────────────────────────────────────
# 🖥  Neovide
# ───────────────────────────────────────────
alias nvid="~/.config/nvim/scripts/nvid_launcher.sh"

# ───────────────────────────────────────────
# 🛠  Command Not Found Handler
# ───────────────────────────────────────────
function command_not_found_handler {
    local purple='\e[1;35m' bright='\e[0;1m' green='\e[1;32m' reset='\e[0m'
    printf 'zsh: command not found: %s\n' "$1"
    
    local entries=( ${(f)"$(/usr/bin/pacman -F --machinereadable -- "/usr/bin/$1")"} )
    if (( ${#entries[@]} )) ; then
        printf "${bright}$1${reset} may be found in the following packages:\n"
        local pkg
        for entry in "${entries[@]}" ; do
            local fields=( ${(0)entry} )
            if [[ "$pkg" != "${fields[2]}" ]]; then
                printf "${purple}%s/${bright}%s ${green}%s${reset}\n" "${fields[1]}" "${fields[2]}" "${fields[3]}"
            fi
            printf '    /%s\n' "${fields[4]}"
            pkg="${fields[2]}"
        done
    fi
    return 127
}

# ───────────────────────────────────────────
# 📂  SuperFile Function (spf)
# ───────────────────────────────────────────
spf() {
    export SPF_LAST_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/superfile/lastdir"
    command spf "$@"
    [ -f "$SPF_LAST_DIR" ] && { 
        . "$SPF_LAST_DIR"
        rm -f -- "$SPF_LAST_DIR" > /dev/null
    }
}

# ───────────────────────────────────────────
# 🍺  Homebrew Initialization
# ───────────────────────────────────────────
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# ───────────────────────────────────────────
# 🧹  Miscellaneous Aliases
# ───────────────────────────────────────────
alias c='clear'
alias ls='eza -1 --icons=auto'
alias lsa='eza -lha --icons=auto --sort=name --group-directories-first'
alias lst='eza --icons=auto --tree'
