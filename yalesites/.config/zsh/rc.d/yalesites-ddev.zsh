# YaleSites: DDEV-specific aliases and functions
# Loaded by yalesites.zsh when devtool is set to "ddev"

alias l="ddev"
alias lcr="l drush cr"
alias lrs="l restart"
alias ldr='l drush'
alias recompose='rm composer.lock; ddev composer update'
alias vlando="v .ddev/config.local.yaml"

rebuild() {
  ddev restart
}

ysopen() {
  local rootPath=$(git rev-parse --show-toplevel)
  local siteName=$(grep '^name:' "$rootPath/.ddev/config.yaml" | awk '{print $2}')
  open_file "https://$siteName.ddev.site"
}

# Set the DDEV local config to point to a specific Pantheon site.
# Usage: ysite <site-name>[.<environment>] [-f]
ysite() {
  if [ $# -eq 0 ]; then
    echo "Usage: ysite <site-name>[.<environment>] [-f]"
    return 1
  fi

  local input="$1"
  local force_flag=""
  if [ "${2}" = "-f" ]; then
    force_flag="-f"
  fi

  local site_name="${input%%.*}"
  local site_id
  site_id=$(siteid "$site_name" $force_flag)

  if ! [[ "$site_id" =~ ^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$ ]]; then
    echo "Error: unexpected response from siteid: ${site_id:-<empty>}"
    return 1
  fi

  local ddev_config=".ddev/config.local.yaml"
  local ddev_example=".ddev/config.local.example.yaml"

  if [ ! -f "$ddev_config" ]; then
    if [ ! -f "$ddev_example" ]; then
      echo "Error: neither $ddev_config nor $ddev_example found in $(pwd)"
      return 1
    fi
    cp "$ddev_example" "$ddev_config"
    echo "Created $ddev_config from $ddev_example"
  fi

  local env_suffix="${input#*.}"
  if [ "$env_suffix" = "$input" ]; then
    env_suffix="dev"
  fi

  cat > "$ddev_config" <<EOF
web_environment:
  - DDEV_PANTHEON_SITE=$site_name
  - DDEV_PANTHEON_ENVIRONMENT=$env_suffix
EOF

  echo "Updated $ddev_config:"
  echo "  site:        $site_name"
  echo "  environment: $env_suffix"
}
alias landosite="ysite"

replace_name_with_folder() {
  local folder_name=$(basename $(pwd))
  local ddev_config=".ddev/config.yaml"
  if [ -f "$ddev_config" ]; then
    sed -i '' "s/^name: .*/name: $folder_name/" "$ddev_config"
    echo "Updated DDEV project name to: $folder_name"
  fi
}

dbandfiles() {
  local multidev="${1:-dev}"
  DDEV_PANTHEON_ENVIRONMENT="$multidev" ddev pull pantheon
  lcr
}

dbget() {
  local multidev="${1:-dev}"
  DDEV_PANTHEON_ENVIRONMENT="$multidev" ddev pull pantheon --skip-files
  l drush config:set cas.settings server.cert NULL -y
  l drush config:set ai_engine_embedding.settings enable 0 -y
  lcr
}

filesget() {
  local multidev="${1:-dev}"
  DDEV_PANTHEON_ENVIRONMENT="$multidev" ddev pull pantheon --skip-db
  lcr
}

dbport() {
  ddev describe -j | jq '.raw.dbinfo.published_port' | sed 's/[^0-9]//g' | clipboard_copy
  echo "Database port copied to clipboard"
}

rmys() {
  local dirname

  if [ -f composer.json ]; then
    dirname=$(pwd)
  else
    dirname=$1
  fi

  if [ ! -d "$dirname" ]; then
    echo "Invalid directory: $dirname"
    return
  fi

  cd "$dirname"
  ddev delete -Oy
  cd ..
  rm -rfI "$dirname"
}

running-yalesites() {
  ddev list --active-only 2>/dev/null | grep -v '^$'
}
