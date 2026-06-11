# YaleSites-specific functions and aliases
#
# NOTE: mysql8 alias is defined in env.darwin.zsh and env.linux.zsh
# as it's platform-specific

# YaleSites is a work environment — macOS only
[[ "$OS_TYPE" != "darwin" ]] && return

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
    echo "$url" | clipboard_copy
    echo "login copied to clipboard"
    return
  else
    open_file "$url"
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

  open_file "https://$siteName.lndo.site"
}

# update all three repos
function yspull() {
  local rootPath
  rootPath=$(git rev-parse --show-toplevel) || { echo "Not in a git repo"; return 1; }
  cd "$rootPath" || return 1
  g pull --rebase
  echo "$rootPath is now up to date"
  cd "$rootPath/atomic" || { echo "atomic not found at $rootPath/atomic"; return 1; }
  g pull --rebase
  echo "atomic is now up to date"
  cd "$rootPath/component-library-twig" || { echo "component-library-twig not found"; return 1; }
  g pull --rebase
  echo "component-library-twig is now up to date"
  cd "$rootPath"
}

function gcbcreate() {
  local rootPath
  rootPath=$(git rev-parse --show-toplevel) || { echo "Not in a git repo"; return 1; }
  cd "$rootPath" || return 1
  local branch
  branch=$(git symbolic-ref --short HEAD) || { echo "Not on a branch"; return 1; }

  case "$branch" in
    develop|master|main)
      echo "Cannot create a branch from $branch"
      return 1
      ;;
  esac

  cd "$rootPath/atomic" || { echo "atomic not found at $rootPath/atomic"; return 1; }
  gcb "$branch"; gco "$branch"
  echo "atomic: created and checked out $branch"
  cd "$rootPath/component-library-twig" || { echo "component-library-twig not found"; return 1; }
  gcb "$branch"; gco "$branch"
  echo "component-library-twig: created and checked out $branch"
  cd "$rootPath"
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
  l drush config:set ai_engine_embedding.settings enable 0 -y
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

# Recover from a corrupted local MariaDB volume. Symptom: lando fails to start
# the database with an InnoDB crash-recovery error, e.g. "Missing FILE_CREATE...
# before FILE_CHECKPOINT", "Plugin 'InnoDB' init function returned error", or
# "Data structure corruption" -- caused by an unclean container shutdown.
#
# Wipes the Lando app + DB volume (lando destroy), recreates it, then re-pulls
# and deploys the database from Pantheon. The local DB is disposable, so this is
# the fast, reliable fix. Host-side code, files, and -- if gyst was run -- the
# cross-repo clones/symlinks/npm-links all live on the bind mount and are NOT
# touched by lando destroy. We deliberately avoid composer update / atomic
# npm install (i.e. npm run build) so the gyst setup is preserved.
#
# Run from the yalesites-project root. Usage: ys-reset-db [multidev]  (default: dev)
ys-reset-db() {
  local multidev="${1:-dev}"

  if [ ! -f .lando.local.yml ]; then
    echo "Run this from the yalesites-project root (no .lando.local.yml here)."
    return 1
  fi

  # The root-level 'atomic' symlink only exists if gyst was run here; only then
  # is the gyst-preservation note relevant.
  local gyst_note=""
  [ -L atomic ] && gyst_note=" Your gyst cross-repo clones/symlinks/links are NOT affected."

  echo "This DESTROYS the local Lando app + database volume, then re-pulls and"
  echo "deploys the '$multidev' database from Pantheon. Code and files are NOT"
  echo "affected.${gyst_note}"
  echo -n "Continue? [y/N] "
  read -r reply
  [[ "$reply" =~ ^[Yy]$ ]] || { echo "Aborted."; return 1; }

  l destroy -y || return 1
  l start      || return 1
  l pull --code=none --database="$multidev" --files=none || return 1

  # npm run confim == drush deploy (updatedb + config import + cr + deploy hooks).
  confim || return 1

  # Local-only overrides, applied AFTER confim so its config import doesn't revert them.
  fixcas
  l drush config:set ai_engine_embedding.settings enable 0 -y
  lcr
}

