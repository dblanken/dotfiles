export BASH_SILENCE_DEPRECATION_WARNING=1

# XDG Base Directory Specification
# https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_STATE_HOME="$HOME/.local/state"

# Set PATH, MANPATH, etc., for Homebrew.
export BREW_LOCATION="/opt/homebrew/bin/brew"

if [[ $(command -v "$BREW_LOCATION") == "" ]]; then
  export BREW_LOCATION="/usr/local/bin/brew"
fi

if [[ $(command -v "$BREW_LOCATION") == "" ]]; then
  unset BREW_LOCATION
  echo "Brew is not detected or installed."
fi

if [[ -n "$BREW_LOCATION" ]]; then
  eval "$($BREW_LOCATION shellenv)"
fi

export THOR_MERGE='nvim -d'

if [[ -f "$HOME/.zprofile.local" ]]; then
	source ~/.zprofile.local
fi

export YALESITES_URL="http://yalesites-mv482-dev.lndo.site"

# Switch Alacritty theme (only once per login session)
if [[ -f "$HOME/.config/alacritty/switch-alacritty-theme.sh" ]]; then
	$HOME/.config/alacritty/switch-alacritty-theme.sh
fi
