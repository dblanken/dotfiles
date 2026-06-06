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

_c_rebuild_cache() {
  mkdir -p ~/.cache/zsh
  fd -H -t d '^\.git$' ~/code --max-depth 6 2>/dev/null \
    | sed 's|/.git$||; s|.*/||' | sort -u > ~/.cache/zsh/c_repos
}

_c() {
  local base=$HOME/code
  local cache=~/.cache/zsh/c_repos

  # Build cache on first use if missing
  [[ -f "$cache" ]] || _c_rebuild_cache

  # Offer git repo names as quick completions (the "real" projects)
  local -a repos
  repos=(${(f)"$(<$cache)"})
  compadd -a repos

  # Path-based browsing — directories only (apps/<tab>, etc.)
  local cur="${words[2]}"
  local dir_part="${cur:h}"
  local target_dir
  [[ "$dir_part" == "." ]] && target_dir="$base" || target_dir="$base/$dir_part"
  local -a subdirs
  subdirs=("$target_dir"/*(N-/))
  subdirs=("${(@)subdirs#$base/}")
  compadd -a subdirs
}
compdef _c c

# Keep cache warm in background on shell startup
_c_rebuild_cache &!

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
  local ssh_agent_bin
  ssh_agent_bin=$(command -v ssh-agent) || { echo "ssh-agent not found"; return 1; }
  echo "Initialising new SSH agent..."
  "$ssh_agent_bin" | sed 's/^echo/#echo/' > "${SSH_ENV}"
  echo succeeded
  chmod 600 "${SSH_ENV}"
  . "${SSH_ENV}" > /dev/null
  ssh-add;
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
