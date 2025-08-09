# joshrandall's dotfiles

> [!NOTE]
> Documentation is an active WIP


> [!WARNING]
> These dotfiles are not directly developed for complete public use. They are designed for newly created users on a Linux system. If you decide to install this on an already established user, **you install them at your own risk.**

My personal dotfiles from Gentoo linux. Meant for bootstraping systems to my configuration quickly.
![My system](/assets/desktop.png)

## Dependencies
This is a rough list of dependencies an applications used in the configuration:
### DE + Applications
- KDE Plasma 6
- kitty
- Visual Studio Code

### Deps + Programs
- git
- chezmoi
- zsh
- zoxide (`cd` replacement)
- fastfetch
- eza (`ls` replacement)

## Install

The dotfiles can easily be installed using chezmoi. Once all dependencies are installed, there are a few ways to apply the configuration.

### 1. Quick init
> [!CAUTION]
> Please only use this method on a new linux user. Initializing the entire configuration may/will overwrite existing user settings with no way to undo without backups.  

The fastest way to get the configuration live with minimal setup.
```bash
# Initialize chezmoi to the dotfiles repository, and apply the configuration immediately.
chezmoi init --apply joshrandall8478

# Install the papirus icon pack to /usr/share/icons, and the poppins font to /usr/share/fonts
~/scripts/install-papirus-root.sh
~/scripts/install-poppins-root.sh
```
Installing the two assets to root will help with SDDM configuration, if you wish to use the breeze theme.

#### Quick init - chezmoi only
This will only initialize and install the chezmoi configuration:
```bash
chezmoi init --apply joshrandall8478
```
This is if you want to avoid installing the icon/fonts to root. The fonts are already packaged with the chezmoi configuration. To install the icons to KDE plasma only, run this command:
```bash
~/scripts/install-papirus-kde.sh
```

### 2. Init and modify
The safest way to apply the configuration is to initialize without applying, then either applying the entire config in the next step, or picking which parts to apply.
```bash
chezmoi init joshrandall8478
chezmoi apply
```
or
```bash
# Apply only ~/.zshrc
chezmoi apply ~/.zshrc
```

## Visual Studio Code
VS code comes with an extension list, and user settings to mimic close to what I use. To install the extensions, run the `install-vscode-extensions.sh` script:
```bash
~/scripts/install-vscode-extensions.sh
```