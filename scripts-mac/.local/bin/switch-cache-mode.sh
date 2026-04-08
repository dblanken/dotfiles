#!/bin/bash

set -x

# Script to switch between development and multidev-like caching modes

SITES_DIR="web/sites/default"
CURRENT_SETTINGS="$SITES_DIR/settings.local.php"
DEV_SETTINGS="$HOME/.ys_scripts/settings.local.dev.php"
MULTIDEV_SETTINGS="$HOME/.ys_scripts/settings.local.multidev.php"

show_usage() {
    echo "Usage: $0 [dev|multidev|status]"
    echo ""
    echo "Modes:"
    echo "  dev       - Full development mode (no caching, fastest development)"
    echo "  multidev  - Multidev-like mode (caching enabled, matches Pantheon multidev)"
    echo "  status    - Show current mode"
    echo ""
    echo "Examples:"
    echo "  $0 dev       # Switch to development mode"
    echo "  $0 multidev  # Switch to multidev-like mode"
    echo "  $0 status    # Check current mode"
}

check_current_mode() {
    if [[ ! -f "$CURRENT_SETTINGS" ]]; then
        echo "No local settings file found"
        return
    fi
    
    if cmp -s "$CURRENT_SETTINGS" "$DEV_SETTINGS" 2>/dev/null; then
        echo "Current mode: DEVELOPMENT (no caching)"
    elif cmp -s "$CURRENT_SETTINGS" "$MULTIDEV_SETTINGS" 2>/dev/null; then
        echo "Current mode: MULTIDEV (caching enabled)"
    else
        echo "Current mode: CUSTOM (modified settings.local.php)"
    fi
}

switch_mode() {
    local mode="$1"
    
    case "$mode" in
        "dev")
            if [[ ! -f "$DEV_SETTINGS" ]]; then
                echo "Error: $DEV_SETTINGS not found"
                exit 1
            fi
            cp "$DEV_SETTINGS" "$CURRENT_SETTINGS"
            echo "Switched to DEVELOPMENT mode (no caching)"
            ;;
        "multidev")
            if [[ ! -f "$MULTIDEV_SETTINGS" ]]; then
                echo "Error: $MULTIDEV_SETTINGS not found"
                exit 1
            fi
            cp "$MULTIDEV_SETTINGS" "$CURRENT_SETTINGS"
            echo "Switched to MULTIDEV mode (caching enabled)"
            ;;
        *)
            echo "Error: Invalid mode '$mode'"
            show_usage
            exit 1
            ;;
    esac
    
    echo "Clearing Drupal cache..."
    if command -v lando >/dev/null 2>&1; then
        lando drush cr
    else
        echo "Lando not found. Please run 'drush cr' manually."
    fi
    
    echo "Mode switch complete!"
}

# Main script logic
case "${1:-}" in
    "dev"|"multidev")
        switch_mode "$1"
        ;;
    "status")
        check_current_mode
        ;;
    "help"|"-h"|"--help")
        show_usage
        ;;
    "")
        echo "Error: No mode specified"
        echo ""
        show_usage
        exit 1
        ;;
    *)
        echo "Error: Unknown option '$1'"
        echo ""
        show_usage
        exit 1
        ;;
esac
