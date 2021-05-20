GIT_CHAR='●'

# Adapted from https://tylercipriani.com/blog/2016/01/19/Command-Timing-Bash-Prompt/
# Human readable time output
# e.g., 5d 6h 3m 2s
__format_time() {
  local _time=$1

  # Don't show anything if time is less than 5 seconds
  (( $_time < 5 )) && return

  local _out
  local days=$(( $_time / 60 / 60 / 24 ))
  local hours=$(( $_time / 60 / 60 % 24 ))
  local minutes=$(( $_time / 60 % 60 ))
  local seconds=$(( $_time % 60 ))
  (( $days > 0 )) && _out="${days}d"
  (( ${#_out} > 0 )) && _out="$_out "
  (( $hours > 0 )) && _out="$_out${hours}h"
  (( ${#_out} > 0 )) && _out="$_out "
  (( $minutes > 0 )) && _out="$_out${minutes}m"
  (( ${#_out} > 0 )) && _out="$_out "
  _out="$_out${seconds}s"
  (( ${#_out} > 0 )) && _out=" $_out"
  printf "$_out"
}

# Adapted from https://jakemccrary.com/blog/2015/05/03/put-the-last-commands-run-time-in-your-bash-prompt/
__timer_start() {
  # Don't do this for completion
  [ -n "$COMP_LINE" ] && unset timer && return

  # Don't pre-exec PROMPT_COMMAND
  [ "$BASH_COMMAND" = "$PROMPT_COMMAND" ] && unset timer && return

  timer=${timer:-$SECONDS}
}

__timer_stop() {
    timer_show="$(($SECONDS - $timer))"
    unset timer
}

__git_unstaged() {
  local c='\e[31m'
  local x='\e[0m'
  local char="${GIT_CHAR}"
  git diff --no-ext-diff --ignore-submodules=dirty --quiet --exit-code 2> /dev/null || echo "$c$char$x"
}

__git_untracked() {
  local c='\e[34m'
  local x='\e[0m'
  local char="${GIT_CHAR}"
  [[ -n "$(git ls-files --exclude-standard --others 2> /dev/null)" ]] && echo "$c$char$x"
}

__git_staged() {
  local c='\e[32m'
  local x='\e[0m'
  local char="${GIT_CHAR}"
  git diff-index --cached --quiet --ignore-submodules=dirty HEAD 2> /dev/null || echo "$c$char$x"
}

__ps1 () {

  # Positionally, this is needed to capture the last status code
  # If it were to be lower, we would get incorrect results
  local last_status=$?
  local ts=$(__format_time "${timer_show}")
  local P='$' # changes to hashtag when root

	# set shortcuts for all the colors
  local r='\[\e[31m\]'
  local g='\[\e[32m\]'
  local h='\[\e[34m\]'
  local u='\[\e[33m\]'
  local p='\[\e[33m\]'
  local w='\[\e[35m\]'
  local b='\[\e[36m\]'
  local lg='\[\e[37m\]'
  local x='\[\e[0m\]'

  # watch out, you're root
  if test "${EUID}" == 0; then
    P='#'
    u=$r
    p=$u
  fi

  local failure="$r!$x"
  local cr=""

  if [[ "$last_status" != "0" ]]; then
    cr="$failure"
  fi

  # Need to look more into this; don't think I need it
  local dir="$(basename $PWD)"
  if test "${dir}" = code ;then
    dir=${PWD#*${PWD%/*/code}}
    dir=${dir#/}
  fi

  local gst=$(__git_staged)
  local gus=$(__git_unstaged)
  local gut=$(__git_untracked)
  local B=$(__git_ps1 " $g[$b%s$g$gst$r$gus$h$gut$g]$x")
  local ts=$(__format_time "${timer_show}")
  local short="$cr$u\u$g@$h\h$g $w$dir$x$B$lg$ts $p$P$x "

  # reset timer for next command
  unset timer
  PS1="${short}"
}

trap '__timer_start' DEBUG
PROMPT_COMMAND="__timer_stop; __ps1;"
