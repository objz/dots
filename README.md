# Minimal Hyprland Setup

This repository contains my minimal Hyprland setup along with an installation script to automate the configuration and installation process. It includes essential dotfiles, configurations, and a list of packages to set up a fully functional Hyprland-based system.

## Features
- **Hyprland Configuration**: Minimal and clean setup for Hyprland.
- **Automated Installation**:
  - Installs all required packages from `pkglist.txt` using `paru`.
  - Sets up dotfiles and configurations (`.config`, `.zshrc`, etc.).
  - Sets `zsh` as the default shell.
  - Reboots the system after installation.

## Directory Structure
```
repository/
├── home/
│   ├── .config/        # Hyprland and other configurations
│   ├── .oh-my-zsh/     # ZSH customizations
│   ├── .p10k.zsh       # Powerlevel10k configuration
│   ├── .zshrc          # ZSH shell configuration
│   ├── neovide.sh      # Custom Neovide script
├── pkglist.txt          # List of packages to install (Hyprland, Wayland, etc.)
├── install.sh           # Installation script
```

## Installation
```bash
curl -sL https://raw.githubusercontent.com/72-S/dots/main/install.sh | bash
```

## Requirements
- **Linux distribution**: Arch Linux or an Arch-based system.
- **Hyprland compatibility**: Ensure your system supports Wayland and Hyprland.
- **Sudo privileges**: Required for installing system packages and setting up configurations.


## Notes
- This setup is designed for a minimal, lightweight Hyprland environment.
- This setup is for nvidia only!
