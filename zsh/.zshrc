if command -v reattach-to-user-namespace &> /dev/null; then
  if [ "$TMUX" = "" ]; then tmux attach || tmux new -s neimoon && exit; fi
else
  echo "Please install reattach-to-user-namespace for tmux to work"
fi

export PATH="$HOME/bin:$HOME/.local/bin:$PATH"
export EDITOR="vim"

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

export HISTCONTROL=ignorespace

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

# Make zsh know about hosts already accessed by SSH
# Taken from ohmyzsh: https://github.com/ohmyzsh/ohmyzsh/blob/master/plugins/common-aliases/common-aliases.plugin.zsh
zstyle -e ':completion:*:(ssh|scp|sftp|rsh|rsync):hosts' hosts 'reply=(${=${${(f)"$(cat {/etc/ssh_,~/.ssh/known_}hosts(|2)(N) /dev/null)"}%%[# ]*}//,/ })'

# Define parts of my prompt
typeset -a __PROMPT_PARTS
__PROMPT_PARTS=(
  "%F{green}%n%F{black}@%F{green}%m%f"
  "%F{blue}%1~%f"
  "%F{yellow}%#%f"
)

typeset -a __RPROMPT_PARTS
__RPROMPT_PARTS=(
  '$(ruby_version)'
  '$(node_version)'
)

autoload -Uz add-zsh-hook

if [ -d "$HOME/.zsh" ]
then
  for zsh_file in ~/.zsh/*; do
    source $zsh_file
  done
fi

# Colors
alias ls='ls --color'
alias grep='grep --color'

# Shortened
alias v='$EDITOR'
alias be='bundle exec'
alias t='tail -f'
alias h='history'

# Easy find
alias ff='find . -type f -name'
(( $+commands[fd] )) || alias fd='find . -type d -name'

alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

alias zshrc='v ~/.zshrc'
alias vimrc='v ~/.vimrc'
alias tmuxconf='v ~/.tmux.conf'
alias dot='cd ~/.dotfiles'
alias alacconf='v ~/.config/alacritty/alacritty.yml'

# Git aliases from ohmyzsh I actually like
alias ga='git add'
alias gamend='git commit --amend'
alias gb='git branch'
alias gblame='git blame'
alias gc='git commit -v'
alias gca='git commit -v -a'
alias gcar='git commit --amend --no-edit'
alias gcb='git checkout -b'
alias gco='git checkout'
alias gcode='git log -S'
alias gd='git diff'
alias gdiffc='git diff --cached'
alias gfile='git log --oneline --'
alias ggrep='git log -E -i --grep'
alias glog='git log --oneline --decorate --graph --all'
alias gpatch='git add --patch'
alias gshow='git show'
alias gst='git status'
alias guncommit='git reset --soft HEAD^'
alias gwip='git add -A; git rm $(git ls-files --deleted) 2> /dev/null; git commit --no-verify --no-gpg-sign -m "--wip-- [skip ci]"'

alias testvims='rm -rf ~/*vim.log; \vim --startuptime ~/vim.log +qa; \nvim --startuptime ~/nvim.log +qa; vim -O ~/*vim.log'

alias pandoc='pandoc -V colorlinks=true -V linkcolor=blue -V urlcolor=blue -V toccolor=gray'

if command -v logo-ls &> /dev/null; then
  alias ls='logo-ls'
fi

export THOR_MERGE='vim -d'

# Prompt
setopt prompt_subst

PROMPT=""
for i in $__PROMPT_PARTS; do
  PROMPT="${PROMPT##[[:space]]*[[:space]]} ${i}"
done
PROMPT="${${PROMPT##[[:space]]*[[:space]]}:1} "

RPROMPT=""
for i in $__RPROMPT_PARTS; do
  RPROMPT="${RPROMPT##[[:space]]*[[:space]]} ${i}"
done
RPROMPT="${${RPROMPT##[[:space]]*[[:space]]}:1} "

export SPROMPT="zsh: correct %F{red}'%R'%f to %F{red}'%r'%f [%B%Uy%u%bes, %B%Un%u%bo, %B%Ue%u%bdit, %B%Ua%u%bbort]? "

# fortune computers riddles pets wisdom work food kids | cowsay -f dragon | lolcat
