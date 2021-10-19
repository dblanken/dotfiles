Plug 'vim-ruby/vim-ruby'

function SetupRuby() abort
  let g:ruby_indent_assignment_style = 'variable'
  let g:rubycomplete_rails = 1
  let g:ruby_indent_hanging_elements = 0
endfunction

augroup RubySetup
  autocmd!
  autocmd User PlugLoaded call SetupRuby()
augroup END

augroup ruby
  autocmd!
  " Make ? part of a keyword
  autocmd FileType ruby,eruby,yaml setlocal iskeyword+=?
augroup end
