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

# {{{1 Tmux auto-attach
if [ "$TMUX" = "" ]; then tmux attach || tmux -2 new -s "$HOST" && exit; fi

typeset -A __DBLANKEN
__DBLANKEN[ITALIC_ON]=$'\e[3m'
__DBLANKEN[ITALIC_OFF]=$'\e[23m'

# {{{1 Core exports
# Set local path
export GOPATH="$HOME/.go"
export PATH="./bin":"$HOME/bin":"$HOME/.bin":"$HOME/.local/bin":"$HOME/.lando/bin":"$PATH"
if command -v go &> /dev/null; then
  export PATH="$PATH":$HOME/.go/bin
fi
export NVIM_APPNAME="lazyvim"
# opt out of azure telemetry
export FUNCTIONS_CORE_TOOLS_TELEMETRY_OUTPUT=1

FPATH="$HOME/.docker/completions:$FPATH"

# {{{1 Completion system
# Use -C flag to skip security check if zcompdump is less than 24 hours old
# This speeds up shell startup significantly when completions are cached
autoload -Uz compinit
if [[ -n ${ZDOTDIR}/.zcompdump(#qN.mh+24) ]]; then
  # zcompdump is older than 24 hours, regenerate
  compinit -u
else
  # zcompdump is fresh, use cached version
  compinit -C -u
fi

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

# {{{1 Prompt with async git status
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

# {{{1 Shell options
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

# {{{1 Vi mode
set -o vi

# {{{1 Edit command line
autoload -U edit-command-line
zle -N edit-command-line
bindkey '^x^x' edit-command-line
bindkey ' ' magic-space # do history expansion on space

# {{{1 Plugin configuration
# For speed: https://github.com/zsh-users/zsh-autosuggestions#disabling-automatic-widget-re-binding
ZSH_AUTOSUGGEST_MANUAL_REBIND=1

# {{{1 Load plugins
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

# {{{1 History navigation
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey '^n' history-substring-search-up
bindkey '^p' history-substring-search-down
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down

# {{{1 History searching
bindkey '^r' history-incremental-pattern-search-backward
bindkey "^s" history-incremental-pattern-search-forward

# {{{1 Tmux sessionizer keybinding
bindkey -s "^[f" "tmux-sessionizer\n"

# {{{1 FZF
eval "$(fzf --zsh)"

# {{{1 Load modular configuration
# Source configuration files in specific order for cross-platform support
if [ -d ~/.config/zsh/rc.d ]; then
  # 1. Load platform detection first (sets OS_TYPE and provides wrappers)
  [ -f ~/.config/zsh/rc.d/platform.zsh ] && source ~/.config/zsh/rc.d/platform.zsh

  # 2. Load cross-platform environment configuration
  [ -f ~/.config/zsh/rc.d/env.zsh ] && source ~/.config/zsh/rc.d/env.zsh

  # 3. Load platform-specific environment configuration
  if [ -f ~/.config/zsh/rc.d/env.$OS_TYPE.zsh ]; then
    source ~/.config/zsh/rc.d/env.$OS_TYPE.zsh
  fi

  # 4. Load aliases and functions
  [ -f ~/.config/zsh/rc.d/aliases.zsh ] && source ~/.config/zsh/rc.d/aliases.zsh
  [ -f ~/.config/zsh/rc.d/functions.zsh ] && source ~/.config/zsh/rc.d/functions.zsh

  # 5. Load remaining configuration files (e.g., yalesites.zsh)
  for rc_file in ~/.config/zsh/rc.d/*.zsh; do
    # Skip files already loaded
    case "$rc_file" in
      *platform.zsh|*env.zsh|*env.darwin.zsh|*env.linux.zsh|*aliases.zsh|*functions.zsh)
        continue
        ;;
    esac
    [ -f "$rc_file" ] && source "$rc_file"
  done
  unset rc_file
fi

# In case I use CTRL-S/CTRL-Q - stop Terminal from taking over
stty -ixon

# {{{1 Ending
#
# End profiling (uncomment when necessary)
#
# Per-command profiling:
# unsetopt xtrace
# exec 2>&3 3>&-

# Per-function profiling:
# zprof

# Source additional PATH configuration if present (Claude Code or other tools)
[ -f "$HOME/.local/bin/env" ] && . "$HOME/.local/bin/env"
