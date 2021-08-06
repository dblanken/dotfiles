" Copy the indentation from the current line when starting a new one
setlocal autoindent
" Use indentation and recognize numbered lists
setlocal formatoptions+=2n
" If we are actually in a help buffer (not creating a help doc), turn spelling
" off
if &buftype ==# 'help'
  setlocal nospell
endif
