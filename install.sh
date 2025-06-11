#!/bin/sh

set -e
set -u

REPO_URL="https://github.com/objz/dots.git"
CLONE_DIR="/tmp/dots"
PKG_LIST="$CLONE_DIR/pkglist.txt"
PARU_REPO="https://aur.archlinux.org/paru.git"
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
FORCE_INSTALL=false

show_help() {
    cat << EOF
Usage: $0 [OPTIONS]

OPTIONS:
    -f, --force     Force reinstall even if already installed
    -h, --help      Show this help message

EOF
}

parse_args() {
    while [ $# -gt 0 ]; do
        case $1 in
            -f|--force)
                FORCE_INSTALL=true
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
    echo -e "\n\033[1;32m$1\033[0m"
}

clone_repository() {
    print_message "Cloning repository..."
    if [ -d "$CLONE_DIR" ]; then
        if [ "$FORCE_INSTALL" = true ]; then
            echo "Force mode: Removing existing repository..."
            rm -rf "$CLONE_DIR"
        else
            echo "Repository already exists. Use -f to force re-clone."
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
    paru -S --needed --noconfirm - < "$PKG_LIST"
    echo "Packages installed successfully."
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
        
        if [ -d "$path" ] && [ "$FORCE_INSTALL" = false ]; then
            echo "$name already installed. Skipping."
            return 0
        fi
        
        if [ "$FORCE_INSTALL" = true ] && [ -d "$path" ]; then
            rm -rf "$path"
        fi
        
        git clone "$repo" "$path"
        echo "$name installed."
    }
    
    mkdir -p "$ZSH_CUSTOM/plugins" "$ZSH_CUSTOM/themes"
    
    install_plugin "zsh-256color" "https://github.com/chrissicool/zsh-256color.git" "$ZSH_CUSTOM/plugins/zsh-256color"
    install_plugin "zsh-autosuggestions" "https://github.com/zsh-users/zsh-autosuggestions.git" "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
    install_plugin "zsh-syntax-highlighting" "https://github.com/zsh-users/zsh-syntax-highlighting.git" "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
    install_plugin "powerlevel10k" "https://github.com/romkatv/powerlevel10k.git" "$ZSH_CUSTOM/themes/powerlevel10k" "--depth=1"
    
    echo "Zsh plugins and theme installed successfully."
}

copy_dotfiles() {
    print_message "Copying dotfiles and configurations..."
    if [ ! -d "$CLONE_DIR/home" ]; then
        echo "Warning: No home directory found in repository."
        return 0
    fi
    
    rsync -avh --progress --exclude='.git/' "$CLONE_DIR/home/" "$HOME/"
    echo "Dotfiles copied successfully."
}

set_default_shell() {
    print_message "Setting zsh as default shell..."
    
    ZSH_PATH=$(which zsh)
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
    echo "Press 'y' to reboot now, or any other key to skip:"
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
    
    clone_repository
    install_paru
    install_packages
    install_homebrew
    install_oh_my_zsh
    install_zsh_plugins
    copy_dotfiles
    set_default_shell
    reboot_system
}

main "$@"
