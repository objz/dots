#!/bin/bash

set -e  # Exit on errors
set -u  # Treat unset variables as errors

# Variables
REPO_URL="https://github.com/72-S/dots.git"  # Replace with your GitHub repository URL
CLONE_DIR="/tmp/dots"
PKG_LIST="$CLONE_DIR/pkglist.txt"
PARU_REPO="https://aur.archlinux.org/paru.git"

# Step 1: Clone the GitHub repository
echo "Cloning repository..."
git clone "$REPO_URL" "$CLONE_DIR"

# Step 2: Copy dotfiles and configs to the home directory
echo "Copying dotfiles and configs to the home directory..."
cp -r "$CLONE_DIR/home/.config" ~/
cp -r "$CLONE_DIR/home/."* ~/

# Step 3: Clone and install paru
if ! command -v paru &>/dev/null; then
    echo "paru is not installed. Cloning and installing paru..."
    git clone "$PARU_REPO" /tmp/paru
    cd /tmp/paru
    makepkg -si --noconfirm
    cd "$CLONE_DIR"  # Return to cloned repository directory
else
    echo "paru is already installed. Skipping paru installation."
fi

# Step 4: Install packages from pkglist.txt
if [ -f "$PKG_LIST" ]; then
    echo "Installing packages from pkglist.txt..."
    paru -S --needed --noconfirm - < "$PKG_LIST"
else
    echo "Error: Package list ($PKG_LIST) not found."
    exit 1
fi

# Step 5: Set the default shell to zsh
echo "Setting zsh as the default shell..."
if [ "$(basename "$SHELL")" != "zsh" ]; then
    chsh -s "$(which zsh)"
    echo "Shell changed to zsh. It will take effect after reboot."
else
    echo "zsh is already the default shell."
fi

# Step 6: Reboot
echo "Installation completed. Rebooting system in 10 seconds..."
echo "You need to install oh-my-zsh after reboot manually!"
sleep 10
sudo reboot
