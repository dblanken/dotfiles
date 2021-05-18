# When on macos using brew, this autoloads all completions for installed
# brews
if type brew &>/dev/null; then
  HOMEBREW_PREFIX="$(brew --prefix)"
  if [[ -r "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh" ]]; then
    source "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh"
  else
    for COMPLETION in "${HOMEBREW_PREFIX}/etc/bash_completion.d/"*; do
      [[ -r "$COMPLETION" ]] && source "$COMPLETION"
    done
  fi
fi

if [ -f "/etc/bash_completion" ]; then
  source /etc/bash_completion
fi

LOCAL_COMPLETION="${HOME}/.completion"
for COMPLETION in "${LOCAL_COMPLETION}/"*; do
  [[ -r "$COMPLETION" ]] && source "$COMPLETION"
done

# Temporary fix for hub completion being borked
if type hub &>/dev/null; then
  alias __git=hub
  alias git=hub
  __git_complete hub __git_main
fi

if type pandoc &>/dev/null; then
  eval "$(pandoc --bash-completion)"
fi

if type docker &>/dev/null; then
  complete -F _docker d
fi
