# General utility functions

# Quick cd into code directory with completion
# Supports direct paths (c apps/HomeschoolRunner) and bare project names (c HomeschoolRunner)
c() {
  local target=${1:-.}
  [[ "$target" == "." ]] && { cd ~/code; return; }

  # Direct path match
  if [[ -d ~/code/$target ]]; then
    cd ~/code/$target
    return
  fi

  # Search for directory by name, excluding internal dirs
  local found
  found=$(find ~/code -mindepth 2 -maxdepth 5 \
    \( -name '.git' -o -name 'node_modules' -o -name 'dist' -o -name 'build' \) -prune \
    -o -type d -name "$target" -print 2>/dev/null | head -1)

  if [[ -n "$found" ]]; then
    cd "$found"
  else
    echo "c: not found: $target" >&2
    return 1
  fi
}

_c() {
  local base=$HOME/code
  local -a repos

  # Offer git repo names as quick completions (the "real" projects)
  repos=(${(f)"$(find "$base" -maxdepth 6 -name '.git' -type d 2>/dev/null \
    | sed 's|/.git$||; s|.*/||' | sort -u)"})
  compadd -a repos

  # Also support path-based browsing (c apps/<tab>, etc.)
  _path_files -W "$base" -/
}
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
