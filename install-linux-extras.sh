#!/usr/bin/env bash
#
# install-linux-extras.sh
#
# Automates installation of tools that require manual steps on Linux:
# - eza (modern ls replacement)
# - mise (runtime version manager)
# - Nerd Fonts (CaskaydiaMono for terminal)
# - Lando (local development environment)
# - Alacritty (GPU-accelerated terminal emulator)
#
# Usage: ./install-linux-extras.sh [options]
#
# Options:
#   --all          Install all extras (default if no options)
#   --eza          Install eza only
#   --mise         Install mise only
#   --fonts        Install Nerd Fonts only
#   --lando        Install Lando only
#   --alacritty    Install Alacritty only
#   --help         Show this help message

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Flags for what to install
INSTALL_ALL=true
INSTALL_EZA=false
INSTALL_MISE=false
INSTALL_FONTS=false
INSTALL_LANDO=false
INSTALL_ALACRITTY=false

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --all)
            INSTALL_ALL=true
            shift
            ;;
        --eza)
            INSTALL_ALL=false
            INSTALL_EZA=true
            shift
            ;;
        --mise)
            INSTALL_ALL=false
            INSTALL_MISE=true
            shift
            ;;
        --fonts)
            INSTALL_ALL=false
            INSTALL_FONTS=true
            shift
            ;;
        --lando)
            INSTALL_ALL=false
            INSTALL_LANDO=true
            shift
            ;;
        --alacritty)
            INSTALL_ALL=false
            INSTALL_ALACRITTY=true
            shift
            ;;
        --help)
            grep '^#' "$0" | grep -v '#!/usr/bin/env' | sed 's/^# \?//'
            exit 0
            ;;
        *)
            echo -e "${RED}Unknown option: $1${NC}"
            echo "Use --help for usage information"
            exit 1
            ;;
    esac
done

# Helper functions
print_header() {
    echo -e "\n${BLUE}==>${NC} $1"
}

print_success() {
    echo -e "  ${GREEN}✓${NC} $1"
}

print_error() {
    echo -e "  ${RED}✗${NC} $1"
}

print_warning() {
    echo -e "  ${YELLOW}⚠${NC} $1"
}

print_info() {
    echo -e "  ${BLUE}ℹ${NC} $1"
}

command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Wrapper for curl with timeouts and retry logic
curl_with_retry() {
    local url="$1"
    local output="$2"
    local max_attempts=3
    local timeout=10
    local max_time=60
    local attempt=1

    while [[ $attempt -le $max_attempts ]]; do
        if [[ -n "$output" ]]; then
            if curl --connect-timeout "$timeout" --max-time "$max_time" -fsSL "$url" -o "$output"; then
                return 0
            fi
        else
            if curl --connect-timeout "$timeout" --max-time "$max_time" -fsSL "$url"; then
                return 0
            fi
        fi

        if [[ $attempt -lt $max_attempts ]]; then
            print_warning "Download attempt $attempt failed, retrying in $((attempt * 2)) seconds..."
            sleep $((attempt * 2))
        fi
        ((attempt++))
    done

    print_error "Failed to download after $max_attempts attempts: $url"
    return 1
}

# Check OS
if [[ "$(uname -s)" != "Linux" ]]; then
    print_error "This script is for Linux only"
    print_info "Use Homebrew on macOS: brew bundle"
    exit 1
fi

# Detect Linux distribution
if [[ -f /etc/os-release ]]; then
    # shellcheck source=/dev/null
    source /etc/os-release
    DISTRO_NAME="${NAME:-Unknown}"
    DISTRO_ID="${ID:-unknown}"
    print_info "Detected: $DISTRO_NAME"
else
    print_warning "Cannot detect Linux distribution"
    DISTRO_ID="unknown"
fi

# Check for sudo
if ! command_exists sudo; then
    print_error "sudo is required but not installed"
    exit 1
fi

# Main installation banner
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo -e "${BLUE}Linux Extras Installer${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# =============================================================================
# Install eza (modern ls replacement)
# =============================================================================

