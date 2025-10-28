# General utility functions

# Quick cd into code directory with completion
c() { cd ~/code/$1; }
_c() { _path_files -W ~/code -/; }
compdef _c c

# gitignore.io integration
gi() { curl -sLw "\n" https://www.toptal.com/developers/gitignore/api/"$@" ;}

# Quick edit nvim config
nvimrc() { cd ~/.config/nvim && v init.lua }

# CTRL-Z background/foreground toggle
function fg-bg() {
  if [[ $#BUFFER -eq 0 ]]; then
    fg
  else
    zle push-input
  fi
}
zle -N fg-bg
bindkey '^Z' fg-bg

# SSH agent management
SSH_ENV="$HOME/.ssh/agent-environment"

function start_agent {
  echo "Initialising new SSH agent..."
  /usr/bin/ssh-agent | sed 's/^echo/#echo/' > "${SSH_ENV}"
  echo succeeded
  chmod 600 "${SSH_ENV}"
  . "${SSH_ENV}" > /dev/null
  /usr/bin/ssh-add;
}

# Source SSH settings, if applicable
if [ -f "${SSH_ENV}" ]; then
  . "${SSH_ENV}" > /dev/null
  ps -ef | grep ${SSH_AGENT_PID} | grep ssh-agent$ > /dev/null || {
    start_agent;
  }
else
  start_agent;
fi
