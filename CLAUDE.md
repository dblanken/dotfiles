# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a personal dotfiles repository managed with **GNU Stow** for macOS (Darwin). The repository contains configuration files for a development environment centered around terminal-based workflows with tmux, Neovim (LazyVim), Alacritty, and Zsh.

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

### Local Configuration Pattern

Sensitive or machine-specific configs use `.local` suffix:
- `.zprofile.local` - Not in repo, sourced if present (zsh/.zprofile:21-23)
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

- **System packages**: Homebrew (`/opt/homebrew` on Apple Silicon)
- **Runtime versions**: mise (formerly asdf) (zsh/.zshrc:249)
- **Editor**: LazyVim with custom configuration in `lazyvim/.config/lazyvim/`
- **Node versions**: NVM loaded conditionally (zsh/.zshrc:367-369)

### XDG Base Directories

Standard environment variables set in zsh/.zprofile:
- `XDG_CONFIG_HOME` → `~/.config`
- `XDG_DATA_HOME` → `~/.local/share`
- `XDG_CACHE_HOME` → `~/.cache`
- `XDG_STATE_HOME` → `~/.local/state`

## Development Environment

### Shell Configuration (zsh/.zshrc)

**Prompt**: Custom prompt with async git status using zsh-async

**Plugins** (managed as git submodules, lines 277-279):
- `zsh-autosuggestions` - Command suggestions based on history
- `zsh-syntax-highlighting` - Real-time syntax highlighting
- `zsh-history-substring-search` - Better history search
- `zsh-async` - Asynchronous task execution for VCS info

**Vi mode**: Set with `set -o vi` (line 256)

### YaleSites-Specific Workflows

This environment is heavily customized for YaleSites Drupal development (lines 385-725):

**Key functions:**
- `llogin [--copy] [terminus-args]` - Get Drupal login URL (local or remote via Terminus)
- `watchdog [terminus-args]` - Tail Drupal watchdog logs
- `yspull` - Update all three YaleSites repos (project, atomic, component-library-twig)
- `gyst` - Git checkout matching branch across all YaleSites repos
- `gcbcreate` - Create branch in all YaleSites repos
- `dbget [multidev]` - Pull database from Pantheon multidev (defaults to 'dev')
- `dbandfiles [multidev]` - Pull both database and files
- `confim` - Config import followed by cache rebuild
- `local-setup` - Initialize new local YaleSites site
- `siteid <site-name> [-f]` - Get Pantheon site ID with caching

**Lando aliases** (lines 391-398):
- `l` = lando
- `lcr` = lando drush cr
- `ldr` = lando drush
- `lrb` = lando rebuild -y

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

**Copy mode**: Vi keys enabled, clipboard integration with pbcopy

### Terminal (Alacritty)

- **Font**: CaskaydiaMono Nerd Font, 13pt
- **Theme**: TokyoNight (imported from themes/)
- **Window**: No decorations, maximized startup, left Option as Alt

Theme switcher script: `alacritty/.config/alacritty/switch-alacritty-theme.sh` (run automatically in zsh/.zshrc:781)

### Editor (Neovim/LazyVim)

**Active config**: LazyVim via `NVIM_APPNAME=lazyvim` (zsh/.zshrc:50)
**Location**: `lazyvim/.config/lazyvim/`
**Structure**: Standard LazyVim structure with custom plugins/ and config/

## Utility Scripts

Located in `scripts/.local/bin/`:

**tmux-sessionizer** - FZF-based tmux session switcher
- Searches `~/code/*` directories
- Includes `~/.config/nvim` and `~/.dotfiles`
- Bound to `Alt+f` in zsh (zsh/.zshrc:381)

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
- **Containerization**: Lando (Docker-based local development)
- **Hosting**: Pantheon (uses Terminus CLI)
- **Version control**: Git with SSH signing (gpgsign enabled, SSH format)
- **Database**: MySQL 8.4 client for Pantheon compatibility (aliased as mysql8)

### File Modifications

When modifying configuration files:

1. **Edit the source** in `~/.dotfiles/<package>/` (not the symlink in `~`)
2. **Test locally** - changes take effect immediately via symlinks
3. **Restow if needed** - `make restow-<package>` if structure changed
4. **Commit changes** - use conventional commits format
5. **Never commit** `.local` files or sensitive data
6. **Preserve existing patterns** - extensive customization exists for specific workflows

### Git Submodules (ZSH Plugins)

Plugins are managed as submodules in `zsh/.config/zsh/`:
- Located in `.gitmodules` file
- Update with `make update` or `git submodule update --remote`
- Don't modify plugin code directly (it's external)
- Pin to specific commits by committing submodule pointer changes

### Color Scheme
Consistent **TokyoNight** theme across Alacritty, tmux, and Neovim.
