# Environment variables and PATH configuration

# Editor
export EDITOR="nvim"
export VISUAL="$EDITOR"

# Less configuration
export LESS="-FXR"
export LESS_TERMCAP_mb="[35m" # magenta
export LESS_TERMCAP_md="[33m" # yellow
export LESS_TERMCAP_me=""      # "0m"
export LESS_TERMCAP_se=""      # "0m"
export LESS_TERMCAP_so="[34m" # blue
export LESS_TERMCAP_ue=""      # "0m"
export LESS_TERMCAP_us="[4m"  # underline

# Git
export GPG_TTY=$(tty)

# Docker
export DOCKER_DEFAULT_PLATFORM=linux/amd64

# PATH additions
export PATH="/opt/homebrew/opt/mysql-client/bin:$PATH"
export PATH="/opt/homebrew/opt/libxml2/bin:$PATH"
export PATH="/opt/homebrew/opt/imagemagick@6/bin:$PATH"
export PATH="$HOME/.cache/lm-studio/bin:$PATH"

# Library flags for building packages
export LDFLAGS="-L/opt/homebrew/opt/libxml2/lib"
export CPPFLAGS="-I/opt/homebrew/opt/libxml2/include"
export PKG_CONFIG_PATH="$PKG_CONFIG_PATH:/opt/homebrew/opt/libxml2/lib/pkgconfig"

# NVM (Node Version Manager)
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# Mise (runtime version manager)
if command -v mise &> /dev/null; then
  eval "$(mise activate zsh)"
fi
