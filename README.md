# dotfiles

Personal dotfiles for macOS, managed with [GNU Stow](https://www.gnu.org/software/stow/).

![macOS](https://img.shields.io/badge/macOS-13+-blue)
![Shell](https://img.shields.io/badge/shell-zsh-green)

## Overview

This repository contains configuration files for a terminal-based development environment optimized for Drupal/YaleSites development at Yale University. The setup features:

- **Terminal**: Alacritty with TokyoNight theme
- **Multiplexer**: tmux with vim-aware navigation
- **Shell**: Zsh with async git status and extensive YaleSites utilities
- **Editor**: Neovim with LazyVim distribution
- **Theme**: Consistent TokyoNight across all tools

## Quick Start

```bash
# Clone the repository
git clone https://github.com/yourusername/dotfiles.git ~/.dotfiles
cd ~/.dotfiles

# Initialize git submodules (zsh plugins)
git submodule update --init --recursive

# Run the installation script
./install.sh
```

## Prerequisites

### Required

- **macOS** (Darwin) - tested on macOS 13+
- **Homebrew** - `/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"`
- **GNU Stow** - `brew install stow`
- **Git** - `brew install git`

### Recommended

```bash
# Terminal emulator
brew install --cask alacritty

# Terminal multiplexer
brew install tmux

# Editor
brew install neovim

# Shell plugins (managed as git submodules, but need zsh)
brew install zsh

# Font (required for proper display)
brew install --cask font-cascadia-code-nf

# Runtime version manager
brew install mise

# Additional utilities
brew install fzf ripgrep fd bat eza
```

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
├── git/                # Git configuration
│   ├── .gitconfig
│   ├── .gitignore (global)
│   └── .gitmessage
├── lazyvim/            # Neovim LazyVim config
│   └── .config/lazyvim/
├── scripts/            # Utility scripts
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

# Stow individual packages
stow zsh
stow tmux
stow git
stow alacritty
stow lazyvim
stow scripts

# Optional packages
stow hammerspoon
stow karabiner
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
