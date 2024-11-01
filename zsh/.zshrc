#
# Start profiling (uncomment when necessary)
#
# See: https://stackoverflow.com/a/4351664/2103996

# Per-command profiling:

# zmodload zsh/datetime
# setopt promptsubst
# PS4='+$EPOCHREALTIME %N:%i> '
# exec 3>&2 2> startlog.$$
# setopt xtrace prompt_subst

# Per-function profiling:

# zmodload zsh/zprof

# {{{1 Tmux
if [ "$TMUX" = "" ]; then tmux attach || tmux -2 new -s $(hostname) && exit; fi

export HASBREW="$(command -v brew)"
export UNAME="$(uname)"

if [[ "$HASBREW" == "" ]]; then
  # fpath+=("$(brew --prefix)/share/zsh/site-functions")
  fpath+=("/opt/homebrew/share/zsh/site-functions")
  # fpath+=("$HOME/.asdf/completions")
fi

typeset -A __DBLANKEN
__DBLANKEN[ITALIC_ON]=$'\e[3m'
__DBLANKEN[ITALIC_OFF]=$'\e[23m'

# {{{1 Exports
# Set local path for playlist and other bins
export GOPATH="$HOME/.go"
export PATH="./bin":"$HOME/bin":"$HOME/.bin":"$HOME/.local/bin":"$HOME/.lando/bin":"$PATH"
if [ "$(command -v go &> /dev/null)" ]; then
  # export PATH="$PATH":$(go env GOPATH)/bin
  export PATH="$PATH":$HOME/.go/bin
fi
if [ "$HASBREW" != "" ]; then
  # export RUBY_CONFIGURE_OPTS="--with-openssl-dir=$(brew --prefix openssl@1.1)"
  export RUBY_CONFIGURE_OPTS="--with-openssl-dir=/opt/homebrew/opt/openssl@1.1"
fi
export THOR_MERGE="vimdiff"
export GOPATH="$HOME/.go"
export RUBY_CFLAGS="-Wno-error=implicit-function-declaration"
# export NVIM_APPNAME="nvim"
export NVIM_APPNAME="lazyvim"

if [ "$UNAME" = "Darwin" ]; then
  # Set 60 fps key repeat rate
  #
  # Equivalent to the fatest rate acheivable with:
  #
  #     defaults write NSGlobalDomain KeyRepeat -int 1
  #
  # But doesn't require a logout and will get restored every time we open a
  # shell (for example, if somebody manipulates the slider in the UI).
  #
  # Fastest rate available from UI corresponds to:
  #
  #     defaults write NSGlobalDomain KeyRepeat -int 2
  #
  # Slowest rate available from UI corresponds to:
  #
  #     defaults write NSGlobalDomain KeyRepeat -int 120
  #
  # Values at each slider position in UI, from slowest to fastest:
  #
  # - 120 -> 2 seconds (ie. .5 fps)
  # - 90 -> 1.5 seconds (ie .6666 fps)
  # - 60 -> 1 second (ie 1 fps)
  # - 30 -> 0.5 seconds (ie. 2 fps)
  # - 12 -> 0.2 seconds (ie. 5 fps)
  # - 6 -> 0.1 seconds (ie. 10 fps)
  # - 2 -> 0.03333 seconds (ie. 30 fps)
  #
  # See: https://github.com/mathiasbynens/dotfiles/issues/687
  #
  if command -v dry &> /dev/null; then
    dry 0.0166666666667 > /dev/null
  fi
fi

# {{{1 Completion
autoload -Uz compinit && compinit -u

# Make completion:
# - Try exact (case-sensitive) match first.
# - Then fall back to case-insensitive.
# - Accept abbreviations after . or _ or - (ie. f.b -> foo.bar).
# - Substring complete (ie. bar -> foobar).
zstyle ':completion:*' matcher-list '' '+m:{[:lower:]}={[:upper:]}' '+m:{[:upper:]}={[:lower:]}' '+m:{_-}={-_}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

# Colorize completions using default `ls` colors.
zstyle ':completion:*' list-colors ''

# Allow completion of ..<Tab> to ../ and beyond.
zstyle -e ':completion:*' special-dirs '[[ $PREFIX = (../)#(..) ]] && reply=(..)'

# $CDPATH is overpowered (can allow us to jump to 100s of directories) so tends
# to dominate completion; exclude path-directories from the tag-order so that
# they will only be used as a fallback if no completions are found.
zstyle ':completion:*:complete:(cd|pushd):*' tag-order 'local-directories named-directories'

