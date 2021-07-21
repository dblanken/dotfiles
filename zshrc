# vim: nowrap fdm=marker

# {{{ Exports
export CLICOLOR=1
export LSCOLORS="Gxfxcxdxbxegedabagacad"
export PATH=$HOME/.bin:$HOME/.local/bin:$HOME/.local/bin/scripts:$PATH:$HOME/.cargo/bin
# }}}

# {{{ Neovim
# Check if we are nesting nvims
# If we have nvim, make it the default
if [ -x "$(command -v nvim)" ]; then
  export EDITOR=nvim
  alias vim="nvim"

  # If we're in an nvim instance and nvr is installed, use it.
  if [ -n "$NVIM_LISTEN_ADDRESS" ]; then
    if [ -x "$(command -v nvr)"  ]; then
      alias nvim="nvr -cc split --remote-wait +'set bufhidden=wipe'"
      alias vim="nvr -cc split --remote-wait +'set bufhidden=wipe'"

      export EDITOR="nvr -cc split --remote-wait +'set bufhidden=wipe'"
      export VISUAL="nvr -cc split --remote-wait +'set bufhidden=wipe'"
    fi
  fi
else
  export EDITOR='vim'
fi
# }}}

# {{{ ls colors
autoload -U colors && colors
# }}}

# {{{ Vi-mode
bindkey -v
# }}}

# {{{ Autocd
# Auto cd if I give a directory name
setopt autocd
# }}}

# {{{1 MacOS keyboard hack
if [ "$(uname)" = "Darwin" ]; then
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
# }}}

# {{{1 Completion
# Add zsh-completions if it exists
if type brew &>/dev/null; then
  FPATH=/usr/local/share/zsh-completions:$FPATH
fi
autoload -Uz compinit
compinit
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}'

# Complete . and .. special directories
zstyle ':completion:*' special-dirs true
# }}}

# {{{1 VIMODE Display
# set VIMODE according to the current mode (default “[i]”)
VIMODE_INSERT_MODE_COLOR='%F{green}'
VIMODE_NORMAL_MODE_COLOR='%F{blue}'
VIMODE='%F{blue}[i]%f'
function zle-keymap-select {
  VIMODE="${${KEYMAP/vicmd/[n]}/(main|viins)/[i]}"

  if [[ VIMODE == "[n]" ]]; then
    VIMODE="${VIMODE_NORMAL_MODE_COLOR}${VIMODE}"
  else
    VIMODE="${VIMODE_INSERT_MODE_COLOR}${VIMODE}"
  fi
  VIMODE="${VIMODE}%f"

  zle reset-prompt
}

zle -N zle-keymap-select
# }}}

# {{{1 Git in prompt
ZSH_GIT_PROMPT_SUFFIX="%f "
ZSH_GIT_PROMPT_DIRTY="%F{blue}) %F{yellow}✗"
ZSH_GIT_PROMPT_CLEAN="%F{blue})"
autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' stagedstr "%F{green}●%f" # default 'S'
zstyle ':vcs_info:*' unstagedstr "%F{red}●%f" # default 'U'
zstyle ':vcs_info:*' use-simple true
zstyle ':vcs_info:git*:*' formats '[%F{cyan}%b%f%m%c%u] ' # default ' (%s)-[%b]%c%u-'
zstyle ':vcs_info:git*:*' actionformats '[%F{cyan}%b|%a%f%m%c%u] ' # default ' (%s)-[%b|%a]%c%u-'

# check untracked files also
zstyle ':vcs_info:git+set-message:*' hooks git-untracked
function +vi-git-untracked() {
emulate -L zsh
if [[ -n $(git ls-files --exclude-standard --others 2> /dev/null) ]]; then
  hook_com[unstaged]+="%F{blue}●%f"
fi
}

precmd() {
  vcs_info
}

setopt prompt_subst
# }}}

# {{{1 Aliases
# related to editing configuration
alias nvimrc='$EDITOR ~/.config/nvim/init.vim'
alias tmuxconf='$EDITOR ~/.tmux.conf'
alias vimrc='$EDITOR ~/.vimrc'
alias zshrc='$EDITOR ~/.zshrc'

