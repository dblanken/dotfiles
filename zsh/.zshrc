if [ "$TMUX" = "" ]; then tmux attach || tmux new -s neimoon && exit; fi

# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
unsetopt autocd beep extendedglob nomatch notify
bindkey -v
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/Users/dblanken/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

if [ -d "$HOME/.zsh" ]
then
  for zsh_file in ~/.zsh/*; do
	  source $zsh_file
  done
fi

alias vim='nvim'
alias ls='ls --color'

alias v='nvim'
alias be='bundle exec'

alias gst='echo "use g"'
alias gca='echo "use g"'
alias gcb='echo "use g"'