# Symlink each sub-repo's CLAUDE.md from a common canonical source so every
# yalesites-project checkout (including yw worktrees) shares one copy. These
# CLAUDE.md files are globally gitignored, so they are never committed to the
# sub-repos and must be re-linked after a fresh instance. Canonical source:
# ~/.claude/yalesites/claude-md/{atomic,component-library-twig,tokens}.md
# Run from a yalesites-project checkout root; wired into local-setup.
ys-link-claude-md() {
  local src="$HOME/.claude/yalesites/claude-md"
  local atomic="web/themes/contrib/atomic"

  if [ ! -d "$atomic" ]; then
    echo "Run this from a yalesites-project checkout root (no $atomic)."
    return 1
  fi

  local linked=0
  for pair in \
    "atomic.md:$atomic" \
    "component-library-twig.md:$atomic/_yale-packages/component-library-twig" \
    "tokens.md:$atomic/_yale-packages/tokens"; do
    local file="${pair%%:*}" dir="${pair#*:}"
    if [ ! -f "$src/$file" ]; then
      echo "skip: canonical $src/$file missing"
      continue
    fi
    if [ ! -d "$dir" ]; then
      echo "skip: $dir not present yet (run gyst first)"
      continue
    fi
    ln -sf "$src/$file" "$dir/CLAUDE.md"
    echo "linked $dir/CLAUDE.md -> $src/$file"
    linked=$((linked + 1))
  done
  echo "Linked $linked CLAUDE.md file(s)."
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
  local rootPath
  rootPath=$(git rev-parse --show-toplevel) || { echo "Not in a git repo"; return 1; }
  gfetchpull
  cd "$rootPath/atomic" || { echo "atomic not found"; return 1; }
  gfetchpull
  cd "$rootPath/component-library-twig" || { echo "component-library-twig not found"; return 1; }
  gfetchpull
  cd "$rootPath"
  echo "All done"
}

ctags-php() {
  ctags --langmap=php:.engine.inc.module.theme.install.php --php-kinds=cdfi --languages=php --recurse --fields=+l
}

export DEBUG_COLORS=0

# Find the port that changes each time it's rebuilt for lando instances
dbport() {
  lando info --format json | jq '.[] | select(.service == "database").external_connection.port' | sed 's/[^0-9]//g' | clipboard_copy
  echo "Database port copied to clipboard"
}

local-setup() {
  replace_name_with_folder
  npm run setup
  gyst
  ys-link-claude-md
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

# Disable ai_engine_embedding on one or more Pantheon sites via terminus.
# Accepts URLs as arguments or reads one URL per line from stdin.
#
# Usage:
#   disable-ai-embedding https://v2220-mysite.pantheonsite.io live-other-site.pantheonsite.io
#   pbpaste | disable-ai-embedding
#   disable-ai-embedding <<'EOF'
#   https://v2220-mysite.pantheonsite.io
#   https://live-other-site.pantheonsite.io
#   EOF
disable-ai-embedding() {
  local urls=()

  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    echo "Usage: disable-ai-embedding <env-site.pantheonsite.io> [...]"
    echo "       pbpaste | disable-ai-embedding"
    echo ""
    echo "Disables ai_engine_embedding.settings on one or more Pantheon sites via terminus."
    echo ""
    echo "Examples:"
    echo "  disable-ai-embedding https://v2220-mysite.pantheonsite.io"
    echo "  pbpaste | disable-ai-embedding"
    echo "  disable-ai-embedding <<'EOF'"
    echo "  https://v2220-mysite.pantheonsite.io"
    echo "  https://live-other-site.pantheonsite.io"
    echo "  EOF"
    return 0
  fi

  if [[ $# -gt 0 ]]; then
    urls=("$@")
  else
    while IFS= read -r line; do
      [[ -n "$line" ]] && urls+=("$line")
    done
  fi

  if [[ ${#urls[@]} -eq 0 ]]; then
    echo "Usage: disable-ai-embedding <env-site.pantheonsite.io> [...]"
    echo "       pbpaste | disable-ai-embedding"
    return 1
  fi

  for url in "${urls[@]}"; do
    local slug="${url#https://}"
    slug="${slug%.pantheonsite.io}"

    local env="${slug%%-*}"
    local site="${slug#*-}"

    echo "[$site.$env] Disabling ai_engine_embedding.settings..."
    terminus drush "${site}.${env}" -- config:set ai_engine_embedding.settings enable 0 --yes
    echo "[$site.$env] Done."
  done
}

