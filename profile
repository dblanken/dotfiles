# This file is only here because some brain-dead
# applications require it.

if [ -f /etc/profile ]; then
  PATH=""
  source /etc/profile
fi

if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
        . "$HOME/.bashrc"
    fi
fi

export PATH="$HOME/.cargo/bin:$PATH"
