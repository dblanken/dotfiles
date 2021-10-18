fpath=(~/.zsh.d/ $fpath)
ZSH_TMUX_AUTOSTART=true
ZSH_TMUX_FIXTERM=false

### Added by Zinit's installer
if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing %F{33}DHARMA%F{220} Initiative Plugin Manager (%F{33}zdharma/zinit%F{220})…%f"
    command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
    command git clone https://github.com/zdharma/zinit "$HOME/.zinit/bin" && \
        print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
        print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi

source "$HOME/.zinit/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zinit-zsh/z-a-rust \
    zinit-zsh/z-a-as-monitor \
    zinit-zsh/z-a-patch-dl \
    zinit-zsh/z-a-bin-gem-node

### End of Zinit's installer chunk
zinit wait lucid for \
        OMZL::git.zsh \
  atload"unalias grv" \
        OMZP::git
zinit lucid for \
  OMZL::completion.zsh \
  OMZP::asdf
# zinit wait lucid for \
#   OMZL::completion.zsh \
#   OMZP::asdf

zinit load "_local/dblanken"
zinit snippet OMZP::tmux
zinit snippet OMZP::bundler
zinit snippet OMZP::common-aliases
zinit snippet OMZP::github
zinit snippet OMZP::rails
zinit snippet OMZP::rake
zinit snippet OMZP::vi-mode
zinit snippet OMZP::yarn

zinit wait lucid atload"zicompinit; zicdreplay" blockf for \
    zsh-users/zsh-completions

zinit for \
    light-mode  zsh-users/zsh-autosuggestions \
    light-mode  zsh-users/zsh-history-substring-search \
    light-mode  zsh-users/zsh-syntax-highlighting

export EDITOR='nvim'
export GPG_TTY=$(tty)
export KN="$HOME/code"
export GITUSER="dblanken"
export DOTFILES="$HOME/.dotfiles"
if test "$EDITOR" != "vim"; then
  alias vim="$EDITOR"
  alias vi="$EDITOR"
fi

export THOR_MERGE='$EDITOR -d'
export LESSOPEN="|/usr/local/bin/lesspipe.sh %s" LESS_ADVANCED_PREPROCESSOR=1

alias mysqld='mysqld --datadir="$DATADIR"'
alias '?'=duck
alias '??'=google
alias '???'=bing
alias lock='pmset displaysleepnow'
alias top='htop'
alias df='df -h'
alias free='free -h'
alias chmox='chmod +x'
alias view='vi -R'
alias clear='printf "\e[H\e[2J"'
alias snippets='cd $SNIPPETS'
alias dot='cd $DOTFILES'
alias x='exit'

autoload -U add-zsh-hook

function -auto-ls-after-cd() {
  emulate -L zsh
  # Only in response to a user-initiated `cd`, not indirectly (eg. via another
  # function).
  if [ "$ZSH_EVAL_CONTEXT" = "toplevel:shfunc" ]; then
    ls -a
  fi
}

add-zsh-hook chpwd -auto-ls-after-cd

export PATH="$HOME/.local/bin:$PATH"
export CDPATH=.:~/code:~
export DATADIR="$HOME/.mysql_data"
export FZF_DEFAULT_COMMAND="rg --files --hidden --follow --glob '!.git'"
export SCRIPTS="~/.dotfiles/scripts/.local/bin"

# Make CTRL-Z background things and unbackground them.
function fg-bg() {
  if [[ $#BUFFER -eq 0 ]]; then
    fg
  else
    zle push-input
  fi
}
zle -N fg-bg
bindkey '^Z' fg-bg

source ~/.zinit/plugins/_local---dblanken/dblanken.zsh-theme