# Categorize completion suggestions with headings:
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format %F{default}%B%{$__DBLANKEN[ITALIC_ON]%}--- %d ---%{$__DBLANKEN[ITALIC_OFF]%}%b%f

# Enable keyboard navigation of completions in menu
# (not just tab/shift-tab but cursor keys as well):
zstyle ':completion:*' menu select

# complist must be loaded to use menuselect keymap
zmodload zsh/complist
bindkey -M menuselect '^[[Z' reverse-menu-complete   # make Shift-tab go to previous completion

# {{{1 Colors
autoload colors && colors

# {{{1 Hooks
autoload -U add-zsh-hook

# {{{1 Prompt
# Taken and modified from https://github.com/wincent/wincent/blob/main/aspects/dotfiles/files/.zshrc
# http://zsh.sourceforge.net/Doc/Release/User-Contributions.html
setopt prompt_subst
autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' stagedstr "%F{green}●%f" # default 'S'
zstyle ':vcs_info:*' unstagedstr "%F{red}●%f" # default 'U'
zstyle ':vcs_info:*' use-simple true
zstyle ':vcs_info:git+set-message:*' hooks git-untracked
zstyle ':vcs_info:git*:*' formats '[%F{cyan}%b%f%m%c%u] ' # default ' (%s)-[%b]%c%u-'
zstyle ':vcs_info:git*:*' actionformats '[%F{cyan}%b%f|%a%m%c%u] ' # default ' (%s)-[%b|%a]%c%u-'

function +vi-git-untracked() {
emulate -L zsh
if [[ -n $(git ls-files --exclude-standard --others 2> /dev/null) ]]; then
  hook_com[unstaged]+="%F{blue}●%f"
fi
}

# If we have async, then async the version control statuses
if [ -f "$HOME/.config/zsh/zsh-async/async.zsh" ]; then
  source $HOME/.config/zsh/zsh-async/async.zsh

  -start-async-vcs-info-worker() {
    async_start_worker vcs_info
    async_register_callback vcs_info -async-vcs-info-worker-done
  }

  -get-vcs-info-in-worker() {
  # -q stops chpwd hook from being called:
  cd -q $1
  vcs_info
  print ${vcs_info_msg_0_}
  }

  -async-vcs-info-worker-done() {
  local job=$1
  local return_code=$2
  local stdout=$3
  local more=$6
  if [[ $job == '[async]' ]]; then
    if [[ $return_code -eq 1 ]]; then
      # Corrupt worker output.
      return
    elif [[ $return_code -eq 2 || $return_code -eq 3 || $return_code -eq 130 ]]; then
      # 2 = ZLE watcher detected an error on the worker fd.
      # 3 = Response from async_job when worker is missing.
      # 130 = Async worker crashed, this should not happen but it can mean the
      # file descriptor has become corrupt.
      #
      # Restart worker.
      async_stop_worker vcs_info
      -start-async-vcs-info-worker
      return
    fi
  fi
  vcs_info_msg_0_=$stdout
  (( $more )) || zle reset-prompt
  }

  -clear-vcs-info-on-chpwd() {
  vcs_info_msg_0_=
  }

  -trigger-vcs-info-run-in-worker() {
  async_flush_jobs vcs_info
  async_job vcs_info -get-vcs-info-in-worker $PWD
  }

  async_init
  -start-async-vcs-info-worker
  add-zsh-hook precmd -trigger-vcs-info-run-in-worker
  add-zsh-hook chpwd -clear-vcs-info-on-chpwd
else
  precmd() {
    vcs_info
  }
fi

export PROMPT=$'%{$fg[yellow]%}%n%{$reset_color%}@%{$fg[yellow]%}%m%{$reset_color%} %{$fg[blue]%}%1~%{$reset_color%}${vcs_info_msg_0_} %# '
export SPROMPT="zsh: correct %F{red}'%R'%f to %F{red}'%r'%f [%B%Uy%u%bes, %B%Un%u%bo, %B%Ue%u%bdit, %B%Ua%u%bbort]? "

# {{{1 Options
setopt AUTO_PARAM_SLASH        # tab completing directory appends a slash
setopt NO_FLOW_CONTROL         # disable start (C-s) and stop (C-q) characters
setopt NO_HIST_IGNORE_ALL_DUPS # don't filter non-contiguous duplicates from history
setopt HIST_FIND_NO_DUPS       # don't show dupes when searching
setopt HIST_IGNORE_DUPS        # do filter contiguous duplicates from history
setopt HIST_VERIFY             # confirm history expansion (!$, !!, !foo)
setopt LIST_PACKED             # make completion lists more densely packed
setopt MENU_COMPLETE           # auto-insert first possible ambiguous completion
setopt PUSHD_IGNORE_DUPS       # don't push multiple copies of same dir onto stack
setopt SHARE_HISTORY           # share history across shells