install_eza() {
    print_header "Installing eza"

    if command_exists eza; then
        print_success "eza already installed ($(eza --version | head -n1))"
        return 0
    fi

    # Try different installation methods based on distro
    case "$DISTRO_ID" in
        ubuntu|debian|pop)
            # Check Ubuntu version for native package
            if [[ -n "${VERSION_ID:-}" ]] && (( $(echo "$VERSION_ID >= 24.04" | bc -l) )); then
                print_info "Installing via apt (Ubuntu 24.04+)"
                sudo apt update
                sudo apt install -y eza
            else
                # Use cargo for older versions
                if command_exists cargo; then
                    print_info "Installing via cargo"
                    cargo install eza
                    print_info "Add ~/.cargo/bin to PATH if not already present"
                else
                    print_warning "cargo not found, trying GitHub releases..."
                    install_eza_from_github
                fi
            fi
            ;;
        *)
            if command_exists cargo; then
                print_info "Installing via cargo"
                cargo install eza
                print_info "Add ~/.cargo/bin to PATH if not already present"
            else
                print_warning "cargo not found, trying GitHub releases..."
                install_eza_from_github
            fi
            ;;
    esac

    if command_exists eza; then
        print_success "eza installed successfully"
    else
        print_error "Failed to install eza"
        return 1
    fi
}

install_eza_from_github() {
    print_info "Downloading eza from GitHub releases"

    local arch
    arch=$(uname -m)
    local eza_arch

    case "$arch" in
        x86_64) eza_arch="x86_64" ;;
        aarch64) eza_arch="aarch64" ;;
        *)
            print_error "Unsupported architecture: $arch"
            return 1
            ;;
    esac

    local latest_url
    latest_url=$(curl_with_retry https://api.github.com/repos/eza-community/eza/releases/latest | \
                 grep "browser_download_url.*eza_${eza_arch}-unknown-linux-gnu.tar.gz" | \
                 cut -d '"' -f 4)

    if [[ -z "$latest_url" ]]; then
        print_error "Could not find download URL"
        return 1
    fi

    local temp_dir
    temp_dir=$(mktemp -d)
    cd "$temp_dir" || return 1

    curl_with_retry "$latest_url" "eza.tar.gz" || {
        cd - > /dev/null
        rm -rf "$temp_dir"
        return 1
    }
    tar xzf eza.tar.gz
    sudo mv eza /usr/local/bin/
    sudo chmod +x /usr/local/bin/eza

    cd - > /dev/null || return 1
    rm -rf "$temp_dir"

    print_success "eza installed to /usr/local/bin/eza"
}

# =============================================================================
# Install mise (runtime version manager)
# =============================================================================

install_mise() {
    print_header "Installing mise"

    if command_exists mise; then
        print_success "mise already installed ($(mise --version))"
        return 0
    fi

    print_info "Installing mise via official installer"

    # Use mise's official install script
    if ! curl_with_retry https://mise.run | sh; then
        print_error "Failed to install mise"
        return 1
    fi

    # Add to PATH for current session
    export PATH="$HOME/.local/bin:$PATH"

    if command_exists mise; then
        print_success "mise installed successfully"
        print_info "Restart your shell or run: source ~/.zshrc"
    else
        print_error "Failed to install mise"
        return 1
    fi
}

# =============================================================================
# Install Nerd Fonts
# =============================================================================

