Plug 'morhetz/gruvbox'

function! SetupGruvbox() abort
  let g:gruvbox_italic = 1
  let g:gruvbox_transparent_bg = 1
  let g:gruvbox_contrast_dark = 'hard'
  let g:gruvbox_italicize_strings = 1
endfunction

augroup GruvboxSetup
  autocmd!
  autocmd User PlugLoaded call SetupGruvbox()
augroup END
