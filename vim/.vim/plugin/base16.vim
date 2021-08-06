" Enabled transparency on any color change
call transparency#enable()

" Copied from base16-shell
if filereadable(expand("~/.vimrc_background"))
  let base16colorspace=256
  silent! source ~/.vimrc_background
endif

