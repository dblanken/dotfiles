#!/bin/bash

# Script to switch Alacritty Tokyo Night theme based on system dark/light mode
# Cross-platform: macOS (uses defaults) and Linux (defaults to dark theme)
# Usage: ./switch-alacritty-theme.sh [--debug]

set -e

# Check for debug flag
DEBUG=false
if [[ "$1" == "--debug" ]]; then
    DEBUG=true
fi

# Use fixed alacritty config directory
SCRIPT_DIR="$HOME/.config/alacritty"
THEMES_DIR="$SCRIPT_DIR/themes"

# Detect operating system
OS_TYPE="$(uname -s)"

# Check if theme files exist
if [[ ! -f "$THEMES_DIR/tokyonight-day.toml" ]]; then
    [[ "$DEBUG" == true ]] && echo "Error: $THEMES_DIR/tokyonight-day.toml not found"
    exit 1
fi

if [[ ! -f "$THEMES_DIR/tokyonight-night.toml" ]]; then
    [[ "$DEBUG" == true ]] && echo "Error: $THEMES_DIR/tokyonight-night.toml not found"
    exit 1
fi

# Detect system appearance and set theme
if [[ "$OS_TYPE" == "Darwin" ]]; then
    # macOS: Use system preferences to detect dark/light mode
    # defaults returns "Dark" when in dark mode, or nothing/error when in light mode
    APPEARANCE=$(defaults read -g AppleInterfaceStyle 2>/dev/null || echo "Light")

    if [[ "$APPEARANCE" == "Dark" ]]; then
        [[ "$DEBUG" == true ]] && echo "macOS dark mode detected - switching to Tokyo Night dark theme"
        cp "$THEMES_DIR/tokyonight-night.toml" "$THEMES_DIR/tokyonight.toml"
    else
        [[ "$DEBUG" == true ]] && echo "macOS light mode detected - switching to Tokyo Night light theme"
        cp "$THEMES_DIR/tokyonight-day.toml" "$THEMES_DIR/tokyonight.toml"
    fi
else
    # Linux: Default to dark theme (most Linux users prefer dark themes)
    # You can modify this to check GNOME/KDE settings if desired
    [[ "$DEBUG" == true ]] && echo "Linux detected - using Tokyo Night dark theme"
    cp "$THEMES_DIR/tokyonight-night.toml" "$THEMES_DIR/tokyonight.toml"

    # Optional: Check GNOME dark mode preference
    # if command -v gsettings &> /dev/null; then
    #     GNOME_THEME=$(gsettings get org.gnome.desktop.interface color-scheme 2>/dev/null || echo "")
    #     if [[ "$GNOME_THEME" == *"prefer-dark"* ]]; then
    #         cp "$THEMES_DIR/tokyonight-night.toml" "$THEMES_DIR/tokyonight.toml"
    #     else
    #         cp "$THEMES_DIR/tokyonight-day.toml" "$THEMES_DIR/tokyonight.toml"
    #     fi
    # fi
fi

touch "$SCRIPT_DIR/alacritty.toml"

[[ "$DEBUG" == true ]] && echo "Theme switched successfully! Alacritty will reload automatically due to live_config_reload."
