#!/bin/bash

# Script to switch Alacritty Tokyo Night theme based on macOS dark/light mode
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

# Check if we're on macOS
if [[ "$(uname)" != "Darwin" ]]; then
    [[ "$DEBUG" == true ]] && echo "This script is designed for macOS only."
    exit 1
fi

# Check if theme files exist
if [[ ! -f "$THEMES_DIR/tokyonight-day.toml" ]]; then
    [[ "$DEBUG" == true ]] && echo "Error: $THEMES_DIR/tokyonight-day.toml not found"
    exit 1
fi

if [[ ! -f "$THEMES_DIR/tokyonight-night.toml" ]]; then
    [[ "$DEBUG" == true ]] && echo "Error: $THEMES_DIR/tokyonight-night.toml not found"
    exit 1
fi

# Detect macOS appearance mode
# defaults returns "Dark" when in dark mode, or nothing/error when in light mode
APPEARANCE=$(defaults read -g AppleInterfaceStyle 2>/dev/null || echo "Light")

# Copy the appropriate theme file
if [[ "$APPEARANCE" == "Dark" ]]; then
    [[ "$DEBUG" == true ]] && echo "Dark mode detected - switching to Tokyo Night dark theme"
    cp "$THEMES_DIR/tokyonight-night.toml" "$THEMES_DIR/tokyonight.toml"
else
    [[ "$DEBUG" == true ]] && echo "Light mode detected - switching to Tokyo Night light theme"
    cp "$THEMES_DIR/tokyonight-day.toml" "$THEMES_DIR/tokyonight.toml"
fi
touch "$SCRIPT_DIR/alacritty.toml"

[[ "$DEBUG" == true ]] && echo "Theme switched successfully! Alacritty will reload automatically due to live_config_reload."
