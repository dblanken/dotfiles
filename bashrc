# vim: nowrap:expandtab:fdm=marker:tabstop=2:shiftwidth=2

# {{{1 Debugging

# To debug, run a separate process with DEBUG set
# i.e. DEBUG=1 bash
if [ "$DEBUG" == "1" ]; then
  set -x
fi

# }}}

# {{{1 Interactive check

case $- in
  *i*) ;;
  *) return;;
esac

# }}}

# {{{1 Autoload tmux
if command -v tmux &> /dev/null && test -z "$TMUX"; then
  exec tmux new-session -A -s "$(whoami)"
fi
# }}}

# {{{1 OS checks

# Detection of major operating systems. 
[ -z "$OS" ] && export OS=`uname`
case "$OS" in
  Linux)          export PLATFORM=linux ;;
  *indows*)       export PLATFORM=windows ;;
  FreeBSD|Darwin) export PLATFORM=mac ;;
  *)              export PLATFORM=unknown ;;
esac

onmac () {
  [ "$PLATFORM" = mac ] && return 0
  return 1
}

onwin () {
  [ "$PLATFORM" == windows ]  && return 0
  return 1
}

onlinux () {
  [ "$PLATFORM" == linux ]  && return 0
  return 1
}

onunknown () {
  [ "$PLATFORM" == unknown ]  && return 0
  return 1
}

# }}}

# {{{1 BASHRC Hash

# Hash to not muck up our environment variables
typeset -A __BASHRC

# }}}

# {{{1 Color Hash

typeset -A __COLORS

__COLORS[BLACK]=$'\[\e[30m\]'
__COLORS[RED]=$'\[\e[31m\]'
__COLORS[GREEN]=$'\[\e[32m\]'
__COLORS[BROWN]=$'\[\e[33m\]'
__COLORS[BLUE]=$'\[\e[34m\]'
__COLORS[PURPLE]=$'\[\e[35m\]'
__COLORS[CYAN]=$'\[\e[36m\]'
__COLORS[LIGHTGRAY]=$'\[\e[37m\]'
__COLORS[DARKGRAY]=$'\[\e[1;30m\]'
__COLORS[LIGHTRED]=$'\[\e[1;31m\]'
__COLORS[LIGHTGREEN]=$'\[\e[1;32m\]'
__COLORS[YELLOW]=$'\[\e[1;33m\]'
__COLORS[LIGHTBLUE]=$'\[\e[1;34m\]'
__COLORS[LIGHTPURPLE]=$'\[\e[1;35m\]'
__COLORS[LIGHTCYAN]=$'\[\e[1;36m\]'
__COLORS[WHITE]=$'\[\e[1;37m\]'
__COLORS[RESET]=$'\[\e[0m\]'

# }}}

# {{{1 Environment variables

# export TERM=xterm-256color
export EDITOR=vi
export VISUAL=vi
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CONFIG_HOME="$HOME/.config"
export TERMINFO_DIRS="$HOME/.local/share/terminfo"
export SHELL_SESSION_HISTORY=0
export DOTFILES_PATH="$HOME/code/dotfiles"
# If execution time gets in the way ever, set this to 0 to disable
__BASHRC[EXEC_TIME]=1

