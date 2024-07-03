#!/bin/bash

# Specify the path to the alacritty.yml file
config_file="$HOME/.config/alacritty/alacritty.toml"
replace_value="${2:-1.0}"
search_value="${1:-0.85}"

# Backup the original file
cp "$config_file" "$config_file.bak"

# Use awk to replace the opacity value
awk -v search="opacity = $search_value" -v replace="opacity = $replace_value" '$0 ~ search {gsub(search, replace)}1' "$config_file.bak" >"$config_file"

echo "Opacity value replaced successfully."
