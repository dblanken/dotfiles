#!/bin/bash

THEME=`ls -la $HOME/.base16_theme | awk '{print $11}' | awk -F- '{print $3}' | awk -F. '{print $1}'`

if [ $THEME = "gruvbox" ]; then
  THEME="gruvbox_dark_hard"
fi

echo $THEME
