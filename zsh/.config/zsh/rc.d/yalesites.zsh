# YaleSites-specific functions and aliases

# Pantheon still requires the use of mysql client 8.4 syntax, so have to use different version
alias mysql8="/opt/homebrew/Cellar/mysql-client@8.4/8.4.2/bin/mysql"

# Lando
alias l="lando"
alias lcr="l drush cr"
alias lrs="l restart"
alias lrb="l rebuild -y"
alias ldr='l drush'
alias recompose="rm composer.lock; lando composer update"
alias vlando="v .lando.local.yml"
alias cyp="c yalesites-project"

# Get the login url copied to the clipboard
# If a parameter is given it's assumed it is a terminus remote command to run
# the same login retrieval on.
function llogin() {
  local url
  local copy
  local args

  copy=false
  args=()

  while [[ $# -gt 0 ]]; do
    case "$1" in
      --copy)
        copy=true
        shift
        ;;
      *)
        args+=("$1")
        shift
        ;;
    esac
  done

  if [ ${#args[@]} -eq 0 ]; then
    url=$(l drush uli)
    url="${url::-1}"
  else
    url=$(terminus drush $args[@] -- user:login)
  fi

  if [ -z "$url" ]; then
    echo "Failed to get login url"
    return
  fi

  # if the last argument is --copy, then copy the url to the clipboard
  if [ $copy != false ]; then
    echo "$url" | pbcopy
    echo "login copied to clipboard"
    return
  else
    open "$url"
    echo "opening login url"
  fi
}

# Tail the watchdog logs.  If a parameter is given it's assumed it is a terminus
# remote command to run the same watchdog tail on.
function watchdog() {
  if [ $# -eq 0 ]; then
    echo "Executing watchdog locally"
    l drush watchdog:tail --extended
  else
    echo "Executing watchdog remotely"
    terminus drush "$@" -- watchdog:tail --extended
  fi
}

# Open the current local site
function ysopen() {
  local rootPath=$(git rev-parse --show-toplevel)
  local landoFile="$rootPath/.lando.local.yml"
  local siteName=$(cat $landoFile | grep name: | cut -d':' -f2- | awk '{$1=$1};1')

  open "https://$siteName.lndo.site"
}

# update all three repos
function yspull() {
  # Get the git rootPath
  local rootPath=$(git rev-parse --show-toplevel)
  cd "$rootPath"
  g pull --rebase
  echo "$rootPath is now up to date"
  cd atomic && g pull --rebase && cd "$rootPath" && echo "atomic is now up to date"
  cd component-library-twig && g pull --rebase && cd "$rootPath" && echo "component-library-twig is now up to date"
}

function gcbcreate() {
  # Get the git rootPath
  local rootPath=$(git rev-parse --show-toplevel)
  cd "$rootPath"
  local branch=$(git symbolic-ref --short HEAD)

  if [ -z "$branch" ]; then
    echo "Not in a git repo"
    return
  fi

  if [ "$branch" = "develop" ]; then
    echo "Cannot create a branch from develop"
    return
  fi

  if [ "$branch" = "master" ]; then
    echo "Cannot create a branch from master"
    return
  fi

  if [ "$branch" = "main" ]; then
    echo "Cannot create a branch from main"
    return
  fi

  cd atomic; gcb "$branch"; gco "$branch";
  cd "$rootPath" && echo "atomic is now up to date"
  cd component-library-twig; gcb "$branch"; gco "$branch"
  cd "$rootPath" && echo "component-library-twig is now up to date"
}

# Attempts to git-checkout a YaleSite with the current branch
gyst() {
  local branch=$(git symbolic-ref --short HEAD)

  if [ -z "$branch" ]; then
    echo "Not in a git repo"
    return
  fi

  npm run local:git-checkout -- -b "$branch"
}

# get the site id of a site
siteid() {
  if [ $# -eq 0 ]; then
    echo "Usage: $0 <site name without environment>"
    return
  fi

  # check if they passed -f as an end argument to know if we need to disregard cache.
  local force=false
  if [ "${2}" = "-f" ]; then
    force=true
  fi

  local site_name="$1"

  # See if the temp directory exists to store this site_id for the name.
  local siteid_dir="${XDG_DATA_HOME:-$HOME/.local/share}/siteids"
  if [ ! -d "$siteid_dir" ]; then
    mkdir -p "$siteid_dir"
  fi

  if [ "$force" = true ]; then
    # If we are forcing, then remove the siteid file so we can get a new one.
    rm -f "$siteid_dir/$site_name"
  fi

  # Check if the siteid already exists in that directory for the filenamee so we don't have to look it up again.
  if [ -f "$siteid_dir/$site_name" ]; then
    cat "$siteid_dir/$site_name"
    return
  fi

  local site_info=$(terminus site:list --fields=id,name | grep "$site_name")

  if [ -z "$site_info" ]; then
    echo "Site not found: $site_name"
    return
  fi

  local site_id=$(echo "$site_info" | awk '{print $1}')

  # Create the cache for the siteid so we never have to look it up again.
  echo "$site_id" > "$siteid_dir/$site_name"

  echo "$site_id"
}

# Replace the name of the site referenced to the directory name
replace_name_with_folder() {
  local folder_name=$(basename $(pwd))
  local file_name='.lando.local.yml'

  if [ ! -f "$file_name" ]; then
    cp .lando.local.example.yml $file_name
  fi

  sed -i '' "s/name: .*/name: $folder_name/" $file_name
  # Replace DRUSH_OPTIONS_URI with the folder name
  sed -i '' "s/DRUSH_OPTIONS_URI: .*/DRUSH_OPTIONS_URI: \"https:\/\/$folder_name.lndo.site\/\"/" $file_name
}

# Since I always confim followed by cache clear
confim() {
  npm run confim && lcr
}

# Shortcut for exporting configs
confex() {
  npm run confex
}

# NOTE: the following are made due to the NPM defaults being dev
# This allows me to pull any db/files I wish
# Get the database and files together from a multidev
dbandfiles() {
  local multidev="${1:-dev}"
  l pull --code=none --database="$multidev" --files="$multidev"
  lcr
}

# Get only the database from a multidev
dbget() {
  local multidev="${1:-dev}"
  l pull --code=none --database="$multidev" --files=none
  l drush config:set cas.settings server.cert NULL -y
  lcr
}

fixcas() {
  l drush config:set cas.settings server.cert NULL -y
}

# Get only the files form a multidev
filesget() {
  local multidev="${1:-dev}"
  l pull --code=none --database=none --files="$multidev"
  lcr
}

# Rebuild the lando site--useful when you change .lando.local.yml
rebuild() {
  l rebuild -y
}

# Keep up to date
gfetchpull() {
  g fetch --all
  g pull
}

# Keep all yalesites up to date
gpullall() {
  gfetchpull
  cd atomic
  gfetchpull
  cd ../component-library-twig
  gfetchpull
  cd ..
  echo "All done"
}

ctags-php() {
  ctags --langmap=php:.engine.inc.module.theme.install.php --php-kinds=cdfi --languages=php --recurse --fields=+l
}

export DEBUG_COLORS=0

# Find the port that changes each time it's rebuilt for lando instances
dbport() {
  lando info --format json | jq '.[] | select(.service == "database").external_connection.port' | sed 's/[^0-9]//g' | pbcopy
  echo "Database port copied to clipboard"
}

local-setup() {
  replace_name_with_folder
  npm run setup
  gyst
}

rmys() {
  local dirname

  if [ -f composer.json ]; then
    dirname=$(pwd)
  else
    dirname=$1
  fi

  # exit if dirname is not a valid directory
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

gtodo() {
  gh pr list -B develop --search 'review-requested:@me status:pending label:"needs review" -label:"pass code review"'
}

gt() {
  gtodo
}

grtm() {
  gh pr list -B develop --search 'label:"ready to merge"'
}

# Consolidated PKG_CONFIG_PATH for multiple Homebrew libraries
export PKG_CONFIG_PATH="/opt/homebrew/opt/{openssl,libtiff,gmp,libpng,ncurses,mpfr,libyaml,icu4c,readline,webp,unixodbc,jpeg,libpq,imagemagick}/lib/pkgconfig"

# ImageMagick configuration for PHP builds
export LDFLAGS="$LDFLAGS -L/opt/homebrew/opt/imagemagick/lib"
export CPPFLAGS="$CPPFLAGS -I/opt/homebrew/opt/imagemagick/include"
export PHP_CONFIGURE_OPTS="--with-imagick=/opt/homebrew/opt/imagemagick"
