# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a personal dotfiles repository managed with **GNU Stow** for **macOS** and **Linux**. The repository contains cross-platform configuration files for a development environment centered around terminal-based workflows with tmux, Neovim (LazyVim), Alacritty, and Zsh.

**Supported platforms:**
- macOS 13+ (Ventura and later) - Intel and Apple Silicon
- Linux (Debian/Ubuntu-based) - Pop!_OS 22.04+, Ubuntu 22.04+

The same configuration works seamlessly on both platforms through automatic platform detection and conditional loading.

## Architecture and Structure

### GNU Stow Organization

Each top-level directory represents a "stow package" that mirrors the home directory structure:

```
package/
  .config/        → ~/.config/
  .filename       → ~/.filename
  .local/         → ~/.local/
```

When stowed, files are symlinked from `~/.dotfiles/<package>/<path>` to `~/<path>`.

**Key packages:**
- `zsh/` - Shell configuration with extensive YaleSites-specific functions
- `tmux/` - Terminal multiplexer with vim-aware navigation
- `lazyvim/` - Neovim configuration (LazyVim distribution)
- `nvim/` - Legacy/alternative Neovim configuration
- `alacritty/` - Terminal emulator configuration
- `git/` - Git configuration and global gitignore
- `scripts/` - Utility scripts in `.local/bin/`

### Cross-Platform Architecture

**Platform Detection:**
The configuration automatically detects the operating system and loads platform-specific modules:

1. **Early detection** in `.zprofile` sets `OS_TYPE` environment variable:
   - `darwin` - macOS systems
   - `linux` - Linux systems

2. **Modular loading** in `.zshrc` loads modules in this order:
   - `platform.zsh` - OS detection and wrapper functions (first)
   - `env.zsh` - Cross-platform environment variables
   - `env.$OS_TYPE.zsh` - Platform-specific environment (env.darwin.zsh or env.linux.zsh)
   - `aliases.zsh` - Shell aliases
   - `functions.zsh` - Shell functions
   - `yalesites.zsh` - YaleSites-specific utilities
   - Other modules as needed

**Wrapper Functions:**
Platform-specific commands are abstracted behind cross-platform wrapper functions in `platform.zsh`:

- `clipboard_copy()` - pbcopy (macOS) or xclip/xsel/wl-clipboard (Linux)
- `clipboard_paste()` - pbpaste (macOS) or xclip/xsel/wl-paste (Linux)
- `open_file()` - open (macOS) or xdg-open (Linux)
- Aliased as `pbcopy`, `pbpaste`, and `open` for compatibility

**Platform-Specific Files:**
- `env.darwin.zsh` - Homebrew paths, macOS build flags, mysql8 alias
- `env.linux.zsh` - Linux package aliases (fd→fdfind, bat→batcat), distribution detection, Wayland detection
- `clipboard` script - Standalone cross-platform clipboard utility for tmux

**Package Management:**
- **macOS**: `Brewfile` for Homebrew packages
- **Linux**: `packages.linux.txt` for apt packages

See [README-LINUX.md](README-LINUX.md) for Linux-specific installation details.

### Local Configuration Pattern

Sensitive or machine-specific configs use `.local` suffix:
- `.zprofile.local` - Not in repo, sourced if present (example template: `.zprofile.local.example`)
- `.zprofile.local.portkey` - Referenced by enable_portkey script
- `.lando.local.yml` - YaleSites local environment (generated)

These files are gitignored and should never be committed.

## Package Management

### Dotfiles Management

- **Tool**: GNU Stow - symlinks packages from `~/.dotfiles/` to `~/`
- **Submodules**: Zsh plugins managed as git submodules (see `.gitmodules`)
- **Installation**: Run `./install.sh` for interactive setup or use `Makefile` targets
- **Updates**: `git submodule update --remote` or `make update`

### System Packages

**macOS:**
- **Package Manager**: Homebrew (`/opt/homebrew` on Apple Silicon, `/usr/local` on Intel)
- **Installation**: `brew bundle` uses `Brewfile` in repository root
- **Packages**: tmux, neovim, zsh, alacritty, fzf, ripgrep, fd, bat, eza, mise

**Linux:**
- **Package Manager**: apt (Debian/Ubuntu)
- **Installation**: `sudo apt install -y $(grep -v '^#' packages.linux.txt | tr '\n' ' ')`
- **Packages**: Equivalent to macOS packages, some with different names (fd-find, batcat)
- **Additional**: Some tools require manual installation (eza, mise, alacritty, lando, nerd fonts)

