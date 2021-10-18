Plug 'vim-test/vim-test'

function! s:MapTest() abort
  nmap <silent> <leader>t :TestNearest<CR>
  nmap <silent> <leader>T :TestFile<CR>
  nmap <silent> <leader>a :TestSuite<CR>
  nmap <silent> <leader>l :TestLast<CR>
  let g:test#strategy = 'dispatch'
endfunction

augroup TestSetup
  autocmd!
  autocmd User PlugLoaded call s:MapTest()
augroup END