# {{{1 Word style
# NOTE: must come before zsh-history-substring-search & zsh-syntax-highlighting.
autoload -U select-word-style
select-word-style bash # only alphanumeric chars are considered WORDCHARS

# {{{1 LS colors
export CLICOLOR=1
export LSCOLORS=gafacadabaegedabagacad

# {{{1 Base16 Shell
BASE16_SHELL="$HOME/.config/base16-shell/"
[ -n "$PS1" ] && \
  [ -s "$BASE16_SHELL/profile_helper.sh" ] && \
  source "$BASE16_SHELL/profile_helper.sh"

# {{{1 ASDF
# export ASDF_NODEJS_LEGACY_FILE_DYNAMIC_STRATEGY="latest_available" 
# if [ "$HASBREW" != "" ]; then
#   . "$(brew --prefix asdf)/libexec/asdf.sh"
# else
#   . $HOME/.asdf/asdf.sh
# fi
# {{{1 Mise
eval "$(/opt/homebrew/bin/mise activate zsh)"

# {{{1 NVIM/VIM
export EDITOR="nvim"
export VISUAL="$EDITOR"

# {{{1 Vi mode
set -o vi

# {{{1 Command: c
# Taken from rbates: https://github.com/ryanb/dotfiles/blob/master/oh-my-zsh/custom/plugins/rbates/rbates.plugin.zsh
# Allows you to easily cd into code directory with completion
c() { cd ~/code/$1; }
_c() { _path_files -W ~/code -/; }
compdef _c c

# {{{1 Edit command line
autoload -U edit-command-line
zle -N edit-command-line
bindkey '^x^x' edit-command-line

bindkey ' ' magic-space # do history expansion on space

# For speed:
# https://github.com/zsh-users/zsh-autosuggestions#disabling-automatic-widget-re-binding
ZSH_AUTOSUGGEST_MANUAL_REBIND=1

# {{{1 Plugins
source ~/.config/zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.config/zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/.config/zsh/zsh-history-substring-search/zsh-history-substring-search.zsh

# Note that this will only ensure unique history if we supply a prefix
# before hitting "up" (ie. we perform a "search"). HIST_FIND_NO_DUPS
# won't prevent dupes from appearing when just hitting "up" without a
# prefix (ie. that's "zle up-line-or-history" and not classified as a
# "search"). So, we have HIST_IGNORE_DUPS to make life bearable for that
# case.
#
# https://superuser.com/a/1494647/322531
HISTORY_SUBSTRING_SEARCH_ENSURE_UNIQUE=1

# {{{1 Traversing history
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey '^n' history-substring-search-up
bindkey '^p' history-substring-search-down
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down

# {{{1 Searching history
bindkey '^r' history-incremental-pattern-search-backward
bindkey "^s" history-incremental-pattern-search-forward

export LESS="-FXR"
export LESS_TERMCAP_mb="[35m" # magenta
export LESS_TERMCAP_md="[33m" # yellow
export LESS_TERMCAP_me=""      # "0m"
export LESS_TERMCAP_se=""      # "0m"
export LESS_TERMCAP_so="[34m" # blue
export LESS_TERMCAP_ue=""      # "0m"
export LESS_TERMCAP_us="[4m"  # underline

