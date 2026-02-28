#!/bin/bash

# Disable all monitors except DisplayPort-0

xrandr --output DisplayPort-1 --off \
       --output HDMI-A-0 --off \
       --output DisplayPort-2 --off
