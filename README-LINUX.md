# Linux Installation Guide

This guide covers installation and setup of these dotfiles on Linux systems, specifically Debian/Ubuntu-based distributions including **Pop!_OS**.

## Quick Start

```bash
# Clone the repository
git clone https://github.com/yourusername/dotfiles.git ~/.dotfiles
cd ~/.dotfiles

# Checkout the linux branch (for testing before merge to master)
git checkout linux

# Initialize git submodules (zsh plugins)
git submodule update --init --recursive

# Install system packages
sudo apt update
sudo apt install -y $(grep -v '^#' packages.linux.txt | tr '\n' ' ')

# Run the installation script
./install.sh
```

**Note:** The cross-platform support is currently on the `linux` branch for testing. After verification on Linux systems, this will be merged to `master`.

## Prerequisites

### System Requirements

- **Linux**: Debian/Ubuntu-based distribution (tested on Pop!_OS 22.04+)
- **Display Server**: X11 or Wayland (both supported)
- **Shell**: Zsh (will be installed via packages.linux.txt)

### Install System Packages

The `packages.linux.txt` file contains all required packages:

```bash
sudo apt update
sudo apt install -y $(grep -v '^#' packages.linux.txt | tr '\n' ' ')
```

This installs:
- Core tools: git, stow, tmux, neovim, zsh
- Shell utilities: fzf, ripgrep, fd-find, bat, jq
- Clipboard utilities: xclip, xsel, wl-clipboard
- Build dependencies: Various lib*-dev packages
- YaleSites tools: mysql-client, docker.io, docker-compose

## Additional Software

Some software isn't available in apt and must be installed separately:

### 1. eza (Modern ls Replacement)

**Option A: Install from GitHub releases (recommended)**
```bash
# Download latest release
wget https://github.com/eza-community/eza/releases/latest/download/eza_x86_64-unknown-linux-gnu.tar.gz

# Extract and install
tar xf eza_x86_64-unknown-linux-gnu.tar.gz
sudo mv eza /usr/local/bin/
sudo chmod +x /usr/local/bin/eza

# Clean up
rm eza_x86_64-unknown-linux-gnu.tar.gz
```

**Option B: Install via cargo** (if Rust is installed)
```bash
cargo install eza
```

### 2. mise (Runtime Version Manager)

```bash
curl https://mise.run | sh
```

### 3. Alacritty (Terminal Emulator)

**Option A: Install via snap (easiest)**
```bash
sudo snap install alacritty --classic
```

**Option B: Install from releases**
```bash
# Add Alacritty PPA
sudo add-apt-repository ppa:aslatter/ppa
sudo apt update
sudo apt install alacritty
```

**Option C: Build from source**
See https://github.com/alacritty/alacritty/blob/master/INSTALL.md

### 4. Nerd Fonts (Cascadia Code)

```bash
# Create fonts directory
mkdir -p ~/.local/share/fonts

# Download Cascadia Code Nerd Font
cd ~/.local/share/fonts
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/CascadiaCode.zip

# Extract
unzip CascadiaCode.zip
rm CascadiaCode.zip

# Rebuild font cache
fc-cache -fv

# Verify installation
fc-list | grep Cascadia
```

### 5. Lando (YaleSites Development)

```bash
# Download latest .deb package
wget https://github.com/lando/lando/releases/download/v3.20.8/lando-v3.20.8.deb

# Install
sudo dpkg -i lando-v3.20.8.deb

# Fix dependencies if needed
sudo apt --fix-broken install

# Clean up
rm lando-v3.20.8.deb

# Verify installation
lando version
```

**Note**: Check https://lando.dev/download/ for the latest version.

### 6. Docker Setup

Lando requires Docker. The `docker.io` package from apt works, but Docker's official repository provides newer versions:

```bash
# Official Docker installation (optional, for latest version)
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# Add your user to docker group (avoid sudo for docker commands)
sudo usermod -aG docker $USER

# Log out and back in for group changes to take effect
# Or run: newgrp docker
```

## Installation

### Run the Installer

```bash
cd ~/.dotfiles
./install.sh
```

The installer will:
1. Check for required tools (stow, git)
2. Initialize git submodules (zsh plugins)
3. Offer to stow packages interactively
4. Back up existing configurations

### Change Default Shell to Zsh

```bash
# Set zsh as your default shell
chsh -s $(which zsh)

# Log out and back in for changes to take effect
```

## Configuration

### Set Up Clipboard

The dotfiles automatically detect and use available clipboard utilities:
- **X11**: Uses `xclip` or `xsel`
- **Wayland**: Uses `wl-clipboard`

Pop!_OS uses X11 by default, so `xclip` (installed via packages.linux.txt) works out of the box.

### Configure Git

Update git configuration with your information:

