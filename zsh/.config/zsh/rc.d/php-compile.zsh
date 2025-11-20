# PHP Compilation Helper
# Use this function to compile PHP with OpenSSL 1.1 instead of OpenSSL 3
# This is necessary for PHP 8.3.x which requires OpenSSL 1.1

php-compile() {
  local php_version="$1"

  if [[ -z "$php_version" ]]; then
    echo "Usage: php-compile <version>"
    echo "Example: php-compile 8.3.28"
    return 1
  fi

  echo "Compiling PHP $php_version with OpenSSL 1.1 and ICU 77..."

  # Temporarily override environment to use OpenSSL 1.1
  PKG_CONFIG_PATH="/opt/homebrew/opt/openssl@1.1/lib/pkgconfig:/opt/homebrew/opt/icu4c@77/lib/pkgconfig:$PKG_CONFIG_PATH" \
  LDFLAGS="-L/opt/homebrew/opt/openssl@1.1/lib $LDFLAGS" \
  CPPFLAGS="-I/opt/homebrew/opt/openssl@1.1/include $CPPFLAGS" \
  mise install "php@$php_version"
}
