# Editor
#

export VIMCONFIG="$HOME/.local/share/vim"
export VIMDATA="$VIMCONFIG/data"

export EDITOR="vim"
export VISUAL="$EDITOR"

alias v='$EDITOR'
alias vimrc='$EDITOR ~/.vimrc'

mkdir -p "$VIMCONFIG"
mkdir -p "$VIMDATA"
