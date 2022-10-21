# Add all environment variables brew might need
if [[ $OSTYPE == 'darwin'* ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

# Add my custom commands
export PATH="$HOME/bin:$PATH"
