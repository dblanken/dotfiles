export ZPLUG_HOME="$(brew --prefix zplug)"
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

source "$(brew --prefix asdf)/asdf.sh"

ensure_tmux_is_running
