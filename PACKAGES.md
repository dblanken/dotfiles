# Package Mapping and Dependencies

This document provides a comprehensive mapping between macOS (Homebrew) and Linux (apt) packages used in this dotfiles repository, along with version requirements and installation notes.

## Table of Contents

- [Core Packages](#core-packages)
- [Shell Utilities](#shell-utilities)
- [Development Tools](#development-tools)
- [Build Dependencies](#build-dependencies)
- [Platform-Specific Packages](#platform-specific-packages)
- [Manual Installation Required](#manual-installation-required)
- [Version Requirements](#version-requirements)

---

## Core Packages

Essential packages required for basic dotfiles functionality.

| Purpose | macOS (Homebrew) | Linux (apt) | Notes |
|---------|------------------|-------------|-------|
| Version control | `git` | `git` | Same package name |
| Symlink manager | `stow` | `stow` | Same package name |
| Terminal multiplexer | `tmux` | `tmux` | Same package name |
| Text editor | `neovim` | `neovim` | Requires Neovim 0.9+ |
| Shell | `zsh` | `zsh` | Same package name |

**Installation:**

```bash
# macOS
brew install git stow tmux neovim zsh

# Linux
sudo apt install git stow tmux neovim zsh
```

---

## Shell Utilities

Modern command-line tools for enhanced productivity.

| Tool | macOS (Homebrew) | Linux (apt) | Binary Name | Notes |
|------|------------------|-------------|-------------|-------|
| Fuzzy finder | `fzf` | `fzf` | `fzf` | Same on both |
| Fast grep | `ripgrep` | `ripgrep` | `rg` | Same on both |
| Fast find | `fd` | `fd-find` | `fd` / `fdfind` | **Different!** See below |
| Better cat | `bat` | `bat` | `bat` / `batcat` | **Different!** See below |
| Better ls | `eza` | *(manual)* | `eza` | See [Manual Installation](#manual-installation-required) |
| JSON processor | `jq` | `jq` | `jq` | Same on both |

### Platform Differences

**fd (file finder):**
- **macOS**: Binary is `fd`
- **Linux**: Package is `fd-find`, binary is `fdfind`
- **Solution**: Alias created in `env.linux.zsh`: `alias fd='fdfind'`

**bat (cat alternative):**
- **macOS**: Binary is `bat`
- **Linux**: Package is `bat`, binary is `batcat`
- **Solution**: Alias created in `env.linux.zsh`: `alias bat='batcat'`

**Installation:**

```bash
# macOS
brew install fzf ripgrep fd bat eza jq

# Linux (apt packages only)
sudo apt install fzf ripgrep fd-find bat jq
# eza requires manual installation (see below)
```

---

## Development Tools

Version managers and development environment tools.

| Tool | macOS (Homebrew) | Linux | Binary | Notes |
|------|------------------|-------|--------|-------|
| Runtime version manager | `mise` | *(curl installer)* | `mise` | Replaces asdf, see manual installation |
| Terminal emulator | `alacritty` (cask) | *(manual)* | `alacritty` | See manual installation |
| Nerd Fonts | `font-cascadia-code-nf` (cask) | *(manual)* | N/A | CaskaydiaMono Nerd Font |
| Local dev environment | N/A | *(manual)* | `lando` | YaleSites-specific, Linux only |

**Installation:**

```bash
# macOS
brew install mise
brew install --cask alacritty font-cascadia-code-nf

# Linux - see Manual Installation section
```

---

## Build Dependencies

Libraries required for building PHP extensions, Ruby gems, and other native packages.

| Library | macOS (Homebrew) | Linux (apt) | Purpose |
|---------|------------------|-------------|---------|
| OpenSSL | `openssl@1.1` | `libssl-dev` | Encryption |
| XML parsing | `libxml2` | `libxml2-dev` | PHP XML extensions |
| ImageMagick | `imagemagick@6` | `imagemagick` + `libmagickwand-dev` | Image processing |
| GMP | `gmp` | `libgmp-dev` | Arbitrary precision arithmetic |
| PNG | `libpng` | `libpng-dev` | PNG image support |
| TIFF | `libtiff` | `libtiff-dev` | TIFF image support |
| ncurses | `ncurses` | `libncurses-dev` | Terminal UI |
| MPFR | `mpfr` | `libmpfr-dev` | Multiple precision floating-point |
| YAML | `libyaml` | `libyaml-dev` | YAML parsing |
| ICU | `icu4c` | `libicu-dev` | Unicode support |
| Readline | `readline` | `libreadline-dev` | Command line editing |
| WebP | `webp` | `libwebp-dev` | WebP image format |
| ODBC | `unixodbc` | `unixodbc-dev` | Database connectivity |
| JPEG | `jpeg` | `libjpeg-dev` | JPEG image support |
| PostgreSQL | `libpq` | `libpq-dev` | PostgreSQL client |

**Installation:**

```bash
# macOS
brew install openssl@1.1 libxml2 imagemagick@6 gmp libpng libtiff \
  ncurses mpfr libyaml icu4c readline webp unixodbc jpeg libpq imagemagick

# Linux
sudo apt install build-essential libssl-dev libxml2-dev libgmp-dev \
  libpng-dev libtiff-dev libncurses-dev libmpfr-dev libyaml-dev \
  libicu-dev libreadline-dev libwebp-dev unixodbc-dev libjpeg-dev \
  libpq-dev imagemagick libmagickwand-dev
```

**Note:** Linux also requires `build-essential` for gcc, g++, make, etc.

---

## Platform-Specific Packages

### macOS Only

| Package | Type | Purpose | Notes |
|---------|------|---------|-------|
| `mysql-client@8.4` | brew | MySQL client | Pantheon requires 8.4 syntax |
| `hammerspoon` | cask | macOS automation | Optional |
| `karabiner-elements` | cask | Keyboard customization | Optional |

### Linux Only

| Package | Type | Purpose | Notes |
|---------|------|---------|-------|
| `mysql-client` | apt | MySQL client | Generic version (not 8.4-specific) |
| `docker.io` | apt | Container runtime | For Lando |
| `docker-compose` | apt | Container orchestration | For Lando |
| `xclip` | apt | X11 clipboard utility | For `clipboard_copy()` wrapper |
| `xsel` | apt | X11 clipboard utility | Alternative to xclip |
| `wl-clipboard` | apt | Wayland clipboard utility | For Wayland desktops |
| `fontconfig` | apt | Font configuration | For Nerd Fonts |
| `ca-certificates` | apt | SSL certificates | For HTTPS |
| `gnupg` | apt | GPG encryption | For package verification |
| `lsb-release` | apt | Distribution info | For version detection |

**Clipboard utilities:**
- **X11 users** (default on Pop!_OS, Ubuntu): Install `xclip` or `xsel`
- **Wayland users** (GNOME on Wayland, Sway): Install `wl-clipboard`
- The `platform.zsh` wrapper functions try all three in order

---

## Manual Installation Required

These tools cannot be installed via standard package managers and require manual steps.

### eza (Better ls)

**macOS:**
```bash
brew install eza
```

**Linux:**
```bash
# Option 1: Use the automated installer
./install-linux-extras.sh --eza

# Option 2: Manual via cargo
cargo install eza
# Add ~/.cargo/bin to PATH

# Option 3: Manual from GitHub releases
# See: https://github.com/eza-community/eza/releases
```

**Version:** Latest stable recommended

---

### mise (Runtime version manager)

**macOS:**
```bash
brew install mise
```

**Linux:**
```bash
# Option 1: Use the automated installer
./install-linux-extras.sh --mise

# Option 2: Manual installation
curl https://mise.run | sh
# Restart shell or source ~/.zshrc
```

**Version:** Latest stable recommended

**Usage:** Replaces asdf/nvm/rbenv for managing Node.js, PHP, Ruby, Python versions

---

### Nerd Fonts (CaskaydiaMono)

**macOS:**
```bash
brew install --cask font-cascadia-code-nf
```

**Linux:**
```bash
# Option 1: Use the automated installer
./install-linux-extras.sh --fonts

# Option 2: Manual installation
mkdir -p ~/.local/share/fonts
cd ~/.local/share/fonts
curl -sL https://github.com/ryanoasis/nerd-fonts/releases/latest/download/CascadiaMono.zip -o CascadiaMono.zip
unzip CascadiaMono.zip
rm CascadiaMono.zip
fc-cache -f ~/.local/share/fonts
```

**Required for:** Alacritty, tmux, and LazyVim icons

---

### Alacritty (Terminal emulator)

**macOS:**
```bash
brew install --cask alacritty
```

**Linux:**
```bash
# Option 1: Use the automated installer
./install-linux-extras.sh --alacritty

# Option 2: Via snap (easiest)
sudo snap install alacritty --classic

# Option 3: Via PPA (Ubuntu 20.04+)
sudo add-apt-repository ppa:aslatter/ppa
sudo apt update
sudo apt install alacritty

# Option 4: Build from source
# See: https://github.com/alacritty/alacritty/blob/master/INSTALL.md
```

**Version:** Latest stable recommended

---

### Lando (Local development environment)

**macOS:**
```bash
# Download from https://lando.dev/download/
# Or use Homebrew (if available)
```

**Linux:**
```bash
# Option 1: Use the automated installer
./install-linux-extras.sh --lando

# Option 2: Manual installation
# Download latest .deb from https://github.com/lando/lando/releases
# Example:
wget https://github.com/lando/lando/releases/download/v3.x.x/lando-x64-v3.x.x.deb
sudo dpkg -i lando-x64-v3.x.x.deb
sudo apt-get install -f  # Fix dependencies
```

**Prerequisites:** Docker must be installed first
- **macOS**: Docker Desktop
- **Linux**: `docker.io` and `docker-compose` packages

**YaleSites-specific:** Required for local Drupal development

---

## Version Requirements

### Minimum Versions

| Tool | Minimum Version | Reason |
|------|----------------|--------|
| Neovim | 0.9.0 | LazyVim requirement |
| Git | 2.30+ | Modern git features, SSH signing |
| Zsh | 5.8+ | Modern shell features |
| tmux | 3.2+ | True color support, modern features |
| Docker | 20.10+ | For Lando |

### YaleSites-Specific

| Tool | Version | Reason |
|------|---------|--------|
| MySQL client | 8.4.x | Pantheon requires 8.4 SQL syntax |
| PHP | 8.3+ | Drupal 10 requirement |
| Node.js | 20.x LTS | Component library build |
| Composer | 2.x | PHP dependency management |

**Note:** PHP and Node.js versions are managed by `mise` and not installed system-wide.

---

## Quick Installation Commands

### macOS - Complete Setup

```bash
# Install Homebrew first
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install all packages
cd ~/.dotfiles
brew bundle

# Stow packages
make stow-core
make stow-optional
```

### Linux - Complete Setup

```bash
# Install apt packages
cd ~/.dotfiles
sudo apt update
sudo apt install -y $(grep -v '^#' packages.linux.txt | tr '\n' ' ')

# Install manual packages
chmod +x install-linux-extras.sh
./install-linux-extras.sh --all

# Stow packages
make stow-core
make stow-optional
```

---

## Troubleshooting

### Missing packages after installation

```bash
# Check what's installed
command -v <package-name>

# On Linux, check if binary has different name
which fdfind batcat  # Instead of fd, bat
```

### Build failures

Ensure all build dependencies are installed:

```bash
# macOS
brew install openssl@1.1 libxml2 imagemagick@6

# Linux
sudo apt install build-essential libssl-dev libxml2-dev
```

### Clipboard not working on Linux

Install appropriate clipboard utility:

```bash
# X11 (most systems)
sudo apt install xclip

# Wayland
sudo apt install wl-clipboard

# Test it
echo "test" | clipboard copy
clipboard paste
```

### Fonts not showing in terminal

1. Verify fonts are installed: `fc-list | grep -i cascadia`
2. Configure Alacritty to use the font (already done in `alacritty.toml`)
3. Restart terminal

---

## Dependencies Between Packages

Some packages depend on others being installed first:

```
stow ← All dotfiles
git ← Dotfiles repository, submodules
zsh ← Shell configuration
  ├── fzf (for tmux-sessionizer, shell history)
  ├── ripgrep (for searching)
  ├── fd (for file finding)
  └── git submodules (zsh plugins)
tmux ← Terminal multiplexer
  ├── clipboard utility (xclip/xsel/wl-clipboard on Linux)
  └── Nerd Fonts (for icons)
neovim ← LazyVim
  ├── Nerd Fonts (for icons)
  ├── ripgrep (for telescope)
  ├── fd (for telescope)
  └── Node.js (for LSP servers, managed via mise)
alacritty ← Terminal
  └── Nerd Fonts (for icons)
lando ← YaleSites development
  └── Docker (docker.io + docker-compose on Linux)
```

---

## Adding New Packages

When adding new packages to the dotfiles:

1. Add to `Brewfile` (macOS) and `packages.linux.txt` (Linux)
2. Document in this file with platform equivalents
3. Note any binary name differences
4. Add aliases in `env.linux.zsh` if needed
5. Update `install-linux-extras.sh` if manual installation required
6. Test on both platforms

---

## See Also

- [README.md](README.md) - General installation guide
- [README-LINUX.md](README-LINUX.md) - Linux-specific installation
- [install-linux-extras.sh](install-linux-extras.sh) - Automated Linux extras installer
- [Brewfile](Brewfile) - macOS package definitions
- [packages.linux.txt](packages.linux.txt) - Linux package list
