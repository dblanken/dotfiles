# macOS-specific environment configuration
#
# This file contains paths, flags, and settings specific to macOS/Darwin.
# It is automatically loaded by .zshrc when OS_TYPE=darwin.

# =============================================================================
# Homebrew-specific PATH additions
# =============================================================================

# ICU4C (PHP 8.3.x requires version 77)
export PATH="/opt/homebrew/opt/icu4c@77/bin:$PATH"
export PATH="/opt/homebrew/opt/icu4c@77/sbin:$PATH"

# MySQL client (Pantheon requires 8.4 syntax)
export PATH="/opt/homebrew/opt/mysql-client/bin:$PATH"

# XML library
export PATH="/opt/homebrew/opt/libxml2/bin:$PATH"

# ImageMagick 6 (for legacy PHP compatibility)
export PATH="/opt/homebrew/opt/imagemagick@6/bin:$PATH"

# Postgresql client (for pgsql extensions and CLI tools)
export PATH="/opt/homebrew/opt/postgresql@18/bin:$PATH"

# =============================================================================
# Library flags for building packages
# =============================================================================

# ARM64 architecture flags for native compilation
export CFLAGS="-arch arm64"
export CXXFLAGS="-arch arm64"

# libxml2
export LDFLAGS="-L/opt/homebrew/opt/libxml2/lib"
export CPPFLAGS="-I/opt/homebrew/opt/libxml2/include"
export PKG_CONFIG_PATH="$PKG_CONFIG_PATH:/opt/homebrew/opt/libxml2/lib/pkgconfig"

# Additional library paths for PHP and extension compilation
# These are critical for building PHP from source on ARM64
# NOTE: PHP 8.3.x requires ICU 77, not ICU 78
PHP_BUILD_LIBS="icu4c@77 krb5 libedit libxml2 openssl@3 zlib libiconv libzip"
for lib in ${=PHP_BUILD_LIBS}; do
    export LDFLAGS="$LDFLAGS -L/opt/homebrew/opt/$lib/lib"
    export CPPFLAGS="$CPPFLAGS -I/opt/homebrew/opt/$lib/include"
done
unset PHP_BUILD_LIBS lib

# Consolidated PKG_CONFIG_PATH for multiple Homebrew libraries
# This supports building PHP extensions and other native packages
# NOTE: PHP 8.3.x requires ICU 77, not ICU 78
PKG_CONFIG_LIBS="openssl@3 libtiff gmp libpng ncurses mpfr libyaml icu4c@77 readline webp unixodbc jpeg libpq imagemagick krb5 libedit libxml2 zlib"
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

# PHP configure options for mise/asdf builds
# These ensure PHP compiles correctly on ARM64 with all necessary libraries
# PHP 8.3.x requires ICU 77, not ICU 78
export PHP_CONFIGURE_OPTS="--with-imagick=/opt/homebrew/opt/imagemagick --with-openssl=/opt/homebrew/opt/openssl@3 --with-zlib=/opt/homebrew/opt/zlib --with-icu-dir=/opt/homebrew/opt/icu4c@77"
export PHP_BUILD_CONFIGURE_OPTS="$PHP_CONFIGURE_OPTS"

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

# Critical environment variables for 16GB RAM
export OLLAMA_NUM_PARALLEL=1          # Single request at a time
export OLLAMA_MAX_LOADED_MODELS=1     # Only one model loaded
export OLLAMA_KV_CACHE_TYPE=q8_0      # Halve KV cache memory
