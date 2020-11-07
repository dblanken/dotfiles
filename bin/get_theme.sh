ls -la $HOME/.base16_theme | awk '{print $11}' | awk -F- '{print $3}' | awk -F. '{print $1}'
