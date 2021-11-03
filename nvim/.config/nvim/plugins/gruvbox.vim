Plug 'morhetz/gruvbox'

let g:gruvbox_italic = 1
let g:gruvbox_transparent_bg = 1
let g:gruvbox_contrast_dark = 'hard'
let g:gruvbox_italicize_strings = 1

augroup GruvboxOverrides
  autocmd!
  autocmd User PlugLoaded ++nested colorscheme gruvbox
augroup END