if [ -d ~/.vim/spell ]; then
  export VIMSPELL=(~/.vim/spell/*.add)
fi

if ! test -d "$XDG_DATA_HOME/terminfo"; then
  mkdir -p "$XDG_DATA_HOME/terminfo"
fi
# }}}

# {{{1 Dry Hax

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
if [ -d "$DOTFILES_PATH" ] && [ -x "$DOTFILES_PATH/dry/dry" ]; then
  "$DOTFILES_PATH/dry/dry" 0.0166666666667 > /dev/null
fi

# }}}

# {{{1 Pager

if test -x /usr/bin/lesspipe; then
  export LESSOPEN="| /usr/bin/lesspipe %s";
  export LESSCLOSE="/usr/bin/lesspipe %s %s";
fi

if ! test -d "$XDG_DATA_HOME/less"; then
  mkdir -p "$XDG_DATA_HOME/less"
fi

export LESSHISTFILE="$XDG_DATA_HOME/less/lesshst"

export LESS_TERMCAP_mb="[35m" # magenta
export LESS_TERMCAP_md="[33m" # yellow
export LESS_TERMCAP_me="" # "0m"
export LESS_TERMCAP_se="" # "0m"
export LESS_TERMCAP_so="[34m" # blue
export LESS_TERMCAP_ue="" # "0m"
export LESS_TERMCAP_us="[4m"  # underline

# }}}

# {{{1 History

if ! test -d "$XDG_DATA_HOME/bash"; then
  mkdir -p "$XDG_DATA_HOME/bash"
fi

export HISTCONTROL=ignoreboth
export HISTSIZE=5000
export HISTFILESIZE=10000
export HISTFILE=$XDG_DATA_HOME/bash/history
set -o vi
shopt -s histappend

# }}}

# {{{1 Bash shell options

shopt -s checkwinsize
shopt -s globstar
shopt -s dotglob
shopt -s extglob

# }}}

# {{{ Aliasses

alias clear='printf "\e[H\e[2J"'
if onlinux; then
	alias ls='ls -h --color=auto'
elif onmac; then
	alias ls='ls -h -G'
fi

alias gst='git status'
alias gca='git commit -a'
alias gb='git branch'
alias gcb='git checkout -b'
alias gco='git checkout'

alias be='bundle exec'

alias git='hub'
alias tmux='tmux -f "$XDG_CONFIG_HOME/tmux/tmux.conf"'
alias vim='vim -u "$XDG_CONFIG_HOME/vim/vimrc"'

alias '?'='duck'
alias '??'='google'
alias '???'='bing'

if onlinux; then
  alias grep='grep -i --colour=auto'
  alias egrep='egrep -i --colour=auto'
  alias fgrep='fgrep -i --colour=auto'
elif onmac; then
  alias grep='ggrep -i --colour=auto'
  alias egrep='gegrep -i --colour=auto'
  alias fgrep='gfgrep -i --colour=auto'
fi

alias curl='curl -L'
alias scripts='cd "$XDG_CONFIG_HOME/scripts"'

alias irb='irb --readline -r irb/completion'
alias mkdir='mkdir -p'

if ! test -d "$XDG_DATA_HOME/wget"; then
  mkdir -p "$XDG_DATA_HOME/wget"
fi
alias wget='wget --hsts-file="$XDG_DATA_HOME/wget/hsts"'

# I like saving some keystrokes
# If I cd, I ls
function cd {
  builtin cd "$@" && ls -F
}

# I like to use c to get into my code
c() {
  cd "$HOME/code/$1" || return
}
_c_complete() {
  local file
  for file in ~/code/"$2"*; do
    [[ -d $file ]] || continue
    COMPREPLY+=( $(basename "$file") )
  done
}

complete -F _c_complete c
# }}}

# {{{1 Dircolors

if command -v dircolors &>/dev/null; then
  __BASHRC[DIRCOLORS_EXE]="dircolors"
elif command -v gdircolors &>/dev/null; then
  __BASHRC[DIRCOLORS_EXE]="gdircolors"
fi

if test -z "${__BASHRC[DIRCOLORS_EXE]}"; then
  if test -r "$XDG_CONFIG_HOME/ls/dircolors"; then
    eval "$("${__BASHRC[DIRCOLORS_EXE]}" -b "$XDG_CONFIG_HOME/ls/dircolors")"
  else
    eval "$(${__BASHRC[DIRCOLORS_EXE]} -b)"
  fi
fi

# }}}

# {{{1 ASDF
export ASDF_DIR="$XDG_DATA_HOME/asdf"
export ASDF_DATA_DIR="$XDG_DATA_HOME/asdf"
export ASDF_CONFIG_FILE="$XDG_CONFIG_HOME/asdf/asdfrc"
export ASDF_GEM_DEFAULT_PACKAGES_FILE="$XDG_CONFIG_HOME/asdf/default-gems"
export ASDF_PYTHON_DEFAULT_PACKAGES_FILE="$XDG_CONFIG_HOME/asdf/default-python-packages"
if test -d "$ASDF_DIR"; then
  # shellcheck source=/home/me/.local/share/asdf/asdf.sh
  . "$ASDF_DIR/asdf.sh"
  # shellcheck source=/home/me/.local/share/asdf/completions/asdf.bash
  . "$ASDF_DIR/completions/asdf.bash"
else
  install_asdf() {
    mkdir -p "$XDG_CONFIG_HOME/asdf"
    echo "Installing prerequesites for ASDF"
    if onlinux; then
      echo "Apt installing curl and git"
      sudo apt install curl git
    elif onmac; then
      echo "Brew installing curl and git"
      brew install curl git
    fi
    echo "Cloning ASDF"
    git clone https://github.com/asdf-vm/asdf.git "$ASDF_DIR" --branch v0.8.1 

    # shellcheck source=/home/me/.local/share/asdf/asdf.sh
    . "$ASDF_DIR/asdf.sh"
    # shellcheck source=/home/me/.local/share/asdf/completions/asdf.bash
    . "$ASDF_DIR/completions/asdf.bash"
  }
fi

# }}}

# {{{1 Prompt
__BASHRC[ITALIC_ON]=$'\[\e[3m\]'
__BASHRC[ITALIC_OFF]=$'\[\e[23m\]'
__BASHRC[BRANCH]=''

# {{{2 Tmux title

function __set-tab-and-window-title() {
  # local CMD="${1:gs/$/\\$}"
  # print -Pn "\e]0;$CMD:q\a"

  local CMD="$1"
  printf "\033]2;%s\033\\" "$CMD"
  # printf "\e]0;%s:q\a" "$CMD"
}

# $HISTCMD (the current history event number) is shared across all shells
# (due to SHARE_HISTORY). Maintain this local variable to count the number of
# commands run in this specific shell.
HISTCMD_LOCAL=0

# Executed before displaying prompt.
function __update-window-title-precmd() {
  HISTCMD_LOCAL=$((++HISTCMD_LOCAL))
  if [[ HISTCMD_LOCAL -eq 0 ]]; then
    # About to display prompt for the first time; nothing interesting to show in
    # the history. Show $PWD.
    __set-tab-and-window-title "$(basename $PWD)"
  else
    local LAST=$(history | tail -1 | awk '{print $2}')
    # Skip ENV=settings, sudo, ssh; show first distinctive word of command;
    # mostly stolen from:
    #   https://github.com/robbyrussell/oh-my-zsh/blob/master/lib/termsupport.zsh
    # local TRIMMED="${LAST[(wr)^(*=*|mosh|ssh|sudo)]}"

    if [ -n "$TMUX" ]; then
      if [ -z "$LAST" ]; then
        LAST="$(basename $PWD)"
      fi
      # Inside tmux, just show the last command: tmux will prefix it with the
      # session name (for context).
      __set-tab-and-window-title "$LAST"
    else
      # Outside tmux, show $PWD (for context) followed by the last command.
      __set-tab-and-window-title "$(basename $PWD) > $LAST"
    fi
  fi
}
# }}}

# {{{2 Execution time & tmux window update

# Human readable time output
# e.g., 5d 6h 3m 2s
format_time() {
  local _time=$1

  # Don't show anything if time is less than 5 seconds
  (( _time < 5 )) && return

  local _out
  local days=$(( _time / 60 / 60 / 24 ))
  local hours=$(( _time / 60 / 60 % 24 ))
  local minutes=$(( _time / 60 % 60 ))
  local seconds=$(( _time % 60 ))
  (( days > 0 )) && _out=" ${days}d"
  (( hours > 0 )) && _out="$_out ${hours}h"
  (( minutes > 0 )) && _out="$_out ${minutes}m"
  (( seconds >= 5 )) && _out="$_out ${seconds}s"
  printf "%s" "$_out"
}

debug() {
  # do nothing if completing
  [ -n "$COMP_LINE" ] && return

    # don't cause a preexec for $PROMPT_COMMAND
    [ "$BASH_COMMAND" = "$PROMPT_COMMAND" ] && return

    start_time=$(date +'%s')

    __update-window-title-precmd "${PWD##*/}"
  }

