Plug 'dracula/vim', { 'as': 'dracula' }

let g:dracula_bold = 1
let g:dracula_italic = 1
let g:dracula_underline = 1
let g:dracula_undercurl = 1

augroup DraculaOverrides
  autocmd!
  autocmd User PlugLoaded ++nested colorscheme dracula
augroup END
