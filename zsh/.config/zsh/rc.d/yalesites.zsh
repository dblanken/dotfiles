# YaleSites-specific functions and aliases
#
# NOTE: mysql8 alias is defined in env.darwin.zsh and env.linux.zsh
# as it's platform-specific

# ---------------------------------------------------------------------------
# Dev tool toggle (lando <-> ddev)
# Persistent selection stored in ~/.config/yalesites/devtool
# Switch with: use-ddev / use-lando
# Check with:  devtool
# ---------------------------------------------------------------------------
_ys_devtool_file="${XDG_CONFIG_HOME:-$HOME/.config}/yalesites/devtool"
_ys_rc_dir="${0:A:h}"

_ys_tool() {
  if [ -f "$_ys_devtool_file" ]; then
    cat "$_ys_devtool_file"
  else
    echo "ddev"
  fi
}

devtool() {
  echo "Current dev tool: $(_ys_tool)"
}

use-ddev() {
  mkdir -p "$(dirname "$_ys_devtool_file")"
  echo "ddev" > "$_ys_devtool_file"
  echo "Switched to ddev (restart shell or run: source ~/.zshrc)"
}

use-lando() {
  mkdir -p "$(dirname "$_ys_devtool_file")"
  echo "lando" > "$_ys_devtool_file"
  echo "Switched to lando (restart shell or run: source ~/.zshrc)"
}

# ---------------------------------------------------------------------------
# Shared aliases and functions (tool-agnostic)
# ---------------------------------------------------------------------------
alias cyp="c yalesites-project"

# Get the login url copied to the clipboard
# If a parameter is given it's assumed it is a terminus remote command to run
# the same login retrieval on.
# Options:
#   --copy        Copy the login url to clipboard instead of opening it
#   --uri=<url>   Override the base URI (e.g. --uri=commencement.yale.edu)
function llogin() {
  local url
  local copy
  local uri
  local args

  copy=false
  uri=""
  args=()

  while [[ $# -gt 0 ]]; do
    case "$1" in
      --copy)
        copy=true
        shift
        ;;
      --uri=*)
        uri="${1#--uri=}"
        shift
        ;;
      --uri)
        uri="$2"
        shift 2
        ;;
      *)
        args+=("$1")
        shift
        ;;
    esac
  done

  if [ ${#args[@]} -eq 0 ]; then
    if [ -n "$uri" ]; then
      url=$(l drush uli --uri="$uri")
    else
      url=$(l drush uli)
      url="${url::-1}"
    fi
  else
    if [ -n "$uri" ]; then
      url=$(terminus drush $args[@] -- user:login --uri="$uri")
    else
      url=$(terminus drush $args[@] -- user:login)
    fi
  fi

  if [ -z "$url" ]; then
    echo "Failed to get login url"
    return
  fi

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

# update all three repos
function yspull() {
  local rootPath=$(git rev-parse --show-toplevel)
  cd "$rootPath"
  g pull --rebase
  echo "$rootPath is now up to date"
  cd atomic && g pull --rebase && cd "$rootPath" && echo "atomic is now up to date"
  cd component-library-twig && g pull --rebase && cd "$rootPath" && echo "component-library-twig is now up to date"
}

function gcbcreate() {
  local rootPath=$(git rev-parse --show-toplevel)
  cd "$rootPath"

  local target_branch="$1"
  local current_branch=$(git symbolic-ref --short HEAD)

  if [ -z "$current_branch" ]; then
    echo "Not in a git repo"
    return
  fi

  local branch
  if [ -n "$target_branch" ]; then
    if [ "$current_branch" != "$target_branch" ]; then
      if git show-ref --verify --quiet "refs/heads/$target_branch"; then
        git checkout "$target_branch"
      else
        git checkout -b "$target_branch"
      fi
    fi
    branch="$target_branch"
  else
    branch="$current_branch"
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

gyst() {
  local branch=$(git symbolic-ref --short HEAD)

  if [ -z "$branch" ]; then
    echo "Not in a git repo"
    return
  fi

  npm run local:git-checkout -- -b "$branch"

  if [ "$branch" = "develop" ]; then
    echo "On develop -- pulling latest for each repo on its default branch..."

    git pull

    local root_git_dir
    root_git_dir=$(git rev-parse --show-toplevel 2>/dev/null)

    local -a sub_repos=(
      "web/themes/contrib/atomic"
      "atomic/_yale-packages/component-library-twig"
      "atomic/_yale-packages/tokens"
    )

    for repo in "${sub_repos[@]}"; do
      if [ ! -d "$repo" ]; then
        echo "Skipping $repo (directory not found)"
        continue
      fi

      local sub_git_dir
      sub_git_dir=$(git -C "$repo" rev-parse --show-toplevel 2>/dev/null)
      if [ -z "$sub_git_dir" ] || [ "$sub_git_dir" = "$root_git_dir" ]; then
        echo "Skipping $repo (not a separate git repo)"
        continue
      fi

      local sub_branch
      sub_branch=$(git -C "$repo" symbolic-ref --short HEAD 2>/dev/null)
      if [ "$sub_branch" = "main" ] || [ "$sub_branch" = "develop" ]; then
        echo "Pulling $repo (on $sub_branch)..."
        git -C "$repo" pull
      fi
    done
  fi
}

siteid() {
  if [ $# -eq 0 ]; then
    echo "Usage: $0 <site name without environment>"
    return
  fi

  local force=false
  if [ "${2}" = "-f" ]; then
    force=true
  fi

  local site_name="$1"
  local siteid_dir="${XDG_DATA_HOME:-$HOME/.local/share}/siteids"
  if [ ! -d "$siteid_dir" ]; then
    mkdir -p "$siteid_dir"
  fi

  if [ "$force" = true ]; then
    rm -f "$siteid_dir/$site_name"
  fi

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
  echo "$site_id" > "$siteid_dir/$site_name"
  echo "$site_id"
}

# Since I always confim followed by cache clear
confim() {
  npm run confim && lcr
}

confex() {
  npm run confex
}

fixcas() {
  l drush config:set cas.settings server.cert NULL -y
}

# Keep up to date
gfetchpull() {
  g fetch --all
  g pull
}

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

local-setup() {
  replace_name_with_folder
  npm run setup
  gyst
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

disable_ai() {
  if [ $# -eq 0 ]; then
    echo "Usage: $0 <site name>"
    return
  fi

  terminus drush "$1" -- config:set ai_engine_embedding.settings enable 0 -y
}

# Consolidated PKG_CONFIG_PATH for multiple Homebrew libraries
export PKG_CONFIG_PATH="/opt/homebrew/opt/{openssl,libtiff,gmp,libpng,ncurses,mpfr,libyaml,icu4c,readline,webp,unixodbc,jpeg,libpq,imagemagick}/lib/pkgconfig"

# ImageMagick configuration for PHP builds
export LDFLAGS="$LDFLAGS -L/opt/homebrew/opt/imagemagick/lib"
export CPPFLAGS="$CPPFLAGS -I/opt/homebrew/opt/imagemagick/include"
export PHP_CONFIGURE_OPTS="--with-imagick=/opt/homebrew/opt/imagemagick"

# ---------------------------------------------------------------------------
# Load tool-specific file based on current selection
# ---------------------------------------------------------------------------
if [ "$(_ys_tool)" = "lando" ]; then
  source "$_ys_rc_dir/yalesites-lando.zsh"
else
  source "$_ys_rc_dir/yalesites-ddev.zsh"
fi
