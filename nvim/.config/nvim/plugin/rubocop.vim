function! RubocopMake(...) abort
  let make_cmd="Make"

  if a:0 > 0
    echom a:000
    let make_cmd=make_cmd . " " . a:1
  endif

  let current_buffer_compiler = b:current_compiler
  compiler rubocop
  execute make_cmd
  execute "compiler " . current_buffer_compiler
endfunction

function! RubocopMakeModels() abort
  call RubocopMake('app/models')
endfunction

function! RubocopMakeLib() abort
  call RubocopMake('lib')
endfunction

function! RubocopMakeTest() abort
  call RubocopMake('test')
endfunction

nnoremap <Leader>ru :call RubocopMake()<CR>

command! Rmodel silent call RubocopMakeModels()<CR>
command! Rlib silent call RubocopMakeLib()<CR>
command! Rtest silent call RubocopMakeTest()<CR>
