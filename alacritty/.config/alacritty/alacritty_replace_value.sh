#!/bin/bash

# Specify the path to the alacritty.yml file
config_file="$HOME/.config/alacritty/alacritty.yml"

# Backup the original file
cp "$config_file" "$config_file.bak"

# Use awk to replace the opacity value
awk '/opacity: 1.0/ { $0="opacity: 0.85" } { print }' "$config_file" > "$config_file.tmp" && mv "$config_file.tmp" "$config_file"

echo "Opacity value replaced successfully."

