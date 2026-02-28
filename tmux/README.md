# Tmux Configuration

Clean, optimized tmux configuration managed via GNU Stow.

## Features

- **Prefix**: `Ctrl+Space` (more ergonomic than Ctrl+b)
- **Color Scheme**: TokyoNight with custom status line
- **Vi Mode**: Full vi keybindings in copy mode
- **Smart Navigation**: Seamless movement between tmux panes and vim splits
- **Session Persistence**: Auto-save and restore with tmux-resurrect/continuum
- **Mouse Support**: Full mouse integration
- **Clipboard Integration**: Copy to macOS clipboard with pbcopy

## Installation

### Prerequisites

```bash
# Ensure tmux is installed (version 3.2+)
brew install tmux

# Ensure you have bc for version comparison
brew install bc
```

### Setup

1. **Stow the configuration** (from dotfiles directory):
   ```bash
   cd ~/.dotfiles
   stow tmux
   ```

2. **Install TPM** (if not already installed):
   ```bash
   git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
   ```

3. **Start tmux**:
   ```bash
   tmux
   ```

4. **Install plugins**:
   Press `Ctrl+Space` then `I` (capital i) to install all plugins via TPM.

## Installed Plugins

- **tmux-sensible**: Sensible tmux defaults
- **tmux-copycat**: Enhanced search in copy mode
- **tmux-cpu**: CPU usage display in status line
- **tmux-resurrect**: Save and restore tmux sessions
- **tmux-continuum**: Automatic session saving (every 15 min)
- **vim-tmux-navigator**: Seamless vim-tmux navigation

## Key Bindings

### Prefix Key
- `Ctrl+Space` - Prefix key

### Sessions
- `Prefix Ctrl+Space` - Switch to last session

### Windows
- `Prefix c` - New window (in current path)
- `Prefix ,` - Rename window
- `Prefix <` / `>` - Move window left/right
- `Prefix 1-9` - Switch to window by number

### Panes
- `Prefix %` or `|` or `\` - Split horizontally
- `Prefix "` or `-` - Split vertically
- `Prefix h/j/k/l` - Move between panes (vim-style)
- `Ctrl+h/j/k/l` - Move between panes/vim splits (no prefix needed!)
- `Prefix p` - Restore previous layout
- `Prefix z` - Toggle pane zoom
- `Prefix q` - Show pane numbers

### Copy Mode
- `Prefix Escape` or `Prefix b` - Enter copy mode
- `v` - Begin selection (in copy mode)
- `y` - Copy selection
- `Enter` - Copy and exit copy mode
- `/` - Search forward (incremental)
- `?` - Search backward (incremental)
- `Escape` - Exit copy mode

### Mouse
- Click to select pane
- Drag to resize panes
- Scroll to navigate history
- Double-click to select word
- Triple-click to select line

### Utility
- `Prefix r` - Reload configuration
- `Prefix Ctrl+l` - Clear pane history
- `Prefix t` - Show clock

### TPM (Plugin Manager)
- `Prefix I` - Install plugins
- `Prefix U` - Update plugins
- `Prefix Alt+u` - Uninstall/remove plugins

## Session Persistence

Sessions are automatically saved every 15 minutes via tmux-continuum.

### Manual Controls
- Sessions are restored automatically when tmux starts
- Last saved session includes window layouts, programs, and working directories

### What's Persisted
- Window/pane layouts
- Working directories
- Running programs (partial support)
- Vim sessions (with resurrect-vim plugin)

## Customization

Edit `~/.dotfiles/tmux/.tmux.conf` and reload with `Prefix r`.

### Common Customizations

**Change prefix key**:
```tmux
set-option -g prefix C-a
```

**Add CPU to status line**:
```tmux
set-option -g status-right "CPU: #{cpu_percentage} | %Y-%m-%d %I:%M %p | #h"
```

**Disable automatic session restore**:
```tmux
set-option -g @continuum-restore 'off'
```

## Troubleshooting

### Colors look wrong
Ensure your terminal supports true color:
```bash
# Check TERM variable
echo $TERM  # Should be tmux-256color inside tmux

# Test true color support
awk 'BEGIN{
    s="/\\/\\/\\/\\/\\"; s=s s s s s s s s;
    for (colnum = 0; colnum<77; colnum++) {
        r = 255-(colnum*255/76);
        g = (colnum*510/76);
        b = (colnum*255/76);
        if (g>255) g = 510-g;
        printf "\033[48;2;%d;%d;%dm", r,g,b;
        printf "\033[38;2;%d;%d;%dm", 255-r,255-g,255-b;
        printf "%s\033[0m", substr(s,colnum+1,1);
    }
    printf "\n";
}'
```

### Plugins not loading
1. Verify TPM is installed: `ls ~/.tmux/plugins/tpm`
2. Reload config: `Prefix r`
3. Install plugins: `Prefix I`

### Vim-tmux navigation not working
1. Ensure vim has the matching plugin installed
2. Check that `bc` command is available: `which bc`
3. Verify tmux version: `tmux -V` (need 3.0+)

## File Structure

```
~/.dotfiles/tmux/
├── .tmux.conf          # Main configuration (symlinked to ~/.tmux.conf)
└── README.md           # This file

~/.tmux/
└── plugins/
    └── tpm/            # Tmux Plugin Manager
    └── [plugins...]    # Installed plugins
```

## Backups

Old configurations backed up to:
- `~/.tmux.backup-YYYYMMDD-HHMMSS/` - Previous oh-my-tmux setup
- `~/.tmux.conf.local.backup-YYYYMMDD-HHMMSS` - Previous local config

## Resources

- [Tmux Manual](https://man.openbsd.org/tmux)
- [TPM Documentation](https://github.com/tmux-plugins/tpm)
- [TokyoNight Theme](https://github.com/folke/tokyonight.nvim)
- [Vim-Tmux Navigator](https://github.com/christoomey/vim-tmux-navigator)