```bash
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

### YaleSites Local Configuration

If you're using these dotfiles for YaleSites development:

1. **Create local config** (optional):
```bash
cp ~/.dotfiles/zsh/.zprofile.local.example ~/.zprofile.local
# Edit with your local settings
```

2. **Install Terminus** (Pantheon CLI):
```bash
mkdir -p ~/.terminus
cd ~/.terminus
curl -O https://raw.githubusercontent.com/pantheon-systems/terminus-installer/master/builds/installer.phar
php installer.phar install
```

## Linux-Specific Features

### Package Name Differences

The dotfiles automatically create aliases for packages with different names on Linux:

- `fd` → `fdfind` (Ubuntu packages it as fd-find)
- `bat` → `batcat` (Ubuntu packages it as bat)

These aliases are defined in `zsh/.config/zsh/rc.d/env.linux.zsh`.

### Theme Behavior

- **Alacritty**: Defaults to Tokyo Night dark theme on Linux
- **Neovim**: Defaults to Tokyo Night night theme on Linux
- You can manually toggle themes:
  - Neovim: `:ToggleStyle` command
  - Alacritty: Edit `~/.config/alacritty/alacritty.toml`

### Display Server Detection

The configuration automatically detects if you're running Wayland:
- Sets `IS_WAYLAND=1` environment variable
- Uses appropriate clipboard utility (wl-copy/wl-paste vs xclip/xsel)

### Distribution Detection

The configuration detects your distribution and version:
- Sets `DISTRO_ID` (e.g., "pop", "ubuntu")
- Sets `DISTRO_VERSION` (e.g., "22.04")
- Allows for distro-specific customizations

## Troubleshooting

### Clipboard Not Working

**Check which clipboard utilities are installed:**
```bash
command -v xclip && echo "xclip: installed"
command -v xsel && echo "xsel: installed"
command -v wl-copy && echo "wl-clipboard: installed"
```

**Install missing utilities:**
```bash
# For X11
sudo apt install xclip

# For Wayland
sudo apt install wl-clipboard
```

### Fonts Not Rendering Properly

**Verify Nerd Font is installed:**
```bash
fc-list | grep -i cascadia
```

**Rebuild font cache:**
```bash
fc-cache -fv
```

**Restart Alacritty** after installing fonts.

### Lando/Docker Issues

**Check Docker is running:**
```bash
docker ps
```

**If permission denied:**
```bash
# Add your user to docker group
sudo usermod -aG docker $USER

# Log out and back in, or run:
newgrp docker
```

**Restart Docker service:**
```bash
sudo systemctl restart docker
```

### Zsh Plugins Not Loading

**Ensure submodules are initialized:**
```bash
cd ~/.dotfiles
git submodule update --init --recursive
```

**Check plugins exist:**
```bash
ls -la ~/.config/zsh/
```

### Shell Startup Slow

**Profile shell startup:**
```bash
time zsh -i -c exit
```

**Disable mise temporarily to test:**
```bash
# Comment out in ~/.config/zsh/rc.d/env.zsh:
# if command -v mise &> /dev/null; then
#   eval "$(mise activate zsh)"
# fi
```

## Differences from macOS

| Feature | macOS | Linux |
|---------|-------|-------|
| **Package Manager** | Homebrew | apt |
| **Clipboard** | pbcopy/pbpaste | xclip/xsel/wl-clipboard |
| **File Opening** | open | xdg-open |
| **Theme Detection** | System Preferences | Defaults to dark |
| **Paths** | /opt/homebrew | System /usr/lib |
| **Font Installation** | Homebrew | ~/.local/share/fonts |

All these differences are handled automatically by the platform detection in `platform.zsh` and platform-specific configuration in `env.linux.zsh`.

## Updating

### Update Dotfiles

```bash
cd ~/.dotfiles
git pull
```

### Update Zsh Plugins

```bash
cd ~/.dotfiles
git submodule update --remote
```

### Update System Packages

```bash
sudo apt update && sudo apt upgrade
```

### Restow After Changes

If you make changes to the dotfiles:

```bash
cd ~/.dotfiles
make restow-zsh  # Or specific package
# Or: stow -R zsh
```

## Uninstalling

```bash
cd ~/.dotfiles

# Unstow packages
stow -D zsh
stow -D tmux
stow -D git
# ... etc

# Remove dotfiles directory
rm -rf ~/.dotfiles

# Change shell back to bash (optional)
chsh -s /bin/bash
```

## Additional Resources

- [Main README](README.md) - General dotfiles documentation
- [Stow Manual](https://www.gnu.org/software/stow/manual/) - GNU Stow documentation
- [Alacritty GitHub](https://github.com/alacritty/alacritty) - Terminal emulator
- [LazyVim](https://www.lazyvim.org/) - Neovim configuration framework
- [Lando Docs](https://docs.lando.dev/) - Local development environment

## Support

For issues specific to Linux setup, please check:
1. This README-LINUX.md file
2. The [main README](README.md) troubleshooting section
3. Package-specific documentation linked above