# common commands
alias '?'='duck'
alias '??'='google'
alias '???'='bing'
alias be='bundle exec'
alias bi='bundle install -j 8'
alias g='git'
alias ga='git add'
alias gb='git branch'
alias gc!='git commit -v --amend'
alias gc='git commit -v'
alias gca!='git commit -v -a --amend'
alias gca='git commit -a'
alias gcb='git checkout -b'
alias gco='git checkout'
alias gd='git diff'
alias gk='\gitk --all --branches'
alias gke='\gitk --all $(git log -g --pretty=%h)'
alias glo='git long --oneline --decorate'
alias glog='git log --oneline --decorate --graph'
alias gm='git merge'
alias gma='git merge --abort'
alias gmtvim='git mergetool --no-prompt --tool=vimdiff'
alias gp='git push'
alias gpf!='git push --force'
alias gpristine='git reset --hard && git clean -dffx'
alias gr='git remote'
alias grb='git rebase'
alias grm='git rm'
alias gst='git status'
alias gwip='git add -A; git rm $(git ls-files --deleted) 2> /dev/null; git commit --no-verify --no-gpg-sign -m "--wip-- [skip ci]"'
alias howamidoing="history | awk '{a[\$2]++}END{for(i in a){print a[i] \" \" i}}' | sort -rn | head -20"
alias killruby='pkill -f ruby'
alias rubykill='killruby'
alias u='cd ..'
alias v='vim'
alias x='exit'

# Docker
alias images='docker images'
alias drun='docker run -it'
alias dex='docker exec -it'

# overrides
alias cat='bat'
alias irb='irb --readline -r irb/completion'
alias ls='ls -GFh'
alias mkdir='mkdir -p'
alias vi='vim'
# }}}

# {{{ Battery
# Get Battery Capacity
function battery() {
  ioreg -n AppleSmartBattery -r | awk '$1~/Capacity/{c[$1]=$3} END{OFMT="%.2f%%"; max=c["\"MaxCapacity\""]; print (max>0? 100*c["\"CurrentCapacity\""]/max: "?")}'
}
# }}}

# {{{1 Codebase shortcut
c() { cd ~/code/$1; }
_c() { _files -W ~/code -/; }
compdef _c c
# }}}

# {{{1 chpwd override
chpwd() {
  ls -a
}
# }}}

# {{{1 tmux autostart
# This allows tmux to not only autostart on shell,
# but to graciously exit the terminal when I exit tmux
#
# Taken from ohmyzsh's tmux.plugin.zsh
export ZSH_TMUX_AUTOQUIT=true
export ZSH_TMUX_AUTOSTART=false
function _zsh_tmux_wrapper_run() {
  if [[ -n "$@" ]]; then
    command tmux "$@"
    return $?
  fi

  local -a tmux_cmd
  tmux_cmd=(command tmux)

  $tmux_cmd attach

  if [[ $? -ne 0 ]]; then
    if [[ -z "$TMUX" && "$ZSH_TMUX_AUTOSTART" == "true" ]]; then
      $tmux_cmd new-session
    fi
  fi

  if [[ "$ZSH_TMUX_AUTOQUIT" == "true" ]]; then
    exit
  fi
}

compdef _tmux _zsh_tmux_wrapper_run
alias tmux=_zsh_tmux_wrapper_run

if [[ -z "$TMUX" && -z "$VIM" && "$ZSH_TMUX_AUTOSTART" = true ]]; then
  _zsh_tmux_wrapper_run
fi
# }}}

# {{{1 history substring searching
if [[ -a /usr/local/share/zsh-history-substring-search/zsh-history-substring-search.zsh ]]; then
  source /usr/local/share/zsh-history-substring-search/zsh-history-substring-search.zsh
  bindkey '^[[A' history-substring-search-up
  bindkey '^[[B' history-substring-search-down
fi

setopt share_history          # share command history data
# }}}

# {{{1 asdf
if [[ -a /usr/local/opt/asdf/asdf.sh ]]; then
  source /usr/local/opt/asdf/asdf.sh
fi
# }}}

