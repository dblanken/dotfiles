Plug 'tpope/vim-git'

augroup GitOverrides
  autocmd!
  autocmd FileType gitcommit nnoremap <buffer> <silent> S :Cycle<CR>
augroup END
