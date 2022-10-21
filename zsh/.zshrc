if [[ $OSTYPE == 'darwin'* ]]; then
  export ZPLUG_HOME="$(brew --prefix zplug)"
else
  export ZPLUG_HOME="$HOME/.zplug"
fi
source $ZPLUG_HOME/init.zsh

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
  source $HOME/.asdf/asdf.sh
fi

ensure_tmux_is_running
