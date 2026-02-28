#!/bin/bash
pactl suspend-sink alsa_output.usb-Kingston_HyperX_Virtual_Surround_Sound_00000000-00.iec958-stereo 1
pactl set-default-sink alsa_output.pci-0000_09_00.1.hdmi-stereo-extra1
echo "Audio switched to HDMI, Kingston suspended"
