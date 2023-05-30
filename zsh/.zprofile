export BASH_SILENCE_DEPRECATION_WARNING=1

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
