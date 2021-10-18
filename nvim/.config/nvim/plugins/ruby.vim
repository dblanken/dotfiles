Plug 'vim-ruby/vim-ruby'

augroup RubySetup
  autocmd!
  autocmd User PlugLoaded let g:ruby_indent_assignment_style = 'variable'
  autocmd User PlugLoaded let g:rubycomplete_rails = 1
augroup END

augroup ruby
  autocmd!
  " Make ? part of a keyword
  autocmd FileType ruby,eruby,yaml setlocal iskeyword+=?
augroup end
