I’m on **niri** now. the old hyprland setup is still there on the `hyprland` branch.

the `install.fish` script is for arch-based systems. you need `fish`, `git`, `sudo`. it installs `paru` itself if missing.

### flags

* `--noconfirm` → pass `--noconfirm` to pacman/paru and auto-overwrite configs
* `--opt` → install extras (discord, packages from `pkgopt.txt`)
* `--nvidia` → install open dkms stack + enable `nvidia-persistenced` and drop a vram profile json
* `-h` → help

### what it does

* installs from `pkglist.txt` if present
* installs core stuff for niri: `dunst`, `xdg-desktop-portal*`, `gnome-keyring`, `polkit-gnome`, `xwayland-satellite`
* optional extras with `--opt`
* nvidia stack + profile fix with `--nvidia`
* sets gtk filechooser portal pref, sets gnome color-scheme dark, enables services (`dunst`, `xwayland-satellite`, `ly`)
* symlinks configs from repo into `$XDG_CONFIG_HOME` (`starship`, `fish`, `fuzzel`, `ghostty`, `niri`, `superfile`, `nvim`, `dunst`, `btop`)
* firefox: copies `userChrome.css` into default profile if found

### usage

```bash
fish ./install.fish
fish ./install.fish --noconfirm
fish ./install.fish --opt --nvidia
```

that’s it. hyprland branch if you want the old setup.
