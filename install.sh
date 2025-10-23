#!/usr/bin/env bash
#
# Bootstrap script for dotfiles installation
# Usage: ./install.sh

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Dotfiles directory
DOTFILES_DIR="$HOME/.dotfiles"

# Print functions
print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_header() {
    echo -e "\n${BLUE}==>${NC} ${1}"
}

# Check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Ask yes/no question
ask_yes_no() {
    while true; do
        read -p "$1 (y/n) " -n 1 -r
        echo
        case $REPLY in
            [Yy]* ) return 0;;
            [Nn]* ) return 1;;
            * ) echo "Please answer yes (y) or no (n).";;
        esac
    done
}

# Backup existing file/directory
backup_if_exists() {
    local target="$1"
    if [ -e "$target" ] && [ ! -L "$target" ]; then
        local backup="${target}.backup.$(date +%Y%m%d_%H%M%S)"
        print_warning "Backing up existing $target to $backup"
        mv "$target" "$backup"
        return 0
    fi
    return 1
}

# Stow a package
stow_package() {
    local package="$1"
    local package_dir="$DOTFILES_DIR/$package"

    if [ ! -d "$package_dir" ]; then
        print_error "Package directory $package does not exist"
        return 1
    fi

    print_info "Stowing $package..."

    # Check for conflicts first
    if stow -n -d "$DOTFILES_DIR" -t "$HOME" "$package" 2>&1 | grep -q "existing target"; then
        print_warning "Conflicts detected for $package"
        if ask_yes_no "  Backup existing files and continue?"; then
            # Extract conflicting files and backup
            local conflicts=$(stow -n -d "$DOTFILES_DIR" -t "$HOME" "$package" 2>&1 | grep "existing target" | awk '{print $NF}' || true)
            for conflict in $conflicts; do
                backup_if_exists "$HOME/$conflict"
            done
        else
            print_warning "Skipping $package"
            return 1
        fi
    fi

    # Actually stow the package
    if stow -d "$DOTFILES_DIR" -t "$HOME" "$package" 2>/dev/null; then
        print_success "Stowed $package"
        return 0
    else
        print_error "Failed to stow $package"
        return 1
    fi
}

# Main installation
main() {
    clear
    echo -e "${BLUE}"
    cat << "EOF"
    ____        __  _____ __
   / __ \____  / /_/ __(_) /__  _____
  / / / / __ \/ __/ /_/ / / _ \/ ___/
 / /_/ / /_/ / /_/ __/ / /  __(__  )
/_____/\____/\__/_/ /_/_/\___/____/

EOF
    echo -e "${NC}"
    echo "Personal dotfiles installer"
    echo "This will install dotfiles to $HOME"
    echo

    # Check if we're in the right directory
    if [ ! -f "$DOTFILES_DIR/install.sh" ]; then
        print_error "Please run this script from the dotfiles directory"
        exit 1
    fi

    # Check prerequisites
    print_header "Checking prerequisites"

    # Check for macOS
    if [[ "$(uname)" != "Darwin" ]]; then
        print_error "This script is designed for macOS"
        exit 1
    fi
    print_success "Running on macOS"

    # Check for Homebrew
    if ! command_exists brew; then
        print_error "Homebrew is not installed"
        print_info "Install from: https://brew.sh"
        exit 1
    fi
    print_success "Homebrew is installed"

    # Check for GNU Stow
    if ! command_exists stow; then
        print_error "GNU Stow is not installed"
        if ask_yes_no "Would you like to install it with Homebrew?"; then
            brew install stow
            print_success "Installed GNU Stow"
        else
            print_error "GNU Stow is required for installation"
            exit 1
        fi
    else
        print_success "GNU Stow is installed"
    fi

    # Initialize git submodules
    print_header "Initializing git submodules (zsh plugins)"
    if git submodule status | grep -q "^-"; then
        print_info "Initializing submodules..."
        git submodule update --init --recursive
        print_success "Submodules initialized"
    else
        print_success "Submodules already initialized"
    fi

    # Install packages
    print_header "Installing packages"
    echo

    # Core packages (recommended for everyone)
    local core_packages=(
        "zsh:Shell configuration with plugins and YaleSites utilities"
        "git:Git configuration and global gitignore"
        "tmux:Terminal multiplexer with vim integration"
        "scripts:Utility scripts (tmux-sessionizer, etc.)"
    )

    # Optional packages
    local optional_packages=(
        "alacritty:Terminal emulator configuration"
        "lazyvim:Neovim LazyVim configuration"
        "hammerspoon:macOS automation (requires Hammerspoon app)"
        "karabiner:Keyboard customization (requires Karabiner-Elements)"
    )

    # Rarely used packages
    local rare_packages=(
        "nvim:Alternative Neovim configuration"
        "vim:Fallback vim configuration"
        "asdf:Legacy version manager configuration (now using mise)"
    )

    # Install core packages
    print_info "Core packages (recommended):"
    for package_info in "${core_packages[@]}"; do
        IFS=':' read -r package desc <<< "$package_info"
        echo "  • $package - $desc"
    done
    echo

    if ask_yes_no "Install all core packages?"; then
        for package_info in "${core_packages[@]}"; do
            IFS=':' read -r package desc <<< "$package_info"
            stow_package "$package"
        done
    else
        for package_info in "${core_packages[@]}"; do
            IFS=':' read -r package desc <<< "$package_info"
            if ask_yes_no "Install $package ($desc)?"; then
                stow_package "$package"
            fi
        done
    fi

    echo
    print_info "Optional packages:"
    for package_info in "${optional_packages[@]}"; do
        IFS=':' read -r package desc <<< "$package_info"
        echo "  • $package - $desc"
    done
    echo

    if ask_yes_no "Would you like to install optional packages?"; then
        for package_info in "${optional_packages[@]}"; do
            IFS=':' read -r package desc <<< "$package_info"
            if ask_yes_no "Install $package?"; then
                stow_package "$package"
            fi
        done
    fi

    # Rarely used packages
    if ask_yes_no "Show rarely used packages (vim, nvim, asdf)?"; then
        for package_info in "${rare_packages[@]}"; do
            IFS=':' read -r package desc <<< "$package_info"
            if ask_yes_no "Install $package ($desc)?"; then
                stow_package "$package"
            fi
        done
    fi

    # Post-installation
    print_header "Post-installation"

    # Check for base16-shell
    if [ ! -d "$HOME/.config/base16-shell" ]; then
        print_warning "base16-shell not found (referenced in .zshrc)"
        print_info "TokyoNight theme is active, base16 may not be needed"
    fi

    # Recommend packages to install
    print_header "Recommended software"
    echo
    echo "Consider installing these via Homebrew:"
    echo
    echo "Essential:"
    echo "  brew install neovim tmux fzf ripgrep fd bat"
    echo
    echo "Fonts:"
    echo "  brew install --cask font-cascadia-code-nf"
    echo
    echo "Optional:"
    echo "  brew install --cask alacritty"
    echo "  brew install eza mise"
    echo

    # Success message
    print_header "Installation complete!"
    print_success "Dotfiles have been installed"
    echo
    print_info "Next steps:"
    echo "  1. Restart your shell or run: source ~/.zshrc"
    echo "  2. Install recommended software (see above)"
    echo "  3. Create ~/.zprofile.local for machine-specific settings"
    echo "  4. Customize configurations as needed"
    echo
    print_info "For more information, see: $DOTFILES_DIR/README.md"
}

main "$@"
