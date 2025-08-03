#!/bin/sh

set -euo pipefail

# Defaults
DEFAULT_CLONE_DIR="$HOME/dots"
REPO_URL="https://github.com/objz/dots.git"
CLONE_DIR=""
PKG_LIST=""
PARU_REPO="https://aur.archlinux.org/paru.git"
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
FORCE_INSTALL=false

show_help() {
    cat << EOF
Usage: $0 [OPTIONS]

OPTIONS:
    -f, --force             Force reinstall / reapply even if already present
    -d, --target-dir PATH   Clone dots repo into PATH instead of default
    -h, --help              Show this help message

EOF
}

parse_args() {
    while [ $# -gt 0 ]; do
        case $1 in
            -f|--force)
                FORCE_INSTALL=true
                shift
                ;;
            -d|--target-dir)
                if [ $# -lt 2 ]; then
                    echo "Error: --target-dir requires an argument."
                    exit 1
                fi
                CLONE_DIR="$2"
                shift 2
                ;;
            --target-dir=*)
                CLONE_DIR="${1#*=}"
                shift
                ;;
            -h|--help)
                show_help
                exit 0
                ;;
            *)
                echo "Unknown option: $1"
                show_help
                exit 1
                ;;
        esac
    done
}

print_message() {
    printf "\n\033[1;32m%s\033[0m\n" "$1"
}


choose_clone_location() {
    if [ -n "$CLONE_DIR" ]; then
        :  # provided via CLI
    else
        CLONE_DIR="$DEFAULT_CLONE_DIR"
    fi

    CLONE_DIR="${CLONE_DIR%/}"
    PKG_LIST="$CLONE_DIR/pkglist.txt"
}


clone_repository() {
    print_message "Cloning repository into '$CLONE_DIR'..."
    if [ -d "$CLONE_DIR" ]; then
        if [ "$FORCE_INSTALL" = true ]; then
            echo "Force mode: Removing existing repository at $CLONE_DIR..."
            rm -rf "$CLONE_DIR"
        else
            echo "Repository already exists at $CLONE_DIR. Skipping clone. Use -f to force re-clone."
            return 0
        fi
    fi
    git clone "$REPO_URL" "$CLONE_DIR"
    echo "Repository cloned successfully."
}

install_paru() {
    print_message "Checking for paru installation..."
    if command -v paru >/dev/null 2>&1 && [ "$FORCE_INSTALL" = false ]; then
        echo "paru is already installed. Skipping."
        return 0
    fi

    echo "Installing paru..."
    if [ -d "/tmp/paru" ]; then
        rm -rf /tmp/paru
    fi
    git clone "$PARU_REPO" /tmp/paru
    cd /tmp/paru
    makepkg -si --noconfirm
    echo "paru installed successfully."
}

install_packages() {
    print_message "Installing packages from pkglist.txt..."
    if [ ! -f "$PKG_LIST" ]; then
        echo "Error: Package list ($PKG_LIST) not found."
        exit 1
    fi

    if ! command -v paru >/dev/null 2>&1; then
        echo "paru not found; attempting to install paru first."
        install_paru
    fi

    paru -S --needed --noconfirm - < "$PKG_LIST"
    echo "Packages installed successfully."

    if ! command -v stow >/dev/null 2>&1; then
        echo "stow not found; installing stow explicitly."
        paru -S --needed --noconfirm stow
    fi
}

install_homebrew() {
    print_message "Installing Homebrew..."
    if command -v brew >/dev/null 2>&1 && [ "$FORCE_INSTALL" = false ]; then
        echo "Homebrew is already installed. Skipping."
        return 0
    fi

    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    echo "Homebrew installed successfully."
}

install_oh_my_zsh() {
    print_message "Installing Oh My Zsh..."
    if [ -d "$HOME/.oh-my-zsh" ] && [ "$FORCE_INSTALL" = false ]; then
        echo "Oh My Zsh is already installed. Skipping."
        return 0
    fi

    if [ "$FORCE_INSTALL" = true ] && [ -d "$HOME/.oh-my-zsh" ]; then
        echo "Force mode: Removing existing Oh My Zsh..."
        rm -rf "$HOME/.oh-my-zsh"
    fi

    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    echo "Oh My Zsh installed successfully."
}

