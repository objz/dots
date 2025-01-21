#!/bin/sh

set -e  # Exit on errors
set -u  # Treat unset variables as errors

# Variables
REPO_URL="https://github.com/72-S/dots.git"  # Replace with your GitHub repository URL
CLONE_DIR="/tmp/dots"
PKG_LIST="$CLONE_DIR/pkglist.txt"
PARU_REPO="https://aur.archlinux.org/paru.git"
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

# Function to print a formatted message
print_message() {
    echo -e "\n\033[1;32m$1\033[0m"
}

# Step 1: Clone the GitHub repository
print_message "Cloning repository..."
if [ -d "$CLONE_DIR" ]; then
    echo "Existing repository found at $CLONE_DIR. Removing it..."
    rm -rf "$CLONE_DIR"
fi
git clone "$REPO_URL" "$CLONE_DIR"
echo "Repository cloned successfully."

# Step 2: Clone and install paru
print_message "Checking for paru installation..."
if ! command -v paru &>/dev/null; then
    echo "paru is not installed. Cloning and installing paru..."
    if [ -d "/tmp/paru" ]; then
        echo "Existing paru directory found. Removing it..."
        rm -rf /tmp/paru
    fi
    git clone "$PARU_REPO" /tmp/paru
    cd /tmp/paru
    makepkg -si --noconfirm
    echo "paru installed successfully."
else
    echo "paru is already installed. Skipping paru installation."
fi

# Step 3: Install packages from pkglist.txt
print_message "Installing packages from pkglist.txt..."
if [ -f "$PKG_LIST" ]; then
    paru -S --needed --noconfirm - < "$PKG_LIST"
    echo "Packages installed successfully."
else
    echo "Error: Package list ($PKG_LIST) not found. Skipping package installation."
    exit 1
fi

# Step 4: Install Homebrew
print_message "Installing Homebrew..."
if ! command -v brew &>/dev/null; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    echo "Homebrew installed successfully."
else
    echo "Homebrew is already installed. Skipping Homebrew installation."
fi

# Step 5: Install Oh My Zsh
print_message "Installing Oh My Zsh..."
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    echo "Oh My Zsh installed successfully."
else
    echo "Oh My Zsh is already installed. Skipping Oh My Zsh installation."
fi

# Step 6: Install Zsh Plugins and Theme
print_message "Installing Zsh plugins and theme..."

# zsh-256color
git clone https://github.com/chrissicool/zsh-256color.git "$ZSH_CUSTOM/plugins/zsh-256color"

# zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-autosuggestions.git "$ZSH_CUSTOM/plugins/zsh-autosuggestions"

# zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"

# powerlevel10k theme
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$ZSH_CUSTOM/themes/powerlevel10k"

echo "Zsh plugins and theme installed successfully."

# Step 7: Copy dotfiles and other scripts to the home directory
print_message "Copying dotfiles and configurations to the home directory..."

# Use rsync to copy all content while preserving structure
rsync -avh --progress --exclude='.git/' "$CLONE_DIR/home/" "$HOME/"

echo "Dotfiles and configurations copied successfully."

# Step 8: Set the default shell to zsh
print_message "Setting zsh as the default shell..."
CURRENT_SHELL=$(basename "$SHELL")
if [ "$CURRENT_SHELL" != "zsh" ]; then
    chsh -s "$(which zsh)"
    echo "Shell changed to zsh. It will take effect after a re-login."
else
    echo "zsh is already the default shell."
fi

# Step 9: Reboot (optional)
print_message "Installation completed successfully!"
echo "The system will reboot in 10 seconds. Press Ctrl+C to cancel if you want to reboot later."
sleep 10
sudo reboot
