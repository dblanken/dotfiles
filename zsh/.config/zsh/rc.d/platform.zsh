# Cross-platform utility functions and wrappers
#
# This module provides wrapper functions for platform-specific commands
# to ensure dotfiles work on both macOS and Linux.
#
# Note: OS_TYPE should be set in .zprofile before this module is loaded.
# If not set, we'll detect it here as a fallback.

# Validate OS_TYPE is set (should come from .zprofile)
if [[ -z "${OS_TYPE:-}" ]]; then
    echo "Warning: OS_TYPE not set in .zprofile, detecting now..." >&2
    export OS_TYPE="unknown"
    case "$(uname -s)" in
        Darwin)
            OS_TYPE="darwin"
            ;;
        Linux)
            OS_TYPE="linux"
            ;;
        *)
            OS_TYPE="unknown"
            ;;
    esac
fi

# =============================================================================
# Clipboard Operations
# =============================================================================

# Copy to clipboard (cross-platform)
# Usage: echo "text" | clipboard_copy
clipboard_copy() {
    if [ "$OS_TYPE" = "darwin" ]; then
        pbcopy
    elif [ "$OS_TYPE" = "linux" ]; then
        # Try multiple clipboard utilities (different ones for X11 vs Wayland)
        if command -v xclip &> /dev/null; then
            xclip -selection clipboard
        elif command -v xsel &> /dev/null; then
            xsel --clipboard --input
        elif command -v wl-copy &> /dev/null; then
            wl-copy
        else
            echo "Error: No clipboard utility found. Install xclip, xsel, or wl-clipboard" >&2
            return 1
        fi
    else
        echo "Error: Clipboard not supported on $OS_TYPE" >&2
        return 1
    fi
}

# Paste from clipboard (cross-platform)
# Usage: clipboard_paste
clipboard_paste() {
    if [ "$OS_TYPE" = "darwin" ]; then
        pbpaste
    elif [ "$OS_TYPE" = "linux" ]; then
        # Try multiple clipboard utilities (different ones for X11 vs Wayland)
        if command -v xclip &> /dev/null; then
            xclip -selection clipboard -o
        elif command -v xsel &> /dev/null; then
            xsel --clipboard --output
        elif command -v wl-paste &> /dev/null; then
            wl-paste
        else
            echo "Error: No clipboard utility found. Install xclip, xsel, or wl-clipboard" >&2
            return 1
        fi
    else
        echo "Error: Clipboard not supported on $OS_TYPE" >&2
        return 1
    fi
}

# =============================================================================
# File Opening
# =============================================================================

# Open file or URL with default application (cross-platform)
# Usage: open_file <path-or-url>
open_file() {
    if [ $# -eq 0 ]; then
        echo "Usage: open_file <path-or-url>" >&2
        return 1
    fi

    if [ "$OS_TYPE" = "darwin" ]; then
        command open "$@"
    elif [ "$OS_TYPE" = "linux" ]; then
        if command -v xdg-open &> /dev/null; then
            xdg-open "$@" 2>/dev/null &
        else
            echo "Error: xdg-open not found. Install xdg-utils package" >&2
            return 1
        fi
    else
        echo "Error: File opening not supported on $OS_TYPE" >&2
        return 1
    fi
}

# =============================================================================
# Aliases for Backward Compatibility
# =============================================================================

# These aliases allow existing code to use pbcopy/pbpaste/open without changes
alias pbcopy='clipboard_copy'
alias pbpaste='clipboard_paste'
alias open='open_file'

# =============================================================================
# Platform Information Functions
# =============================================================================

# Check if running on macOS
is_macos() {
    [ "$OS_TYPE" = "darwin" ]
}

# Check if running on Linux
is_linux() {
    [ "$OS_TYPE" = "linux" ]
}

# Print platform information
platform_info() {
    echo "OS Type: $OS_TYPE"
    echo "Kernel: $(uname -s)"
    echo "Kernel Version: $(uname -r)"
    echo "Machine: $(uname -m)"

    if is_macos; then
        echo "macOS Version: $(sw_vers -productVersion 2>/dev/null || echo 'Unknown')"
    elif is_linux; then
        if [ -f /etc/os-release ]; then
            echo "Distribution: $(. /etc/os-release && echo "$NAME $VERSION")"
        fi
    fi
}
