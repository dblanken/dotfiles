export BASH_SILENCE_DEPRECATION_WARNING=1

# =============================================================================
# Platform Detection
# =============================================================================

# Detect operating system early for conditional configuration
export OS_TYPE="unknown"
case "$(uname -s)" in
    Darwin)
        OS_TYPE="darwin"
        ;;
    Linux)
        OS_TYPE="linux"
        ;;
esac

# =============================================================================
# XDG Base Directory Specification
# =============================================================================

# https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html
# These paths work across all platforms
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_STATE_HOME="$HOME/.local/state"

# =============================================================================
# Homebrew (macOS only)
# =============================================================================

# Set PATH, MANPATH, etc., for Homebrew (macOS package manager)
if [ "$OS_TYPE" = "darwin" ]; then
  export BREW_LOCATION="/opt/homebrew/bin/brew"

  if [[ $(command -v "$BREW_LOCATION") == "" ]]; then
    export BREW_LOCATION="/usr/local/bin/brew"
  fi

  if [[ $(command -v "$BREW_LOCATION") == "" ]]; then
    unset BREW_LOCATION
    echo "Homebrew is not detected or installed."
  fi

  if [[ -n "$BREW_LOCATION" ]]; then
    eval "$($BREW_LOCATION shellenv)"
  fi
fi

export THOR_MERGE='nvim -d'

if [[ -f "$HOME/.zprofile.local" ]]; then
	source ~/.zprofile.local
fi

# Switch Alacritty theme (only once per login session)
if [[ -f "$HOME/.config/alacritty/switch-alacritty-theme.sh" ]]; then
	$HOME/.config/alacritty/switch-alacritty-theme.sh
fi

# Added by OrbStack: command-line tools and integration
# This won't be added again if you remove it.
source ~/.orbstack/shell/init.zsh 2>/dev/null || :