if test -n "${__BASHRC[EXEC_TIME]}" && test "${__BASHRC[EXEC_TIME]}" == "1"; then
  trap 'debug' DEBUG
fi

# }}}

# {{{2 Shell level
# Get the shell level based on whether in TMUX
__level() {
  local TMUXING
  TMUXING=$(case "$TERM" in
  tmux*) echo tmux;;
  screen*) echo tmux;;
  *) ;;
esac)
  if [ -n "$TMUXING" ] && [ -n "$TMUX" ]; then
    local LVL=$((SHLVL - 1))
  else
    local LVL=$SHLVL
  fi

  # When using exec tmux, shell level is 0
  if [ "$LVL" == "0" ]; then
    LVL=1
  fi

  __BASHRC[LVL]=$LVL
}

# }}}

# {{{2 Git status

# Set indicators for staged, unstaged, and untracked files for prompt
__git_stats() {
  local STATUS
  local UNTRACKED
  local STAGED
  local UNSTAGED

  local GIT_DOT="●"
  STATUS=$(git status -s 2> /dev/null)
  UNTRACKED=$(echo "$STATUS" | grep -c '^??')
  STAGED=$(($(echo "$STATUS" | grep -c '^M ') + $(echo "$STATUS" | grep -c '^D ') + $(echo "$STATUS" | grep -c '^R ') + $(echo "$STATUS" | grep -c '^C ')+$(echo "$STATUS" | grep -c '^A ')))
  UNSTAGED=$(echo "$STATUS" | grep -c '^ M')

  if [ "$UNTRACKED" != 0 ]; then
    __BASHRC[GIT_UNTRACKED]="${GIT_DOT}"
  else
    __BASHRC[GIT_UNTRACKED]=""
  fi

  if [ "$STAGED" != 0 ]; then
    __BASHRC[GIT_STAGED]="${GIT_DOT}"
  else
    __BASHRC[GIT_STAGED]=""
  fi

  if [ "$UNSTAGED" != 0 ]; then
    __BASHRC[GIT_UNSTAGED]="${GIT_DOT}"
  else
    __BASHRC[GIT_UNSTAGED]=""
  fi
}

