__ps1 () {

  # Positionally, this is needed to capture the last status code
  # If it were to be lower, we would get incorrect results
  local last_status=$?
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

  local dir="$(basename $PWD)"
  if test "${dir}" = code ;then
    dir=${PWD#*${PWD%/*/code}}
    dir=${dir#/}
  fi

  local B=$(__git_ps1 " %s")
  local short="$cr$u\u$g@$h\h$g $w$dir$x$B$lg $p$P$x "

  PS1="${short}"
}

PROMPT_COMMAND="__ps1;"
