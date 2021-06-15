# vim: nowrap:expandtab:fdm=marker:tabstop=2:shiftwidth=2

# {{{1 Interactive check

case $- in
  *i*) ;;
  *) return;;
esac

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

if [ -d ~/.vim/spell ]; then
  export VIMSPELL=(~/.vim/spell/*.add)
fi

if ! test -d "$XDG_DATA_HOME/terminfo"; then
  mkdir -p "$XDG_DATA_HOME/terminfo"
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
alias ls='ls -h --color=auto'

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

alias grep='grep -i --colour=auto'
alias egrep='egrep -i --colour=auto'
alias fgrep='fgrep -i --colour=auto'

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
  cd ~/code/$1
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

if test -z $dircolor; then
  if test -r "$XDG_CONFIG_HOME/ls/dircolors"; then
    eval "$(${__BASHRC[DIRCOLORS_EXE]} -b $XDG_CONFIG_HOME/ls/dircolors)"
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
  . "$ASDF_DIR/asdf.sh"
  . "$ASDF_DIR/completions/asdf.bash"
else
  install_asdf() {
    mkdir -p "$XDG_CONFIG_HOME/asdf"
    echo "Installing prerequesites for ASDF"
    echo "Apt installing curl and git"
    sudo apt install curl git
    echo "Cloning ASDF"
    git clone https://github.com/asdf-vm/asdf.git "$ASDF_DIR" --branch v0.8.1 

    . "$ASDF_DIR/asdf.sh"
    . "$ASDF_DIR/completions/asdf.bash"
  }
fi

# }}}

# {{{1 Prompt
__BASHRC[ITALIC_ON]=$'\[\e[3m\]'
__BASHRC[ITALIC_OFF]=$'\[\e[23m\]'
__BASHRC[BRANCH]=''

# {{{2 Execution time

# Human readable time output
# e.g., 5d 6h 3m 2s
format_time() {
  local _time=$1

  # Don't show anything if time is less than 5 seconds
  (( $_time < 5 )) && return

  local _out
  local days=$(( $_time / 60 / 60 / 24 ))
  local hours=$(( $_time / 60 / 60 % 24 ))
  local minutes=$(( $_time / 60 % 60 ))
  local seconds=$(( $_time % 60 ))
  (( $days > 0 )) && _out=" ${days}d"
  (( $hours > 0 )) && _out="$_out ${hours}h"
  (( $minutes > 0 )) && _out="$_out ${minutes}m"
  (( $seconds >= 5 )) && _out="$_out ${seconds}s"
  printf "$_out"
}

debug() {
  # do nothing if completing
  [ -n "$COMP_LINE" ] && return

    # don't cause a preexec for $PROMPT_COMMAND
    [ "$BASH_COMMAND" = "$PROMPT_COMMAND" ] && return

    start_time=$(date +'%s')
  }

trap 'debug' DEBUG

# }}}

# {{{2 Shell level
# Get the shell level based on whether in TMUX
__level() {
  local TMUXING=$(case "$TERM" in
  tmux*) echo tmux;;
  screen*) echo tmux;;
  *) ;;
esac)
  if [ -n "$TMUXING" -a -n "$TMUX" ]; then
    local LVL=$(($SHLVL - 1))
  else
    local LVL=$SHLVL
  fi

  __BASHRC[LVL]=$LVL
}

# }}}

# {{{2 Git status

# Set indicators for staged, unstaged, and untracked files for prompt
__git_stats() {
  local GIT_DOT="●"
  local STATUS=$(git status -s 2> /dev/null)
  local UNTRACKED=$(echo "$STATUS" | grep '^??' | wc -l)
  local STAGED=$(($(echo "$STATUS" | grep '^M ' | wc -l) + $(echo "$STATUS" | grep '^D ' | wc -l) + $(echo "$STATUS" | grep '^R ' | wc -l) + $(echo "$STATUS" | grep '^C ' | wc -l)+$(echo "$STATUS" | grep '^A ' | wc -l)))
  local UNSTAGED=$(echo "$STATUS" | grep '^ M' | wc -l)

  if [ $UNTRACKED != 0 ]; then
    __BASHRC[GIT_UNTRACKED]="${GIT_DOT}"
  else
    __BASHRC[GIT_UNTRACKED]=""
  fi

  if [ $STAGED != 0 ]; then
    __BASHRC[GIT_STAGED]="${GIT_DOT}"
  else
    __BASHRC[GIT_STAGED]=""
  fi

  if [ $UNSTAGED != 0 ]; then
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
    i=$(($i + 1))
  done
}

# }}}

__ps1() {
  # Exit status
  if test "$?" != "0"; then
    __BASHRC[EXIT_STATUS]="!"
  else
    __BASHRC[EXIT_STATUS]=""
  fi

  # Calculate execution time
  # See trap debug and debug()
  end_time=$(date +'%s')
  time_f=$(format_time $(( end_time - start_time )))

  # Get jobs if any exist
  __BASHRC[JOBS]=""
  if test -n "$(jobs 2>/dev/null)"; then
    __BASHRC[JOBS]="\j"
  fi

  # Only do git stuff if we have it
  if which git &>/dev/null; then
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
  # Dark Gray Execution time (if more than 5s)
  # Red > (one for each subshell level)
  PS1="${__COLORS[GREEN]}${SSH_TTY:+\u@\h}${__COLORS[RESET]}${SSY_TTY:+:}${__COLORS[BLUE]}\w${__COLORS[YELLOW]}${__BASHRC[JOBS]}${__BASHRC[EXIT_STATUS]}${__BASHRC[BRANCH]}${__COLORS[DARKGRAY]}${__BASHRC[ITALIC_ON]}${time_f}${__BASHRC[ITALIC_OFF]} ${__COLORS[RED]}$(__print_unicode_prompt) ${__COLORS[RESET]}"
}

PROMPT_COMMAND="__ps1"

# }}}

# {{{ Completion
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
# }}}
