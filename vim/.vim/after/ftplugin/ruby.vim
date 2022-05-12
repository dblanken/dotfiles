  function! TestCompletionFunc(findstart, base) abort
    let l:result = ale#completion#OmniFunc(a:findstart, a:base)

    " Check if ALE couldn't find anything.
    if (a:findstart && l:result is -3)
    \|| (!a:findstart && empty(l:result))
      " Defer to another omnifunc if ALE couldn't find anything.
      return rubycomplete#Complete(a:findstart, a:base)
    endif

    return l:result
  endfunction

  set omnifunc=TestCompletionFunc

let g:rubycomplete_rails = 1
let g:rubycomplete_classes_in_global = 1
let g:rubycomplete_buffer_loading = 1
setlocal omnifunc=TestCompletionFunc