**Cross-Platform:**
- **Runtime versions**: mise (formerly asdf), conditionally loaded
- **Editor**: LazyVim with custom configuration in `lazyvim/.config/lazyvim/`
- **Node versions**: NVM loaded conditionally if installed

### XDG Base Directories

Standard environment variables set in zsh/.zprofile:
- `XDG_CONFIG_HOME` → `~/.config`
- `XDG_DATA_HOME` → `~/.local/share`
- `XDG_CACHE_HOME` → `~/.cache`
- `XDG_STATE_HOME` → `~/.local/state`

## Development Environment

### Shell Configuration (zsh/.zshrc)

**Modular Architecture:**
Configuration is split into focused modules in `zsh/.config/zsh/rc.d/`:
- `platform.zsh` - OS detection and cross-platform wrapper functions
- `env.zsh` - Cross-platform environment variables
- `env.darwin.zsh` - macOS-specific configuration (Homebrew, build flags)
- `env.linux.zsh` - Linux-specific configuration (package aliases, distro detection)
- `aliases.zsh` - Shell aliases
- `functions.zsh` - Utility functions
- `yalesites.zsh` - YaleSites/Drupal development functions

**Prompt**: Custom prompt with async git status using zsh-async

**Plugins** (managed as git submodules):
- `zsh-autosuggestions` - Command suggestions based on history
- `zsh-syntax-highlighting` - Real-time syntax highlighting
- `zsh-history-substring-search` - Better history search
- `zsh-async` - Asynchronous task execution for VCS info

**Vi mode**: Set with `set -o vi`

### YaleSites-Specific Workflows

This environment is heavily customized for YaleSites Drupal development in `yalesites.zsh`:

**Key functions:**
- `llogin [--copy] [terminus-args]` - Get Drupal login URL (uses `clipboard_copy` and `open_file` wrappers)
- `watchdog [terminus-args]` - Tail Drupal watchdog logs
- `yspull` - Update all three YaleSites repos (project, atomic, component-library-twig)
- `gyst` - Git checkout matching branch across all YaleSites repos
- `gcbcreate` - Create branch in all YaleSites repos
- `dbget [multidev]` - Pull database from Pantheon multidev (defaults to 'dev')
- `dbandfiles [multidev]` - Pull both database and files
- `confim` - Config import followed by cache rebuild
- `local-setup` - Initialize new local YaleSites site
- `siteid <site-name> [-f]` - Get Pantheon site ID with caching
- `ysopen` - Open local site in browser (uses `open_file` wrapper)
- `dbport` - Get database port for local MySQL connection (uses `clipboard_copy` wrapper)

**Lando aliases:**
- `l` = lando
- `lcr` = lando drush cr
- `ldr` = lando drush
- `lrb` = lando rebuild -y

**Note**: YaleSites functions use cross-platform wrapper functions for clipboard and file opening, making them work on both macOS and Linux.

### Tmux Configuration

**Prefix**: `Ctrl+Space` (instead of Ctrl+B) (tmux/.tmux.conf:12)
**Theme**: TokyoNight colors (lines 305-340)

**Vim-tmux navigation**: Seamless pane switching between tmux and Neovim using Ctrl+h/j/k/l (lines 274-295)

