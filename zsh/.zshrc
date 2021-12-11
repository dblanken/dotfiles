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

export ITALIC_ON=$'\e[3m'
export ITALIC_OFF=$'\e[23m'

# Categorize completion suggestions with headings:
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format %F{default}%B%{$ITALIC_ON%}--- %d ---%{$ITALIC_OFF%}%b%f

# Make completion:
# - Try exact (case-sensitive) match first.
# - Then fall back to case-insensitive.
# - Accept abbreviations after . or _ or - (ie. f.b -> foo.bar).
# - Substring complete (ie. bar -> foobar).
zstyle ':completion:*' matcher-list '' '+m:{[:lower:]}={[:upper:]}' '+m:{[:upper:]}={[:lower:]}' '+m:{_-}={-_}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

# Colorize completions using default `ls` colors.
zstyle ':completion:*' list-colors ''

# Allow completion of ..<Tab> to ../ and beyond.
zstyle -e ':completion:*' special-dirs '[[ $PREFIX = (../)#(..) ]] && reply=(..)'

# Enable keyboard navigation of completions in menu
# (not just tab/shift-tab but cursor keys as well):
zstyle ':completion:*' menu select

# For some reason Shift-Tab only works when I do this
bindkey '^[[Z' reverse-menu-complete

# To search history
bindkey "^R" history-incremental-search-backward

# Define parts of my prompt
typeset -a __PROMPT_PARTS
__PROMPT_PARTS=(
  "%F{green}%n@%m%f"
  "%F{blue}%1~%f"
  "%F{yellow}%#%f"
)

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
# Prompt
setopt prompt_subst

PROMPT=""
for i in $__PROMPT_PARTS; do
  PROMPT="${PROMPT##[[:space]]*[[:space]]} ${i}"
done
PROMPT="${PROMPT##[[:space]]*[[:space]]} "
export SPROMPT="zsh: correct %F{red}'%R'%f to %F{red}'%r'%f [%B%Uy%u%bes, %B%Un%u%bo, %B%Ue%u%bdit, %B%Ua%u%bbort]? "

