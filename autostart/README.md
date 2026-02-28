# Autostart Package

Desktop autostart entries for Linux (GNOME/Pop!_OS) that run automatically on login.

## Contents

### Desktop Entries

- **fix-hdmi-monitor.desktop** - Configures multi-monitor display setup
  - Runs `~/.local/bin/fix-hdmi-monitor.sh` on session startup
  - Configures 3 monitors with custom resolutions and refresh rates
  - Sets primary display and mirror configuration

- **vrr-enable.desktop** - Enables VRR/FreeSync support
  - Runs `~/.local/bin/enable-vrr.sh` on session startup
  - Enables variable refresh rate for gaming monitors
  - Requires compatible AMD/NVIDIA GPU and monitor

## Installation

```bash
make stow-autostart
```

This will symlink the desktop entries to `~/.config/autostart/`.

## Customization

These scripts are hardware-specific. If you have a different monitor setup:

1. Edit the corresponding script in `scripts/.local/bin/`:
   - `fix-hdmi-monitor.sh` - Adjust monitor names, resolutions, and positions
   - `enable-vrr.sh` - Adjust monitor names for VRR capability

2. Test the script manually:
   ```bash
   ~/.local/bin/fix-hdmi-monitor.sh
   ```

3. Restow to update symlinks:
   ```bash
   make restow-scripts
   ```

## Finding Your Monitor Configuration

To find your monitor names and available modes:

```bash
xrandr --query
```

Example output:
```
DisplayPort-0 connected primary 1920x1080+1920+0 (normal left inverted right x axis y axis) 598mm x 336mm
   1920x1080    144.00*+ 119.98   99.93    60.00    59.94
HDMI-A-0 connected 1920x1080+0+0 (normal left inverted right x axis y axis) 598mm x 336mm
   1920x1080     60.00*+  59.94    50.00
```

## Requirements

- X11 display server (not Wayland)
- `xrandr` utility installed
- GNOME or compatible desktop environment

## Platform Compatibility

**Linux only** - These autostart entries are specific to Linux desktop environments using XDG autostart specification.
