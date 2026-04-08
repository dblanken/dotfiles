# Cross-platform environment variables and PATH configuration
#
# This file contains environment variables that work across all platforms.
# Platform-specific settings are in env.darwin.zsh and env.linux.zsh.

# =============================================================================
# Editor configuration
# =============================================================================

export EDITOR="nvim"
export VISUAL="$EDITOR"

# =============================================================================
# Less/Man page configuration
# =============================================================================

export LESS="-FXR"
export LESS_TERMCAP_mb=$'\e[35m'     # magenta
export LESS_TERMCAP_md=$'\e[33m'     # yellow
export LESS_TERMCAP_me=$'\e[0m'      # reset
export LESS_TERMCAP_se=$'\e[0m'      # reset reverse video
export LESS_TERMCAP_so=$'\e[34m'     # blue
export LESS_TERMCAP_ue=$'\e[0m'      # reset underline
export LESS_TERMCAP_us=$'\e[4m'      # underline

# =============================================================================
# Git/GPG configuration
# =============================================================================

export GPG_TTY=$(tty)

# =============================================================================
# Docker configuration
# =============================================================================

export DOCKER_DEFAULT_PLATFORM=linux/amd64

# =============================================================================
# Cross-platform PATH additions
# =============================================================================

# LM Studio (AI model runner) - works on both macOS and Linux
export PATH="$HOME/.cache/lm-studio/bin:$PATH"

# =============================================================================
# Runtime version managers
# =============================================================================

# NVM (Node Version Manager) - cross-platform
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Bun - cross-platform JavaScript runtime
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# For Claude Code
export DISABLE_TELEMTRY=1
export DISABLE_AUTOUPDATER=1

# For Azure CLI
# Disable telemetry
export FUNCTIONS_CORE_TOOLS_TELEMETRY_OPTOUT=1

# PHP Terminus 8.5+
export TERMINUS_ALLOW_UNSUPPORTED_NEWER_PHP=1

# Mise (runtime version manager) - cross-platform
if command -v mise &> /dev/null; then
  eval "$(mise activate zsh)"
fi
