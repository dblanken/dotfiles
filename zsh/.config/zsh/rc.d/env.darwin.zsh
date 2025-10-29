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
# macOS-specific aliases
# =============================================================================

# MySQL client alias (Pantheon compatibility)
# Dynamically finds the latest installed mysql-client version
if [[ -d "/opt/homebrew/Cellar/mysql-client@8.4" ]]; then
  # Find the latest version directory
  local mysql_latest
  mysql_latest=$(find /opt/homebrew/Cellar/mysql-client@8.4 -maxdepth 1 -type d -name "8.4.*" | sort -V | tail -n 1)
  if [[ -n "$mysql_latest" && -f "$mysql_latest/bin/mysql" ]]; then
    alias mysql8="$mysql_latest/bin/mysql"
  fi
  unset mysql_latest
elif command -v /opt/homebrew/opt/mysql-client/bin/mysql &> /dev/null; then
  # Fallback to symlinked version
  alias mysql8="/opt/homebrew/opt/mysql-client/bin/mysql"
fi
