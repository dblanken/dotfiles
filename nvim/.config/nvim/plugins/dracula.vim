Plug 'dracula/vim', { 'as': 'dracula' }

function! SetupDracula() abort
  let g:dracula_bold = 1
  let g:dracula_italic = 1
  let g:dracula_underline = 1
  let g:dracula_undercurl = 1
endfunction

augroup DraculaSetup
  autocmd!
  autocmd User PlugLoaded call SetupDracula()
augroup END
