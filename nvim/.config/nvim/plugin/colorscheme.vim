if !exists('g:my_colorscheme')
  let g:my_colorscheme = 'desert'
endif

call transparency#enable()
execute "colorscheme " . g:my_colorscheme