install_fonts() {
    print_header "Installing Nerd Fonts"

    local fonts_dir="$HOME/.local/share/fonts"
    mkdir -p "$fonts_dir"

    if fc-list | grep -qi "CaskaydiaMono Nerd Font"; then
        print_success "CaskaydiaMono Nerd Font already installed"
        return 0
    fi

    print_info "Downloading CaskaydiaMono Nerd Font"

    local font_url="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/CascadiaMono.zip"
    local temp_dir
    temp_dir=$(mktemp -d)

    cd "$temp_dir" || return 1

    if ! curl_with_retry "$font_url" "CascadiaMono.zip"; then
        cd - > /dev/null
        rm -rf "$temp_dir"
        return 1
    fi

    if [[ ! -f CascadiaMono.zip ]]; then
        print_error "Failed to download font"
        cd - > /dev/null || return 1
        rm -rf "$temp_dir"
        return 1
    fi

    unzip -q CascadiaMono.zip -d CascadiaMono
    cp CascadiaMono/*.ttf "$fonts_dir/"

    cd - > /dev/null || return 1
    rm -rf "$temp_dir"

    # Refresh font cache
    if command_exists fc-cache; then
        fc-cache -f "$fonts_dir"
        print_success "CaskaydiaMono Nerd Font installed"
    else
        print_warning "fc-cache not found, font cache not refreshed"
        print_info "Install fontconfig: sudo apt install fontconfig"
    fi
}

# =============================================================================
# Install Lando
# =============================================================================

install_lando() {
    print_header "Installing Lando"

    if command_exists lando; then
        print_success "Lando already installed ($(lando version))"
        return 0
    fi

    # Check for Docker first
    if ! command_exists docker; then
        print_error "Docker is required but not installed"
        print_info "Install Docker first: https://docs.docker.com/engine/install/"
        return 1
    fi

    print_info "Downloading Lando .deb package"

    local arch
    arch=$(uname -m)
    local lando_arch

    case "$arch" in
        x86_64) lando_arch="x64" ;;
        aarch64) lando_arch="arm64" ;;
        *)
            print_error "Unsupported architecture: $arch"
            return 1
            ;;
    esac

    # Get latest release
    local latest_version
    latest_version=$(curl_with_retry https://api.github.com/repos/lando/lando/releases/latest | \
                     grep '"tag_name"' | sed -E 's/.*"v([^"]+)".*/\1/')

    if [[ -z "$latest_version" ]]; then
        print_error "Could not determine latest Lando version"
        return 1
    fi

    local download_url="https://github.com/lando/lando/releases/download/v${latest_version}/lando-${lando_arch}-v${latest_version}.deb"

    local temp_dir
    temp_dir=$(mktemp -d)
    cd "$temp_dir" || return 1

    if ! curl_with_retry "$download_url" "lando.deb"; then
        cd - > /dev/null
        rm -rf "$temp_dir"
        return 1
    fi

    if [[ ! -f lando.deb ]]; then
        print_error "Failed to download Lando"
        cd - > /dev/null || return 1
        rm -rf "$temp_dir"
        return 1
    fi

    print_info "Installing Lando .deb package"
    sudo dpkg -i lando.deb

    # Fix any dependency issues
    sudo apt-get install -f -y

    cd - > /dev/null || return 1
    rm -rf "$temp_dir"

    if command_exists lando; then
        print_success "Lando installed successfully"
    else
        print_error "Failed to install Lando"
        return 1
    fi
}

# =============================================================================
# Install Alacritty
# =============================================================================

install_alacritty() {
    print_header "Installing Alacritty"

    if command_exists alacritty; then
        print_success "Alacritty already installed ($(alacritty --version))"
        return 0
    fi

    # Try different methods based on distro
    case "$DISTRO_ID" in
        ubuntu|debian|pop)
            # Try PPA first (Ubuntu 20.04+)
            if [[ -n "${VERSION_ID:-}" ]] && (( $(echo "$VERSION_ID >= 20.04" | bc -l) )); then
                print_info "Installing via PPA"
                sudo add-apt-repository -y ppa:aslatter/ppa
                sudo apt update
                sudo apt install -y alacritty
            else
                print_info "Trying snap installation"
                if command_exists snap; then
                    sudo snap install alacritty --classic
                else
                    print_warning "snap not available, install from source"
                    print_info "See: https://github.com/alacritty/alacritty/blob/master/INSTALL.md"
                    return 1
                fi
            fi
            ;;
        *)
            if command_exists snap; then
                print_info "Installing via snap"
                sudo snap install alacritty --classic
            else
                print_warning "Unsupported distro for automated install"
                print_info "See: https://github.com/alacritty/alacritty/blob/master/INSTALL.md"
                return 1
            fi
            ;;
    esac

    if command_exists alacritty; then
        print_success "Alacritty installed successfully"
    else
        print_error "Failed to install Alacritty"
        return 1
    fi
}

# =============================================================================
# Main installation logic
# =============================================================================

# Set individual flags if --all is true
if [[ "$INSTALL_ALL" == true ]]; then
    INSTALL_EZA=true
    INSTALL_MISE=true
    INSTALL_FONTS=true
    INSTALL_LANDO=true
    INSTALL_ALACRITTY=true
fi

# Track failures
FAILURES=0

# Install requested components
if [[ "$INSTALL_EZA" == true ]]; then
    install_eza || ((FAILURES++))
fi

if [[ "$INSTALL_MISE" == true ]]; then
    install_mise || ((FAILURES++))
fi

if [[ "$INSTALL_FONTS" == true ]]; then
    install_fonts || ((FAILURES++))
fi

if [[ "$INSTALL_LANDO" == true ]]; then
    install_lando || ((FAILURES++))
fi

if [[ "$INSTALL_ALACRITTY" == true ]]; then
    install_alacritty || ((FAILURES++))
fi

# Summary
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
if [[ $FAILURES -eq 0 ]]; then
    echo -e "${GREEN}Installation completed successfully!${NC}"
else
    echo -e "${YELLOW}Installation completed with $FAILURES failure(s)${NC}"
    echo "Review the output above for details"
fi
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

if [[ $FAILURES -gt 0 ]]; then
    exit 1
fi
