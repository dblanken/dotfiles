Plug 'vim-ruby/vim-ruby'

let g:rubycomplete_rails = 1

augroup ruby
  autocmd!
  " Make ? part of a keyword
  autocmd FileType ruby,eruby,yaml setlocal iskeyword+=?
augroup end