# {{{1 CTRL-Z
# Make CTRL-Z background things and unbackground them.
function fg-bg() {
if [[ $#BUFFER -eq 0 ]]; then
  fg
else
  zle push-input
fi
}
zle -N fg-bg
bindkey '^Z' fg-bg

# {{{1 Aliases
alias g=git
alias v="nvim"
alias vimrc="v ~/.vimrc"
if [[ "$EDITOR" == "nvim" || "$EDITOR" == "lvim" ]]; then
  alias v=$EDITOR
  alias vimrc="v ~/.config/nvim/init.lua"
fi
alias switch-vim=". ~/.local/bin/switch-vim"
alias zshrc="v ~/.zshrc"
alias dot="cd ~/.dotfiles"
alias tmuxconf="v ~/.tmux.conf"
# Rails
alias be="bundle exec"
alias b="bundle"
alias r="bundle exec rails"
alias coverage="COVERAGE=true be rails test"
# Git
alias gca="g commit -a"
alias gcb="g checkout -b"
alias gco="g checkout"
alias gst="g st"
alias gb="g branch"
alias glog="g mylog"
alias gdiff="g diff"
alias gp="g pull --rebase"
alias gpa="g pull --rebase --all"
# Searching
alias '?'=duck
alias '??'=google
alias '???'=bing
# alias nvimrc="nvim ~/.config/nvim/init.lua"

# {{{1 FZF
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# {{{1 gitignore.io
function gi() { curl -sLw "\n" https://www.toptal.com/developers/gitignore/api/"$@" ;}
function nvimrc() { cd ~/.config/nvim && v init.lua }
export PATH="/opt/homebrew/opt/mysql-client/bin:$PATH"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm if it exists
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export PATH="/opt/homebrew/opt/libxml2/bin:$PATH"

export LDFLAGS="-L/opt/homebrew/opt/libxml2/lib"
export CPPFLAGS="-I/opt/homebrew/opt/libxml2/include"

export PKG_CONFIG_PATH="$PK_CONFIG_PATH:/opt/homebrew/opt/libxml2/lib/pkgconfig"
export GPG_TTY=$(tty)

export PATH="/opt/homebrew/opt/mysql-client/bin:$PATH"

bindkey -s "^[f" "tmux-sessionizer\n"
export DOCKER_DEFAULT_PLATFORM=linux/amd64
export PATH="/opt/homebrew/opt/imagemagick@6/bin:$PATH"

# {{{1 YaleSites Specific

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
# function llogin() {
#   # If no args exist, then do a l drush uli | pbcopy
#   # otherwise, attempt to use terminus to get a uli
#   if [ $# -eq 0 ]; then
#     l drush uli | pbcopy
#   else
#     terminus drush "$@" -- user:login | pbcopy
#   fi

#   echo "login copied to clipboard"
# }

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

  local site_name="$1"
  local site_info=$(terminus site:list --fields=id,name | grep "$site_name")

  if [ -z "$site_info" ]; then
    echo "Site not found: $site_name"
    return
  fi

  local site_id=$(echo "$site_info" | awk '{print $1}')

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
  lcr
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

ctags-php() {
  ctags --langmap=php:.engine.inc.module.theme.install.php --php-kinds=cdfi --languages=php --recurse --fields=+l
}

export DEBUG_COLORS=0
export FORCE_COLOR=0

# Find the port that changes each time it's rebuilt for lando instances
dbport() {
  lando info --format json | jq '.[] | select(.service == "database").external_connection.port' | sed 's/[^0-9]//g' | pbcopy
  echo "Database port copied to clipboard"
}

export PKG_CONFIG_PATH="/opt/homebrew/opt/openssl/lib/pkgconfig"
export PKG_CONFIG_PATH="$PKG_CONFIG_PATH:/opt/homebrew/opt/libtiff/lib/pkgconfig"
export PKG_CONFIG_PATH="$PKG_CONFIG_PATH:/opt/homebrew/opt/gmp/lib/pkgconfig"
export PKG_CONFIG_PATH="$PKG_CONFIG_PATH:/opt/homebrew/opt/libpng/lib/pkgconfig"
export PKG_CONFIG_PATH="$PKG_CONFIG_PATH:/opt/homebrew/opt/ncurses/lib/pkgconfig"
export PKG_CONFIG_PATH="$PKG_CONFIG_PATH:/opt/homebrew/opt/mpfr/lib/pkgconfig"
export PKG_CONFIG_PATH="$PKG_CONFIG_PATH:/opt/homebrew/opt/libyaml/lib/pkgconfig"
export PKG_CONFIG_PATH="$PKG_CONFIG_PATH:/opt/homebrew/opt/icu4c/lib/pkgconfig"
export PKG_CONFIG_PATH="$PKG_CONFIG_PATH:/opt/homebrew/opt/readline4/lib/pkgconfig"
export PKG_CONFIG_PATH="$PKG_CONFIG_PATH:/opt/homebrew/opt/webp/lib/pkgconfig"
export PKG_CONFIG_PATH="$PKG_CONFIG_PATH:/opt/homebrew/opt/unixodbc/lib/pkgconfig"
export PKG_CONFIG_PATH="$PKG_CONFIG_PATH:/opt/homebrew/opt/jpeg/lib/pkgconfig"
export PKG_CONFIG_PATH="$PKG_CONFIG_PATH:/opt/homebrew/opt/libpq/lib/pkgconfig"

# {{{1 Ending
#
# End profiling (uncomment when necessary)
#

# Per-command profiling:

# unsetopt xtrace
# exec 2>&3 3>&-

# Per-function profiling:

# zprof
