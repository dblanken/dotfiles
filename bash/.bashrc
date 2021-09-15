case $- in
  *i*) ;; # interactive
  *) return ;;
esac

# ----------------------- environment variables ----------------------
#                           (also see envx)

export GITUSER="$USER"
export DOTFILES="$HOME/.dotfiles"
export SNIPPETS="$DOTFILES/snippets/.local/snippets"
export GHREPOS="$HOME/code"
export KN=$GHREPOS

export TERM=xterm-256color
export HRULEWIDTH=73
export EDITOR=vim
export VISUAL=vim
export EDITOR_PREFIX=vim
export GPG_TTY=$(tty)
export THOR_MERGE='$EDITOR -d'
export FZF_DEFAULT_COMMAND="rg --files --hidden --follow --glob '!.git'"
export SCRIPTS="~/.dotfiles/scripts/.local/bin"

test -d ~/.vim/spell && export VIMSPELL=(~/.vim/spell/*.add)

# ------------------------------- os detection -----------------------

[ -z "$OS" ] && export OS=`uname`
case "$OS" in
  Linux)          export PLATFORM=linux ;;
  *indows*)       export PLATFORM=windows ;;
  FreeBSD|Darwin) export PLATFORM=mac ;;
  *)              export PLATFORM=unknown ;;
esac

onmac() {
  [ "$PLATFORM" = mac ] && return 0
  return 1
}

onwin() {
  [ "$PLATFORM" = windows ] && return 0
  return 1
}

onlinux() {
  [ "$PLATFORM" = linux ] && return 0
  return 1
}

onunknown() {
  [ "$PLATFORM" = unknown ] && return 0
  return 1
}

# ------------------------------- pager ------------------------------

if test -x /usr/bin/lesspipe; then
  export LESSOPEN="| /usr/bin/lesspipe %s";
  export LESSCLOSE="/usr/bin/lesspipe %s %s";
fi

export LESS_TERMCAP_mb="[35m" # magenta
export LESS_TERMCAP_md="[33m" # yellow
export LESS_TERMCAP_me="" # "0m"
export LESS_TERMCAP_se="" # "0m"
export LESS_TERMCAP_so="[34m" # blue
export LESS_TERMCAP_ue="" # "0m"
export LESS_TERMCAP_us="[4m"  # underline

# ----------------------------- dircolors ----------------------------

if command -v dircolors &>/dev/null; then
  if test -r ~/.dircolors; then
    eval "$(dircolors -b ~/.dircolors)"
  else
    eval "$(dircolors -b)"
  fi
fi

# ------------------------------- path -------------------------------

pathappend() {
  declare arg
  for arg in "$@"; do
    test -d "${arg}" || continue
    PATH=${PATH//:${arg}:/:}
    PATH=${PATH/#${arg}:/}
    PATH=${PATH/%:${arg}/}
    export PATH="${PATH:+"${PATH}:"}${arg}"
  done
}

pathprepend() {
  for ARG in "$@"; do
    test -d "${ARG}" || continue
    PATH=${PATH//:${ARG}:/:}
    PATH=${PATH/#${ARG}:/}
    PATH=${PATH/%:${ARG}/}
    export PATH="${ARG}${PATH:+":${PATH}"}"
  done
}

# remember last arg will be first in path
pathprepend \
  /usr/local/opt/unzip/bin \
  /usr/local/go/bin \
  ~/.local/bin \
  "$SCRIPTS"

pathappend \
  /usr/local/opt/coreutils/libexec/gnubin \
  /mingw64/bin \
  /usr/local/bin \
  /usr/local/sbin \
  /usr/games \
  /usr/sbin \
  /usr/bin \
  /snap/bin \
  /sbin \
  /bin

# ------------------------------ cdpath ------------------------------

export CDPATH=.:\
~/code:\
~

# ------------------------ bash shell options ------------------------

shopt -s checkwinsize
shopt -s expand_aliases
shopt -s globstar
shopt -s dotglob
shopt -s extglob
#shopt -s nullglob # bug kills completion for some
#set -o noclobber

# ------------------------------ history -----------------------------

export HISTCONTROL=ignoreboth
export HISTSIZE=5000
export HISTFILESIZE=10000

set -o vi
shopt -s histappend

# --------------------------- smart prompt ---------------------------

current_branch() {
  git branch --show-current 2>/dev/null
}

__ps1() {
  local P='$'

  local r='\[\e[31m\]'
  local g='\[\e[0m\]'
  local h='\[\e[34m\]'
  local u='\[\e[33m\]'
  local p='\[\e[33m\]'
  local w='\[\e[35m\]'
  local b='\[\e[36m\]'
  local x='\[\e[0m\]'

  if test "${EUID}" == 0; then
    P='#'
    u=$r
    p=$u
  fi

  local dir;
  if test "$PWD" = "$HOME"; then
    dir='~'
  else
    dir="${PWD##*/}"
    if test "${dir}" = _; then
      dir=${PWD#*${PWD%/*/_}}
      dir=${dir#/}
    elif test "${dir}" = work; then
      dir=${PWD#*${PWD%/*/work}}
      dir=${dir#/}
    fi
  fi

  local B=$(current_branch)
  test "$dir" = "$B" && B='.'

  test -n "$B" && B="$g[$b$B$g]"

  local short="$u\u$g@$h\h$g $w$dir$B$p$P$x "

  PS1="$short"
}

PROMPT_COMMAND="__ps1"

# ------------- source external dependencies / completion ------------

if type brew &>/dev/null; then
  HOMEBREW_PREFIX="$(brew --prefix)"
  if [[ -r "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh" ]]; then
    source "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh"
  else
    for COMPLETION in "${HOMEBREW_PREFIX}/etc/bash_completion.d/"*; do
      [[ -r "$COMPLETION" ]] && source "$COMPLETION"
    done
  fi
else
  owncomp=()
  for i in ${owncomp[@]}; do complete -C $i $i; done

  type gh &>/dev/null && . <(gh completion -s bash)
  type pandoc &>/dev/null && . <(pandoc --bash-completion)
  type yq &>/dev/null && . <(yq shell-completion bash)
fi

# ASDF
if type asdf &>/dev/null; then
  test -d /usr/local/opt/asdf && . /usr/local/opt/asdf/asdf.sh
elif test -f "$HOME/.asdf/asdf.sh"; then
  . "$HOME/.asdf/asdf.sh"
fi

# ------------------------------ aliases -----------------------------

unalias -a
alias grep='grep -i --colour=auto'
alias egrep='egrep -i --colour=auto'
alias fgrep='fgrep -i --colour=auto'
alias curl='curl -L'
alias ls='ls -h --color=auto'
alias '?'=duck
alias '??'=google
alias '???'=bing
alias x="exit"
alias sl="sl -e"
alias mkdirisosec='d=$(isosec);mkdir $d; cd $d'
alias main='cd $(work main)'
alias dot='cd $DOTFILES'
alias scripts='cd $SCRIPTS'
alias free='free -h'
alias df='df -h'
alias top=htop
alias chmox='chmod +x'
alias temp='cd $(mktemp -d)'
alias view='vi -R' # which is usually linked to vim
alias clear='printf "\e[H\e[2J"'
alias dot='cd $DOTFILES'
alias lock='pmset displaysleepnow'

if [[ "$EDITOR" == "vim" ]]; then
  alias vi=vim
elif [[ "$EDITOR" == "nvim" ]]; then
  alias vi=nvim
fi

# ----------------------------- functions ----------------------------

d() { docker "$@"; } && export -f d

# Use c to quickly go to a codebase
c() { cd "$HOME/code/$1"; }
_c()
{
  local curr_arg;

  if [[ -n ${COMP_WORDS} ]]; then
    curr_arg=${COMP_WORDS[COMP_CWORD]}
  else
    curr_arg=""
  fi

  COMPREPLY=($(ls -ld $HOME/code/${curr_arg}*/ | grep ^d | sed s/^.*\\/\//))
}

complete -F _c c

# ----------------------------- tmux auto attach ---------------------

if [[ -z "$TMUX" ]] ;then                              # do not allow "tmux in tmux"
  ID="$( tmux ls | grep -vm1 attached | cut -d: -f1 )" # get the id of a deattached session
  if [[ -z "$ID" ]] ;then                              # if not available create a new one
    tmux new-session
  else
    tmux attach-session -t "$ID"                       # if available, attach to it
  fi
  exit
fi
