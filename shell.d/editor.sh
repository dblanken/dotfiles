export HRULEWIDTH=73
export EDITOR=vi
export VISUAL=vi
export EDITOR_PREFIX=vi

if [ -d ~/.vim/spell ]; then
  export VIMSPELL=(~/.vim/spell/*.add)
fi
