# dotfiles

Personal dotfiles for **macOS** and **Linux**, managed with [GNU Stow](https://www.gnu.org/software/stow/).

![macOS](https://img.shields.io/badge/macOS-13+-blue)
![Linux](https://img.shields.io/badge/Linux-Pop!_OS%20%7C%20Ubuntu-orange)
![Shell](https://img.shields.io/badge/shell-zsh-green)

## Overview

Cross-platform dotfiles for a terminal-based development environment optimized for Drupal/YaleSites development at Yale University. The same configuration works seamlessly on both macOS and Linux with automatic platform detection. The setup features:

- **Terminal**: Alacritty with TokyoNight theme
- **Multiplexer**: tmux with vim-aware navigation
- **Shell**: Zsh with async git status and extensive YaleSites utilities
- **Editor**: Neovim with LazyVim distribution
- **Theme**: Consistent TokyoNight across all tools

## Supported Platforms

- ✅ **macOS** 13+ (Ventura and later)
  - Intel and Apple Silicon (M1/M2/M3)
  - Package manager: Homebrew

- ✅ **Linux** (Debian/Ubuntu-based)
  - Pop!_OS 22.04+ (tested)
  - Ubuntu 22.04+ (tested)
  - Other Debian derivatives (should work)
  - Package manager: apt
  - Display servers: X11 and Wayland both supported

**📖 Linux Users**: See [README-LINUX.md](README-LINUX.md) for Linux-specific installation instructions.

## Quick Start

```bash
# Clone the repository
git clone https://github.com/yourusername/dotfiles.git ~/.dotfiles
cd ~/.dotfiles

# For testing the Linux branch (before merge):
# git checkout linux

# Initialize git submodules (zsh plugins)
git submodule update --init --recursive

# Run the installation script
./install.sh
```

**Note:** The cross-platform support is currently on the `linux` branch. After testing on Linux, this will be merged to `master`.

## Health Check & Validation

After installation, validate your dotfiles setup:

```bash
# Run comprehensive health check
make validate

# Check platform detection and environment
make check-platform

# Check basic prerequisites
make check
```

The `dotfiles-check` script validates:
- ✅ Symlinks point to valid targets
- ✅ Git submodules are initialized
- ✅ Required binaries are installed
- ✅ Scripts have correct permissions
- ✅ Platform detection is working
- ✅ Shell scripts pass shellcheck (if installed)

## Prerequisites

### macOS

**Required:**
- **macOS** 13+ (Ventura and later)
- **Homebrew** - `/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"`
- **GNU Stow** - `brew install stow`
- **Git** - `brew install git`

**Recommended packages:**
```bash
# Core tools
brew install tmux neovim zsh

# Terminal emulator
brew install --cask alacritty

# Font (required for proper display)
brew install --cask font-cascadia-code-nf

# Runtime version manager
brew install mise

# Additional utilities
brew install fzf ripgrep fd bat eza
```

**Or install all dependencies at once:**
```bash
cd ~/.dotfiles
brew bundle  # Uses Brewfile in the repository
```

### Linux

**Required:**
- **Pop!_OS** 22.04+ or **Ubuntu** 22.04+ (or other Debian-based distributions)
- **GNU Stow** - `sudo apt install stow`
- **Git** - `sudo apt install git`

**Install all system packages:**
```bash
cd ~/.dotfiles
sudo apt update
sudo apt install -y $(grep -v '^#' packages.linux.txt | tr '\n' ' ')
```

**Additional software** (not in apt):

Use the automated installer for eza, mise, Nerd Fonts, Lando, and Alacritty:

```bash
# Install all extras automatically
./install-linux-extras.sh --all

# Or install individually
./install-linux-extras.sh --eza
./install-linux-extras.sh --mise
./install-linux-extras.sh --fonts
./install-linux-extras.sh --lando
./install-linux-extras.sh --alacritty
```

Or use the Makefile:
```bash
make install-linux-extras
```

**📖 See [README-LINUX.md](README-LINUX.md) for detailed Linux installation instructions and [PACKAGES.md](PACKAGES.md) for cross-platform package mapping.**

### Optional

**tmux Plugin Manager (TPM)**: The tmux configuration declares plugins but TPM is optional. To enable tmux plugins:

```bash
# Install TPM
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# Inside tmux, press prefix + I (capital i) to install plugins
```

Without TPM, tmux will still function normally - you'll just see a brief error message on startup about missing plugins.

## Repository Structure

This repository uses **GNU Stow** for dotfile management. Each top-level directory is a "stow package" that mirrors your home directory structure:

```
dotfiles/
├── alacritty/          # Terminal emulator config
│   └── .config/alacritty/
├── archive/            # Archived scripts (not stowed; kept for reference)
│   └── scripts/
├── git/                # Git configuration
│   ├── .gitconfig
│   ├── .gitignore (global)
│   └── .gitmessage
├── lazyvim/            # Neovim LazyVim config
│   └── .config/lazyvim/
├── scripts/            # Cross-platform utility scripts
│   └── .local/bin/
├── scripts-linux/      # Linux-only scripts (display management, gaming backups)
│   └── .local/bin/
├── scripts-mac/        # macOS-only scripts (lock, killexchange, Lando/Drupal tools)
│   └── .local/bin/
├── tmux/               # tmux configuration
│   └── .tmux.conf
├── zsh/                # Zsh configuration
│   ├── .zshrc
│   ├── .zprofile
│   └── .config/zsh/    # Plugins (as submodules)
├── hammerspoon/        # macOS automation (optional)
├── karabiner/          # Keyboard customization (optional)
├── nvim/               # Alternative nvim config (optional)
├── vim/                # Fallback vim config (optional)
└── asdf/               # Legacy version manager config (optional)
```

Multiple packages can share the same target directory — `scripts/`, `scripts-linux/`, and `scripts-mac/` all symlink files into `~/.local/bin/`. Stow only the packages relevant to your platform.

When you stow a package, files are symlinked from `~/.dotfiles/<package>/<path>` to `~/<path>`.

## Installation

### Automated Installation

The `install.sh` script provides an interactive installation:

```bash
./install.sh
```

It will:
1. Check for prerequisites (Homebrew, Stow)
2. Initialize git submodules
3. Offer to install each package interactively
4. Back up existing configurations
5. Create necessary directories
6. Stow selected packages

### Manual Installation

If you prefer manual control:

```bash
# Initialize submodules (zsh plugins)
git submodule update --init --recursive

# Stow core packages (all platforms)
stow zsh
stow tmux
stow git
stow scripts

# macOS-specific
stow scripts-mac
stow hammerspoon
stow karabiner

# Linux-specific
stow scripts-linux
stow autostart
stow mise

# Optional packages
stow alacritty
stow lazyvim
stow nvim       # Alternative neovim config
stow vim        # Fallback vim config
```

### Selective Installation

You can install only what you need:

```bash
# Minimal shell setup
stow zsh git

# Add editor
stow lazyvim

# Add terminal
stow alacritty tmux
```

## Configuration

### Local Overrides

Sensitive or machine-specific configurations should be placed in `.local` files, which are gitignored:

- `~/.zprofile.local` - Machine-specific environment variables
- `~/.zprofile.local.portkey` - Portkey configuration for Claude Code
- `.lando.local.yml` - YaleSites local Lando configuration

### Environment Variables

The shell configuration sets up standard XDG base directories:

- `XDG_CONFIG_HOME` → `~/.config`
- `XDG_DATA_HOME` → `~/.local/share`
- `XDG_CACHE_HOME` → `~/.cache`
- `XDG_STATE_HOME` → `~/.local/state`

### Editor Selection

The active Neovim config is controlled by `NVIM_APPNAME` in `.zprofile`:

```bash
export NVIM_APPNAME="lazyvim"  # Uses ~/.config/lazyvim
# export NVIM_APPNAME="nvim"   # Alternative: uses ~/.config/nvim
```

## YaleSites Development Features

The zsh configuration includes extensive utilities for YaleSites/Drupal development:

### Key Functions

- `llogin [--copy] [terminus-args]` - Get Drupal login URL
- `watchdog [terminus-args]` - Tail Drupal logs
- `yspull` - Update all YaleSites repos (project + atomic + component-library-twig)
- `gyst` - Git checkout matching branch across all repos
- `dbget [multidev]` - Pull database from Pantheon (default: dev)
- `dbandfiles [multidev]` - Pull database and files
- `confim` - Config import + cache rebuild
- `local-setup` - Initialize new YaleSites site
- `siteid <site-name>` - Get Pantheon site ID (cached)

### Lando Aliases

- `l` → `lando`
- `lcr` → `lando drush cr`
- `ldr` → `lando drush`
- `lrb` → `lando rebuild -y`

See [zsh/.zshrc](zsh/.zshrc) lines 385-725 for complete YaleSites utilities.

## Key Bindings

### tmux (Prefix: Ctrl+Space)

- `prefix + |` or `\` - Split horizontal
- `prefix + -` - Split vertical
- `prefix + h/j/k/l` - Navigate panes
- `Ctrl+h/j/k/l` - Navigate panes/vim (seamless)
- `prefix + b` - Jump to last prompt
- `prefix + r` - Reload config
- `Ctrl+Space Ctrl+Space` - Last session

### Zsh

- `Alt+f` - Launch tmux-sessionizer (fuzzy session switcher)
- `Ctrl+r` - History search
- `Ctrl+Space` - Accept autosuggestion

### Neovim (LazyVim)

See [LazyVim documentation](https://www.lazyvim.org/) for complete keybindings.

## Updating

### Update Dotfiles

```bash
cd ~/.dotfiles
git pull
```

### Update ZSH Plugins

The zsh plugins are managed as git submodules:

```bash
# Update all plugins to latest
git submodule update --remote

# Update specific plugin
git submodule update --remote zsh/.config/zsh/zsh-autosuggestions

# Commit the updates
git add .gitmodules zsh/.config/zsh/
git commit -m "chore: update zsh plugins"
```

### Update via Makefile

```bash
make update      # Update submodules
make restow      # Restow all packages (useful after changes)
```

## Troubleshooting

### Stow Conflicts

If stow reports conflicts:

```bash
# See what would be done (dry-run)
stow -n -v zsh

# Force restow (replaces existing)
stow -R zsh

# Unstow first if needed
stow -D zsh
stow zsh
```

### ZSH Plugins Not Loading

```bash
# Ensure submodules are initialized
git submodule update --init --recursive

# Check plugins exist
ls -la ~/.config/zsh/
```

### LazyVim Issues

```bash
# Ensure config is properly stowed
ls -la ~/.config/lazyvim  # Should be a symlink

# If it's a real directory, unstow and restow:
rm -rf ~/.config/lazyvim  # Back up first if needed!
stow lazyvim
```

### Shell is Slow to Start

Profile your shell startup to identify bottlenecks:

```bash
# Enable profiling (uncomment lines in .zshrc)
# Then restart shell and run:
zprof

# Or time the shell startup
time zsh -i -c exit
```

Common causes:
- Slow plugin loading
- Network calls during startup (check for API calls)
- Too many PATH modifications

### mise/NVM/Bun Not Found

Ensure the tools are installed:

```bash
# Install mise
brew install mise

# Install nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash

# Install bun
curl -fsSL https://bun.sh/install | bash
```

The .zshrc has conditional checks, so missing tools won't cause errors.

### Lando Commands Failing

```bash
# Check Docker is running
docker ps

# Check Lando is installed
lando version

# Rebuild if issues persist
lando rebuild -y
```

### Modular ZSH Configuration Issues

If you encounter errors after the modular restructure:

```bash
# Check modules directory exists
ls -la ~/.config/zsh/rc.d/

# Verify all modules are sourced
grep -r "source.*rc.d" ~/.zshrc

# Check for syntax errors in modules
zsh -n ~/.config/zsh/rc.d/env.zsh
zsh -n ~/.config/zsh/rc.d/aliases.zsh
zsh -n ~/.config/zsh/rc.d/functions.zsh
zsh -n ~/.config/zsh/rc.d/yalesites.zsh
```

### Font Issues in Alacritty

Install CaskaydiaMono Nerd Font:
```bash
brew install --cask font-cascadia-code-nf
```

Then restart Alacritty.

## Uninstalling

To remove a package:

```bash
# Unstow (removes symlinks)
stow -D zsh

# The original files remain in ~/.dotfiles/
```

To remove everything:

```bash
cd ~/.dotfiles
stow -D */  # Unstow all packages
cd ~
rm -rf ~/.dotfiles
```

## Contributing

These are personal dotfiles, but feel free to:

- Fork for your own use
- Open issues for questions
- Submit PRs for general improvements

## License

MIT License - feel free to use and modify for your own dotfiles.

## Acknowledgments

- [GNU Stow](https://www.gnu.org/software/stow/) - Dotfile management
- [LazyVim](https://www.lazyvim.org/) - Neovim configuration
- [TokyoNight](https://github.com/folke/tokyonight.nvim) - Color scheme
- Inspired by many dotfiles repos in the community

## See Also

- [CLAUDE.md](CLAUDE.md) - Detailed documentation for Claude Code
- [Makefile](Makefile) - Available make targets
