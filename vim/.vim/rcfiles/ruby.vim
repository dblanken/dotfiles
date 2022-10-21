let g:ruby_path = '~/.asdf/shims'
" Use old regex engine for ruby
set re=1
let g:rubycomplete_buffer_loading = 1
let g:rubycomplete_classes_in_global = 1
let g:rubycomplete_rails = 1

" {{{1 Ruby filetypes
" Make ?s part of words
autocmd FileType ruby,eruby,yaml setlocal iskeyword+=?
