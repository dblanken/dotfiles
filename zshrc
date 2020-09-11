# vim: nowrap fdm=marker
#
# Exports
export EDITOR='nvim'
export CLICOLOR=1
export LSCOLORS="Gxfxcxdxbxegedabagacad"

# ls colors
autoload -U colors && colors

# Vi-mode
bindkey -v

# Auto cd if I give a directory name
setopt autocd

# {{{1 Completion
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
alias zshrc='$EDITOR ~/.zshrc'
alias vimrc='$EDITOR ~/.vimrc'
alias tmuxconf='$EDITOR ~/.tmuxconf'

# common commands
alias u='cd ..'
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
alias gr='git remote'
alias grb='git rebase'
alias grm='git rm'
alias gst='git status'
alias gwip='git add -A; git rm $(git ls-files --deleted) 2> /dev/null; git commit --no-verify --no-gpg-sign -m "--wip-- [skip ci]"'
alias v='vim'
alias bi='bundle install -j 8'
alias howamidoing="history | awk '{a[\$2]++}END{for(i in a){print a[i] \" \" i}}' | sort -rn | head -20"
alias killruby='pkill -f ruby'
alias rubykill='killruby'

# overrides
alias cat='bat'
alias irb='irb --readline -r irb/completion'
alias mkdir='mkdir -p'
alias vi='vim'
alias vim='nvim'
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
export ZSH_TMUX_AUTOSTART=true
function _zsh_tmux_wrapper_run() {
  if [[ -n "$@" ]]; then
    command tmux "$@"
    return $?
  fi

  local -a tmux_cmd
  tmux_cmd=(command tmux)

  $tmux_cmd attach

  if [[ $? -ne 0 ]]; then
    $tmux_cmd new-session
  fi

  if [[ "$ZSH_TMUX_AUTOQUIT" == "true" ]]; then
    exit
  fi
}

compdef _tmux _zsh_tmux_wrapper_run
alias tmux=_zsh_tmux_wrapper_run

if [[ -z "$TMUX" && -z "$VIM" ]]; then
  _zsh_tmux_wrapper_run
fi
# }}}

# {{{1 history substring searching
source /usr/local/share/zsh-history-substring-search/zsh-history-substring-search.zsh
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

setopt share_history          # share command history data
# }}}

# {{{1 asdf
source /usr/local/opt/asdf
export PATH=$HOME/.asdf/shims:$PATH
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

# {{{1 Spectrum coloring
# A script to make using 256 colors in zsh less painful.
# P.C. Shyamshankar <sykora@lucentbeing.com>
# Copied from https://github.com/sykora/etc/blob/master/zsh/functions/spectrum/

typeset -AHg FX FG BG

FX=(
  reset     "%{[00m%}"
  bold      "%{[01m%}" no-bold      "%{[22m%}"
  italic    "%{[03m%}" no-italic    "%{[23m%}"
  underline "%{[04m%}" no-underline "%{[24m%}"
  blink     "%{[05m%}" no-blink     "%{[25m%}"
  reverse   "%{[07m%}" no-reverse   "%{[27m%}"
)

for color in {000..255}; do
  FG[$color]="%{[38;5;${color}m%}"
  BG[$color]="%{[48;5;${color}m%}"
done
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
PROMPT='${VIMODE} %(?..%F{red}!%f)%F{yellow}%n%f@%F{blue}%m%f %F{magenta}%1~%f ${vcs_info_msg_0_}%# '
# }}}