install_zsh_plugins() {
    print_message "Installing Zsh plugins and theme..."

    install_plugin() {
        local name="$1"
        local repo="$2"
        local path="$3"
        local extra_args="${4:-}"

        if [ -d "$path" ] && [ "$FORCE_INSTALL" = false ]; then
            echo "$name already installed. Skipping."
            return 0
        fi

        if [ "$FORCE_INSTALL" = true ] && [ -d "$path" ]; then
            rm -rf "$path"
        fi

        git clone $extra_args "$repo" "$path"
        echo "$name installed."
    }

    mkdir -p "$ZSH_CUSTOM/plugins" "$ZSH_CUSTOM/themes"

    install_plugin "zsh-256color" "https://github.com/chrissicool/zsh-256color.git" "$ZSH_CUSTOM/plugins/zsh-256color"
    install_plugin "zsh-autosuggestions" "https://github.com/zsh-users/zsh-autosuggestions.git" "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
    install_plugin "zsh-syntax-highlighting" "https://github.com/zsh-users/zsh-syntax-highlighting.git" "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
    install_plugin "powerlevel10k" "https://github.com/romkatv/powerlevel10k.git" "$ZSH_CUSTOM/themes/powerlevel10k" "--depth=1"

    echo "Zsh plugins and theme installed successfully."
}


stow_dotfiles() {
    print_message "Applying dotfiles with GNU stow..."

    if [ ! -d "$CLONE_DIR" ]; then
        echo "Warning: Clone directory not present."
        return 0
    fi

    if ! command -v stow >/dev/null 2>&1; then
        echo "stow is required but not found. Aborting."
        exit 1
    fi

    cd "$CLONE_DIR"
    for file in .[^.]*; do
        [ "$file" = "." ] && continue
        [ "$file" = ".." ] && continue
        [ ! -f "$file" ] && continue  

        pkg="$file"  

        TEMP_STOW_DIR="/tmp/stow-single-$pkg"
        rm -rf "$TEMP_STOW_DIR"
        mkdir -p "$TEMP_STOW_DIR/$pkg"
        cp "$file" "$TEMP_STOW_DIR/$pkg/"

        pushd "$TEMP_STOW_DIR" >/dev/null
        if [ "$FORCE_INSTALL" = true ]; then
            stow -vD --target="$HOME" "$pkg" 2>/dev/null || true
        fi
        stow -v --target="$HOME" "$pkg"
        popd >/dev/null

        rm -rf "$TEMP_STOW_DIR"
    done

    if [ -d "$CLONE_DIR/.config" ]; then
        cd "$CLONE_DIR/.config"
        mkdir -p "$HOME/.config"
        for pkg in * .[^.]*; do
            [ "$pkg" = "." ] && continue
            [ "$pkg" = ".." ] && continue
            [ ! -e "$pkg" ] && continue

            if [ "$FORCE_INSTALL" = true ]; then
                stow -vD --target="$HOME/.config" "$pkg" 2>/dev/null || true
            fi
            stow -v --target="$HOME/.config" "$pkg"
        done
    fi

    echo "Dotfiles applied via stow."
}


set_default_shell() {
    print_message "Setting zsh as default shell..."

    ZSH_PATH=$(which zsh)
    if [ -z "$ZSH_PATH" ]; then
        echo "zsh not found in PATH. Aborting."
        exit 1
    fi

    CURRENT_SHELL=$(getent passwd "$USER" | cut -d: -f7)

    if [ "$CURRENT_SHELL" = "$ZSH_PATH" ] && [ "$FORCE_INSTALL" = false ]; then
        echo "zsh is already the default shell."
        return 0
    fi

    if ! grep -q "^$ZSH_PATH$" /etc/shells; then
        echo "Adding zsh to /etc/shells..."
        echo "$ZSH_PATH" | sudo tee -a /etc/shells >/dev/null
    fi

    echo "Changing shell to zsh..."
    sudo chsh -s "$ZSH_PATH" "$USER"
    echo "Shell changed to zsh. Changes will take effect after logout/login."
}

reboot_system() {
    print_message "Installation completed successfully!"
    echo "Reboot recommended for all changes to take effect."
    printf "Press 'y' to reboot now, or any other key to skip: "
    read -r response
    case "$response" in
        [yY]|[yY][eE][sS])
            echo "Rebooting..."
            sudo reboot
            ;;
        *)
            echo "Reboot skipped. Please reboot manually."
            ;;
    esac
}

main() {
    parse_args "$@"
    choose_clone_location

    clone_repository
    install_paru
    install_packages
    install_homebrew
    install_oh_my_zsh
    install_zsh_plugins
    stow_dotfiles
    set_default_shell
    reboot_system
}

main "$@"