**Key bindings:**
- `prefix + |` or `prefix + \` - Split horizontally
- `prefix + -` - Split vertically
- `prefix + p` - Previous layout
- `prefix + b` - Jump to last prompt (searches for ❯)
- `prefix + r` - Reload config
- `Ctrl+Space Ctrl+Space` - Switch to last session

**Copy mode**: Vi keys enabled, cross-platform clipboard integration via `~/.local/bin/clipboard` script

### Terminal (Alacritty)

- **Font**: CaskaydiaMono Nerd Font, 13pt
- **Theme**: TokyoNight (imported from themes/)
- **Window**: No decorations, maximized startup, left Option as Alt

**Theme Detection:**
- `switch-alacritty-theme.sh` automatically selects theme variant:
  - **macOS**: Reads system dark mode preference via `defaults` command
  - **Linux**: Defaults to dark theme (can be manually toggled)
- Run automatically on shell startup

### Editor (Neovim/LazyVim)

**Active config**: LazyVim via `NVIM_APPNAME=lazyvim`
**Location**: `lazyvim/.config/lazyvim/`
**Structure**: Standard LazyVim structure with custom plugins/ and config/

**Theme Detection:**
- `colorscheme.lua` automatically selects TokyoNight variant:
  - **macOS**: Reads system dark mode preference (day/night)
  - **Linux**: Defaults to night theme
- Toggle manually with `:ToggleStyle` command

## Utility Scripts

Located in `scripts/.local/bin/`:

**clipboard** - Cross-platform clipboard utility
- Provides `copy` and `paste` subcommands
- **macOS**: Uses pbcopy/pbpaste
- **Linux**: Tries xclip, xsel, or wl-clipboard (X11/Wayland)
- Used by tmux for copy-paste operations

**tmux-sessionizer** - FZF-based tmux session switcher
- Searches directories under `~/code/`
- Includes `$XDG_CONFIG_HOME/$NVIM_APPNAME` and `~/.dotfiles`
- Bound to `Alt+f` in zsh
- Uses `$NVIM_APPNAME` and `$XDG_CONFIG_HOME` for portability

**enable_portkey** - Sources Portkey configuration for Claude Code

## Installation and Management

### Initial Setup

**Interactive installation:**
```bash
cd ~/.dotfiles
./install.sh
```

The script will:
- Check prerequisites (Homebrew, GNU Stow)
- Initialize git submodules
- Offer to install packages interactively
- Back up existing configurations

**Using Makefile:**
```bash
make install        # Run install.sh
make stow-core      # Stow essential packages (zsh, git, tmux, scripts)
make stow-optional  # Stow optional packages (alacritty, lazyvim, etc.)
make stow-zsh       # Stow specific package
```

### Managing Packages

**Stow operations:**
```bash
# Manual stow
stow <package-name>     # e.g., stow zsh

# Using Makefile (recommended)
make stow-zsh           # Stow package
make unstow-zsh         # Unstow package
make restow-zsh         # Restow (force update)
make stow-all           # Stow all packages
```

**Check status:**
```bash
make status             # Show which packages are stowed
make check              # Verify prerequisites
```

### Updating

**Update zsh plugins (git submodules):**
```bash
make update             # Update all submodules
# OR manually:
git submodule update --remote
```

**Sync configuration changes:**
```bash
make restow-<package>   # Restow after editing configs
```

### Adding New Configurations

1. Create directory structure: `<package>/<path-from-home>`
2. Add files in their target location
3. Stow the package: `make stow-<package>` or `stow <package>`
4. Commit to git

### Package Categories

**Core packages** (essential):
- `zsh` - Shell configuration
- `git` - Git configuration
- `tmux` - Terminal multiplexer
- `scripts` - Utility scripts

**Optional packages**:
- `alacritty` - Terminal emulator
- `lazyvim` - Neovim configuration
- `hammerspoon` - macOS automation
- `karabiner` - Keyboard customization

**Rarely used** (kept for special cases):
- `nvim` - Alternative Neovim config
- `vim` - Fallback Vim config
- `asdf` - Legacy version manager

## Important Context

### Work Environment
- **Organization**: Yale University
- **Primary project**: YaleSites (Drupal 10, Lando, Pantheon)
- **Repositories**: Multi-repo structure (main project + atomic + component-library-twig)
- **Branching**: YSP-### pattern for issues

### Development Tools
- **Containerization**: Lando (Docker-based local development, works on macOS and Linux)
- **Hosting**: Pantheon (uses Terminus CLI)
- **Version control**: Git with SSH signing (gpgsign enabled, SSH format)
- **Database**:
  - **macOS**: MySQL 8.4 client via Homebrew (aliased as mysql8 in env.darwin.zsh)
  - **Linux**: mysql-client via apt (packages.linux.txt)

### File Modifications

When modifying configuration files:

1. **Edit the source** in `~/.dotfiles/<package>/` (not the symlink in `~`)
2. **Test locally** - changes take effect immediately via symlinks
3. **Restow if needed** - `make restow-<package>` if structure changed
4. **Commit changes** - use conventional commits format
5. **Never commit** `.local` files or sensitive data
6. **Preserve existing patterns** - extensive customization exists for specific workflows
7. **Cross-platform compatibility** - use wrapper functions (clipboard_copy, open_file) instead of platform-specific commands
8. **Platform-specific code** - place in `env.darwin.zsh` or `env.linux.zsh`, not in shared modules

### Git Submodules (ZSH Plugins)

Plugins are managed as submodules in `zsh/.config/zsh/`:
- Located in `.gitmodules` file
- Update with `make update` or `git submodule update --remote`
- Don't modify plugin code directly (it's external)
- Pin to specific commits by committing submodule pointer changes

### Color Scheme
Consistent **TokyoNight** theme across Alacritty, tmux, and Neovim.
