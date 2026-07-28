# joshrandall's dotfiles

> [!WARNING]
> These dotfiles are not directly developed for complete public use. They are designed for newly created users on a Linux system. If you decide to install this on an already established user, **you install them at your own risk.**

My personal dotfiles for Linux/KDE Plasma and Windows. Meant for bootstraping systems to my configuration quickly.
![My system](/assets/desktop.png)

This repository uses [chezmoi](https://www.chezmoi.io) templates and conditionals (see `.chezmoiignore` and the `.tmpl` files) to keep one source of truth across platforms and machine roles:
- Linux/KDE-only configuration (shell, KDE, kitty, fish, etc.) is skipped when applying on Windows, based on `{{ .chezmoi.os }}`.
- Windows-only configuration (PowerShell profile, Spicetify under `AppData`) is skipped when applying on Linux/macOS.
- Shared configuration (nushell, Spicetify theme assets) is templated once and rendered per-OS from `.chezmoitemplates`.
- On `root` (`{{ .chezmoi.username }}`) or any machine with `jrh` in its hostname (`{{ .chezmoi.hostname }}`), only shell configuration and starship apply — KDE Plasma configuration and wallpapers are skipped, and `.bashrc`/`.zshrc`/nushell render a leaner variant (no conda/bun/fnm/spicetify-PATH, no desktop-only aliases).

### Working with templated files
Everything not listed below behaves exactly as it always has (`chezmoi add`, `chezmoi apply`, `chezmoi update`, `chezmoi diff`, `chezmoi edit`, no changes to habits).

The exception is the files that are now templates: nushell's `config.nu`/`env.nu`, the Spicetify `config-xpui.ini`s, and `.bashrc`/`.zshrc`. **Don't run a bare `chezmoi add` on these again** — `add` overwrites the source with a flattened copy of whatever's on disk, which destroys the `{{ if ... }}` conditionals (and, for nushell/Spicetify, the `{{ template ... }}` include) and turns it back into a plain static file.

To edit those specifically:
- shared nushell logic → `.chezmoitemplates/nushell_config.nu.tmpl` / `nushell_env.nu.tmpl` (the per-OS `.tmpl` files under `dot_config/`/`AppData/` are just one-line includes of these)
- shared Spicetify `config-xpui.ini` logic → `.chezmoitemplates/spicetify_config-xpui.ini.tmpl`
- `.bashrc`/`.zshrc` → edit `dot_bashrc.tmpl`/`dot_zshrc.tmpl` directly; each branches inline on `root`/`jrh`-hostname/desktop since they only ever target one path (no shared partial needed)

Then just `chezmoi apply` as usual, no special command needed to re-render. `chezmoi edit` also still works, just remember you're opening a template, not raw config. If a template ever does get flattened by an accidental `add`, `git checkout` the `.tmpl` file back from the repo and reapply — nothing destructive happens to the actual target files on disk either way.

## Dependencies
This is a rough list of dependencies an applications used in the configuration:
### DE + Applications
- KDE Plasma 6 (Linux)
- kitty (Linux)
- Visual Studio Code

### Deps + Programs
- git
- chezmoi
- zsh (Linux)
- nushell
- fastfetch
- eza, `ls` replacement (Linux)
- starship

### Windows-specific
- [nushell](https://www.nushell.sh/) and/or PowerShell
- [starship](https://starship.rs/) installed to `C:\Program Files\starship\bin\starship.exe`
- [Spicetify](https://spicetify.app/) (theme/marketplace assets applied to `%APPDATA%\spicetify`)

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
> [!NOTE]
> The two root font/icon install scripts can be safely ran regardless of whichever install approach you take. To remove them, check their respective `/usr/share` folders. Uninstall scripts WIP.

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

### Windows
The same repository can be applied on Windows; `.chezmoiignore` automatically skips the Linux/KDE-only files and only applies the Windows-specific ones (nushell, PowerShell profile, Spicetify).
```powershell
chezmoi init --apply joshrandall8478
```

## Visual Studio Code
VS code comes with an extension list, and user settings to mimic close to what I use. To install the extensions, run the `install-vscode-extensions.sh` script:
```bash
~/scripts/install-vscode-extensions.sh
```