# }}}

# {{{2 Unicode prompt

# To help not to be in subshell hell, print the number of unicode prompt characters as the number
# of subshells we are in.
__print_unicode_prompt() {
  __level
  i=1
  while [ "$i" -le "${__BASHRC[LVL]}" ]; do
    printf '\u276f'
    i=$((i + 1))
  done
}

# }}}

__ps1() {
  if [ "$DEBUG" == "1" ]; then
    set -x
  fi

  # Exit status
  if test "$?" != "0"; then
    __BASHRC[EXIT_STATUS]="!"
  else
    __BASHRC[EXIT_STATUS]=""
  fi

  if test -n "${__BASHRC[EXEC_TIME]}" && test "${__BASHRC[EXEC_TIME]}" == "1"; then
    # Calculate execution time
    # See trap debug and debug()
    end_time=$(date +'%s')
    time_f=$(format_time $(( end_time - start_time )))
  else
    time_f=""
  fi

  # Get jobs if any exist
  __BASHRC[JOBS]=""
  if test -n "$(jobs 2>/dev/null)"; then
    __BASHRC[JOBS]="\j"
  fi

  # Only do git stuff if we have it
  if command -v git &>/dev/null; then
    __git_stats
    __BASHRC[BRANCH]=$(git branch --show-current 2>/dev/null)
    if test -n "${__BASHRC[BRANCH]}"; then
      __BASHRC[BRANCH]=" ${__COLORS[DARKGRAY]}[${__BASHRC[BRANCH]}${__COLORS[GREEN]}${__BASHRC[GIT_STAGED]}${__COLORS[RED]}${__BASHRC[GIT_UNSTAGED]}${__COLORS[BLUE]}${__BASHRC[GIT_UNTRACKED]}${__COLORS[DARKGRAY]}]"
    fi
  fi

  # Green SSH information
  # Blue directory
  # Yellow jobs number
  # Dark Gray Git Branch (green dot = staged, red dot = unstaged, blue dot = untracked)
  # Dark Gray Execution time (if more than 5s) (if enabled)
  # Red > (one for each subshell level)
  PS1="${__COLORS[GREEN]}${SSH_TTY:+\u@\h}${__COLORS[RESET]}${SSY_TTY:+:}${__COLORS[BLUE]}\W${__COLORS[YELLOW]}${__BASHRC[JOBS]}${__BASHRC[EXIT_STATUS]}${__BASHRC[BRANCH]}${__COLORS[DARKGRAY]}${__BASHRC[ITALIC_ON]}${time_f}${__BASHRC[ITALIC_OFF]} ${__COLORS[RED]}$(__print_unicode_prompt) ${__COLORS[RESET]}"

  # Reset prompt since we're out of a process
  __set-tab-and-window-title "${PWD##*/}"

  if [ "$DEBUG" == "1" ]; then
    set +x
  fi
}

PROMPT_COMMAND="__ps1"

# }}}

# {{{ Completion
if type brew &>/dev/null; then
  HOMEBREW_PREFIX="$(brew --prefix)"
  if [[ -r "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh" ]]; then
    source "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh"
  else
    for COMPLETION in "${HOMEBREW_PREFIX}/etc/bash_completion.d/"*; do
      [[ -r "$COMPLETION" ]] && source "$COMPLETION"
    done
  fi
fi

if [ -f "/etc/bash_completion" ]; then
  source /etc/bash_completion
else
  for COMPLETION in "/etc/bash_completion.d/"*; do
    [[ -r "$COMPLETION" ]] && . "$COMPLETION"
  done
fi
# }}}

# {{{1 Paths
export PATH="$XDG_CONFIG_HOME/scripts:$PATH"

export CDPATH=.:\
~/code:\
~/.config:\
~

# }}}

# {{{1 Debugging

if [ "$DEBUG" == "1" ]; then
  set +x
fi

# }}}
