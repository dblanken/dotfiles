# macOS-specific environment configuration
#
# This file contains paths, flags, and settings specific to macOS/Darwin.
# It is automatically loaded by .zshrc when OS_TYPE=darwin.

# =============================================================================
# Homebrew-specific PATH additions
# =============================================================================

# MySQL client (Pantheon requires 8.4 syntax)
export PATH="/opt/homebrew/opt/mysql-client/bin:$PATH"

# XML library
export PATH="/opt/homebrew/opt/libxml2/bin:$PATH"

# ImageMagick 6 (for legacy PHP compatibility)
export PATH="/opt/homebrew/opt/imagemagick@6/bin:$PATH"

# =============================================================================
# Library flags for building packages
# =============================================================================

# libxml2
export LDFLAGS="-L/opt/homebrew/opt/libxml2/lib"
export CPPFLAGS="-I/opt/homebrew/opt/libxml2/include"
export PKG_CONFIG_PATH="$PKG_CONFIG_PATH:/opt/homebrew/opt/libxml2/lib/pkgconfig"

# Consolidated PKG_CONFIG_PATH for multiple Homebrew libraries
# This supports building PHP extensions and other native packages
PKG_CONFIG_LIBS="openssl libtiff gmp libpng ncurses mpfr libyaml icu4c readline webp unixodbc jpeg libpq imagemagick"
for lib in ${=PKG_CONFIG_LIBS}; do
    export PKG_CONFIG_PATH="/opt/homebrew/opt/$lib/lib/pkgconfig:$PKG_CONFIG_PATH"
done
unset PKG_CONFIG_LIBS lib

# =============================================================================
# Ruby configuration
# =============================================================================

# Ruby build options (for mise/asdf/rbenv)
export RUBY_CONFIGURE_OPTS="--with-openssl-dir=/opt/homebrew/opt/openssl@1.1"
export RUBY_CFLAGS="-Wno-error=implicit-function-declaration"

# =============================================================================
# ImageMagick configuration for PHP builds
# =============================================================================

export LDFLAGS="$LDFLAGS -L/opt/homebrew/opt/imagemagick/lib"
export CPPFLAGS="$CPPFLAGS -I/opt/homebrew/opt/imagemagick/include"
export PHP_CONFIGURE_OPTS="--with-imagick=/opt/homebrew/opt/imagemagick"

# =============================================================================
# LS colors (macOS/BSD format)
# =============================================================================

export LSCOLORS=gafacadabaegedabagacad

# =============================================================================
# Disable telemetry from azure function cli
# =============================================================================

export FUNCTIONS_CORE_TOOLS_TELEMETRY_OPTOUT=1

# =============================================================================
# Key repeat rate (60 fps)
# =============================================================================

if command -v dry &> /dev/null; then
  dry 0.0166666666667 > /dev/null
fi

# =============================================================================
# App Nap exemptions
# =============================================================================

# Amazon Music Web (Safari "Add to Dock" web-app): without this, App Nap
# throttles the background webview and playback silently stops after a
# while. Bundle ID is the auto-generated UUID for this one web-app instance;
# re-check it (osascript -e 'id of app "Amazon Music Web"') if the app is
# ever recreated.
defaults write com.apple.Safari.WebApp.E09EE667-849A-485B-92D4-461511021098 NSAppSleepDisabled -bool YES

# =============================================================================
# macOS-specific aliases
# =============================================================================

# MySQL client alias (Pantheon compatibility)
# Caches the mysql8 path to avoid repeated filesystem lookups
if [[ -z "$MYSQL8_BIN" ]]; then
  if [[ -d "/opt/homebrew/Cellar/mysql-client@8.4" ]]; then
    # Use zsh glob sort (faster than find | sort | tail)
    # *(on) sorts by name, [1] gets first (latest due to version numbering)
    local mysql_versions=(/opt/homebrew/Cellar/mysql-client@8.4/8.4.*(N/on))
    if [[ ${#mysql_versions[@]} -gt 0 && -f "${mysql_versions[1]}/bin/mysql" ]]; then
      export MYSQL8_BIN="${mysql_versions[1]}/bin/mysql"
    fi
  elif [[ -x /opt/homebrew/opt/mysql-client/bin/mysql ]]; then
    # Fallback to symlinked version
    export MYSQL8_BIN="/opt/homebrew/opt/mysql-client/bin/mysql"
  fi
fi

# Create alias if we found mysql8
[[ -n "$MYSQL8_BIN" ]] && alias mysql8="$MYSQL8_BIN"

# =============================================================================
# Locale
# =============================================================================

# Alacritty exports LC_ALL=en_US.UTF-8 on macOS (GUI apps inherit no locale),
# and tmux then hands it to every pane. Lando/Docker forward it into containers
# whose glibc only has C/C.UTF-8, so bash warns on every exec:
#   /bin/bash: warning: setlocale: LC_ALL: cannot change locale (en_US.UTF-8)
# Moving the value to LANG keeps the macOS side identical -- bash falls back
# quietly for LANG, and only complains about LC_ALL.
if [[ -n "$LC_ALL" ]]; then
  export LANG="$LC_ALL"
  unset LC_ALL
fi