# {{{1 git overload
#
# `git` wrapper:
#
#     - `git` with no arguments = `git status`; run `git help` to show what
#       vanilla `git` without arguments would normally show.
#     - `git root` = `cd` to repo root.
#     - `git root ARG...` = evals `ARG...` from the root (eg. `git root ls`).
#     - `git ARG...` = behaves just like normal `git` command.
#
function git() {
  if [ $# -eq 0 ]; then
    command git status
  elif [ "$1" = root ]; then
    shift
    local ROOT
    if [ "$(command git rev-parse --is-inside-git-dir 2> /dev/null)" = true ]; then
      if [ "$(command git rev-parse --is-bare-repository)" = true ]; then
        ROOT="$(command git rev-parse --absolute-git-dir)"
      else
        # Note: This is a good-enough, rough heuristic, which ignores
       # the possibility that GIT_DIR might be outside of the worktree;
        # see:
        # https://stackoverflow.com/a/38852055/2103996
        ROOT="$(command git rev-parse --git-dir)/.."
      fi
    else
      # Git 2.13.0 and above:
      ROOT="$(command git rev-parse --show-superproject-working-tree 2> /dev/null)"
      if [ -z "$ROOT" ]; then
        ROOT="$(command git rev-parse --show-toplevel 2> /dev/null)"
      fi
    fi
    if [ -z "$ROOT" ]; then
      ROOT=.
    fi
    if [ $# -eq 0 ]; then
      cd "$ROOT"
    else
      (cd "$ROOT" && eval "$@")
    fi
  else
    command git "$@"
  fi
}
# }}}

# {{{1 Go
export PATH=$PATH:~/go/bin
# }}}

# {{{1 Things I don't use but want to
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down
alias gc='git commit'
# Navigate down quickly
alias -g ...="../.."
alias -g ....="../../.."
alias -g .....="../../../.."
alias -g ......="../../../../.."

alias music='open /Applications/Amazon\ Music.app'
# }}}

# {{{1 Execution time
autoload -U add-zsh-hook

typeset -F SECONDS
function -record-start-time() {
emulate -L zsh
ZSH_START_TIME=${ZSH_START_TIME:-$SECONDS}
}
add-zsh-hook preexec -record-start-time

function -report-start-time() {
emulate -L zsh
if [ $ZSH_START_TIME ]; then
  local DELTA=$(($SECONDS - $ZSH_START_TIME))
  local DAYS=$((~~($DELTA / 86400)))
  local HOURS=$((~~(($DELTA - $DAYS * 86400) / 3600)))
  local MINUTES=$((~~(($DELTA - $DAYS * 86400 - $HOURS * 3600) / 60)))
  local SECS=$(($DELTA - $DAYS * 86400 - $HOURS * 3600 - $MINUTES * 60))
  local ELAPSED=''
  test "$DAYS" != '0' && ELAPSED="${DAYS}d"
  test "$HOURS" != '0' && ELAPSED="${ELAPSED}${HOURS}h"
  test "$MINUTES" != '0' && ELAPSED="${ELAPSED}${MINUTES}m"
  if [ "$ELAPSED" = '' ]; then
    SECS="$(print -f "%.2f" $SECS)s"
  elif [ "$DAYS" != '0' ]; then
    SECS=''
  else
    SECS="$((~~$SECS))s"
  fi
  ELAPSED="${ELAPSED}${SECS}"
  export RPROMPT="%F{cyan}${ELAPSED}%f"
  unset ZSH_START_TIME
else
  export RPROMPT="$RPROMPT_BASE"
fi
}
add-zsh-hook precmd -report-start-time
# }}}

# {{{1 Prompt
PROMPT='${VIMODE} %(?.%F{yellow}%n%f.%F{red}%n%f)@%F{blue}%m%f %F{magenta}%1~%f ${vcs_info_msg_0_}%# '
# }}}

# {{{1 Base16 Shell
BASE16_SHELL="$HOME/.config/base16-shell/"
[ -n "$PS1" ] && \
    [ -s "$BASE16_SHELL/profile_helper.sh" ] && \
        eval "$("$BASE16_SHELL/profile_helper.sh")"
# }}}
