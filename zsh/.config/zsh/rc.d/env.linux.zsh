# Linux-specific environment configuration
#
# This file contains paths, flags, and settings specific to Linux systems.
# It is automatically loaded by .zshrc when OS_TYPE=linux.
# Optimized for Debian/Ubuntu-based distributions (including Pop!_OS).

# =============================================================================
# System package path additions
# =============================================================================

# User-local binaries (for manually installed tools like eza, mise)
export PATH="$HOME/.local/bin:$PATH"

# Cargo binaries (if Rust is installed)
if [ -d "$HOME/.cargo/bin" ]; then
    export PATH="$HOME/.cargo/bin:$PATH"
fi

# =============================================================================
# Package name compatibility aliases
# =============================================================================

# fd-find: Ubuntu/Debian package the binary as 'fdfind'
if command -v fdfind &> /dev/null && ! command -v fd &> /dev/null; then
    alias fd='fdfind'
fi

# bat: Ubuntu/Debian packages the binary as 'batcat'
if command -v batcat &> /dev/null && ! command -v bat &> /dev/null; then
    alias bat='batcat'
fi

# =============================================================================
# MySQL/Database configuration
# =============================================================================

# MySQL client alias (use system version)
if command -v mysql &> /dev/null; then
    alias mysql8='mysql'
fi

# =============================================================================
# Library paths for building packages
# =============================================================================

# Most library paths on Linux are handled by the system package manager
# and pkg-config automatically. Only add custom paths if you've installed
# libraries in non-standard locations.

# Example for manually installed libraries in ~/.local:
# export LD_LIBRARY_PATH="$HOME/.local/lib:$LD_LIBRARY_PATH"
# export PKG_CONFIG_PATH="$HOME/.local/lib/pkgconfig:$PKG_CONFIG_PATH"

# =============================================================================
# Linux-specific environment variables
# =============================================================================

# QT/GTK theme consistency (if using GUI applications)
# Uncomment if you want Qt apps to use GTK theme
# export QT_QPA_PLATFORMTHEME=gtk2

# =============================================================================
# Display/Wayland configuration
# =============================================================================

# Detect if running Wayland
if [ -n "$WAYLAND_DISPLAY" ]; then
    export IS_WAYLAND=1
    # Wayland-specific environment variables if needed
    # export MOZ_ENABLE_WAYLAND=1  # For Firefox
    # export QT_QPA_PLATFORM=wayland  # For Qt applications
fi

# =============================================================================
# Distribution-specific tweaks
# =============================================================================

# Detect distribution (cached to avoid re-sourcing /etc/os-release every shell)
if [[ -z "$DISTRO_ID" ]] && [[ -f /etc/os-release ]]; then
    . /etc/os-release
    export DISTRO_ID="$ID"
    export DISTRO_VERSION="$VERSION_ID"
    export DISTRO_NAME="$NAME"
fi

# Distribution-specific configuration
if [[ -n "$DISTRO_ID" ]]; then
    # Pop!_OS specific configuration
    if [[ "$DISTRO_ID" = "pop" ]]; then
        # Add Pop!_OS specific tweaks here
        :
        export SUDO_ASKPASS="$(getent passwd "$(id -u)" | cut -d: -f6)/code/system/secure-askpass/askpass"
    fi

    # Ubuntu specific configuration
    if [[ "$DISTRO_ID" = "ubuntu" ]]; then
        # Add Ubuntu specific tweaks here
        :
    fi
fi

export VINTAGE_STORY=/games/vintagestory
