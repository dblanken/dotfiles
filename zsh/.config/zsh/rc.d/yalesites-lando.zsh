# YaleSites: Lando-specific aliases and functions
# Loaded by yalesites.zsh when devtool is set to "lando"

alias l="lando"
alias lcr="l drush cr"
alias lrs="l restart"
alias lrb="l rebuild -y"
alias ldr='l drush'
alias recompose="rm composer.lock; lando composer update"
alias vlando="v .lando.local.yml"

rebuild() {
  lando rebuild -y
}

ysopen() {
  local rootPath=$(git rev-parse --show-toplevel)
  local landoFile="$rootPath/.lando.local.yml"
  local siteName=$(cat $landoFile | grep name: | cut -d':' -f2- | awk '{$1=$1};1')
  open_file "https://$siteName.lndo.site"
}

# Set the lando local config to point to a specific Pantheon site.
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

  local lando_file=".lando.local.yml"
  local lando_example=".lando.local.example.yml"

  if [ ! -f "$lando_file" ]; then
    if [ ! -f "$lando_example" ]; then
      echo "Error: neither $lando_file nor $lando_example found in $(pwd)"
      return 1
    fi
    cp "$lando_example" "$lando_file"
    echo "Created $lando_file from $lando_example"
  fi

  sed -i '' "s/  id: .*/  id: $site_id/" "$lando_file"
  sed -i '' "s/  site: .*/  site: $input/" "$lando_file"

  echo "Updated $lando_file:"
  echo "  id:   $site_id"
  echo "  site: $input"
}
alias landosite="ysite"

replace_name_with_folder() {
  local folder_name=$(basename $(pwd))
  local file_name='.lando.local.yml'

  if [ ! -f "$file_name" ]; then
    cp .lando.local.example.yml $file_name
  fi

  sed -i '' "s/name: .*/name: $folder_name/" $file_name
  sed -i '' "s/DRUSH_OPTIONS_URI: .*/DRUSH_OPTIONS_URI: \"https:\/\/$folder_name.lndo.site\/\"/" $file_name
}

# OrbStack does not forward the macOS SSH agent socket into containers, so SSH
# inside the container cannot authenticate to Pantheon. This writes a minimal
# SSH config and symlinks the id_pantheon key to the container HOME (~/.ssh/),
# which is where SSH resolves ~ when running as www-data (HOME=/var/www).
# Only runs when OrbStack is detected.
_lando_pantheon_ssh_setup() {
  [[ -f ~/.orbstack/ssh/config ]] || return 0
  lando ssh -c '
    mkdir -p /var/www/.ssh
    echo "Host *.drush.in" > /var/www/.ssh/config
    echo "  IdentityFile /user/.ssh/id_pantheon" >> /var/www/.ssh/config
    echo "  Port 2222" >> /var/www/.ssh/config
    echo "  StrictHostKeyChecking accept-new" >> /var/www/.ssh/config
    echo "" >> /var/www/.ssh/config
    echo "Host *.pantheonsite.io" >> /var/www/.ssh/config
    echo "  IdentityFile /user/.ssh/id_pantheon" >> /var/www/.ssh/config
    chmod 600 /var/www/.ssh/config
    ln -sf /user/.ssh/id_pantheon /var/www/.ssh/id_pantheon
    ln -sf /user/.ssh/id_pantheon.pub /var/www/.ssh/id_pantheon.pub
  ' > /dev/null 2>&1
}

dbandfiles() {
  local multidev="${1:-dev}"
  _lando_pantheon_ssh_setup
  l pull --code=none --database="$multidev" --files="$multidev"
  lcr
}

dbget() {
  local multidev="${1:-dev}"
  _lando_pantheon_ssh_setup
  l pull --code=none --database="$multidev" --files=none
  l drush config:set cas.settings server.cert NULL -y
  l drush config:set ai_engine_embedding.settings enable 0 -y
  lcr
}

filesget() {
  local multidev="${1:-dev}"
  _lando_pantheon_ssh_setup
  l pull --code=none --database=none --files="$multidev"
  lcr
}

dbport() {
  lando info --format json | jq '.[] | select(.service == "database").external_connection.port' | sed 's/[^0-9]//g' | clipboard_copy
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
  l destroy -y
  cd ..
  rm -rfI "$dirname"
}

running-yalesites() {
  docker ps --format '{{.Names}}' | grep appserver | awk -F'_' '{print $1}' | sort -u
}
