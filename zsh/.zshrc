if [[ $OSTYPE == 'darwin'* ]]; then
  export ZPLUG_HOME="$(brew --prefix zplug)"
  export ZPLUG_LOC="$ZPLUG_HOME"
else
  export ZPLUG_HOME="$HOME/.zplug"
  export ZPLUG_LOC="/usr/share/zsh/scripts/zplug"
fi
source $ZPLUG_LOC/init.zsh

zplug 'mafredri/zsh-async'
zplug 'sindresorhus/pure'
zplug 'zsh-users/zsh-syntax-highlighting', defer:2
zplug 'zsh-users/zsh-completions', defer:2
zplug 'zsh-users/zsh-autocompletions', defer:2
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'

zplug load

for zsh_source in $HOME/.zsh/configs/*.zsh; do
	source $zsh_source
done

if [[ $OSTYPE == 'darwin'* ]]; then
  source "$(brew --prefix asdf)/asdf.sh"
else
  . /opt/asdf-vm/asdf.sh
fi

ensure_tmux_is_running
