# Minimal Hyprland Setup

This repository contains my minimal Hyprland setup along with an installation script to automate the configuration and installation process. 

## Directory Structure
```
repository/
├── home/
│   ├── .config/        # Hyprland and other configurations
│   ├── .p10k.zsh       # Powerlevel10k configuration
│   ├── .zshrc          # ZSH shell configuration
├── pkglist.txt          # List of packages to install (Hyprland, Wayland, etc.)
├── install.sh           # Installation script
```

## Installation
```bash
curl -sL https://raw.githubusercontent.com/72-S/dots/main/install.sh | sh
```

## Requirements
- **Linux distribution**: Arch Linux or an Arch-based system.
- **Hyprland compatibility**: Ensure your system supports Wayland and Hyprland.
- **Sudo privileges**: Required for installing system packages and setting up configurations.


## Notes
- This setup is designed for a minimal, lightweight Hyprland environment.
- For nvidia install the packages `lib32-nvidia-utils`, `nvidia-open-dkms` and `nvidia-utils`
