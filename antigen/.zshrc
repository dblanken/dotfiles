export XDG_CONFIG_HOME=$HOME/.config
export XDG_DATA_HOME=$HOME/.local
export EDITOR='nvim'
export PATH="$XDG_DATA_HOME/bin:$PATH"
export ZSH_TMUX_AUTOSTART=true

setopt functionargzero
setopt hist_ignore_space

autoload -Uz bashcompinit && bashcompinit
autoload -Uz compinit && compinit

source $XDG_CONFIG_HOME/antigen/dblanken.plugin.zsh
source $XDG_CONFIG_HOME/antigen/antigen.zsh

antigen use oh-my-zsh

antigen bundle 'zsh-users/zsh-syntax-highlighting'
antigen bundle 'zsh-users/zsh-autosuggestions'
antigen bundle git
antigen theme denysdovhan/spaceship-prompt

antigen apply

set -o vi

SPACESHIP_PROMPT_ORDER=(
  vi_mode
  user
  host
  exit_code
  char
  )
SPACESHIP_RPROMPT_ORDER=(
  exec_time
  ruby
  git
  dir
  )

SPACESHIP_DIR_PREFIX=''
SPACESHIP_GIT_PREFIX=''
SPACESHIP_CHAR_SYMBOL='❯ '
SPACESHIP_PROMPT_PREFIXES_SHOW=false
eval spaceship_vi_mode_enable

if hash nvim 2>/dev/null; then
  export EDITOR=nvim

  if [ -n "$NVIM_LISTEN_ADDRESS" ]; then
    alias nvim=nvr -cc split --remote-wait +'set bufhidden=wipe'

    export VISUAL="nvr -cc split --remote-wait +'set bufhidden=wipe'"
    export EDITOR="nvr -cc split --remote-wait +'set bufhidden=wipe'"
  fi
else
  export EDITOR=vim
fi

export HISTSIZE=100000000
export SAVEHIST=$HISTSIZE
export HISTFILE=$HOME/.local/zsh_history

if [[ -d "$XDG_CONFIG_HOME/bin" ]]; then
  export PATH="$XDG_CONFIG_HOME/bin:$PATH"
fi

# Use nvim as manpager `:h Man`
export MANPAGER='nvim +Man!'

if [ -f "$HOME/.asdf/asdf.sh" ]; then
  . $HOME/.asdf/asdf.sh
  . $HOME/.asdf/completions/asdf.bash
fi

# Tmux autostart
if [[ -z "$TMUX" ]] ;then                              # do not allow "tmux in tmux"
  ID="$( tmux ls | grep -vm1 attached | cut -d: -f1 )" # get the id of a deattached session
  if [[ -z "$ID" ]] ;then                              # if not available create a new one
    tmux new-session
  else
    tmux attach-session -t "$ID"                       # if available, attach to it
  fi
  exit
fi
