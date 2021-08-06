" Ensures that aliases only work starting with a colon
" i.e. :W replaces, :normal "W<CR>" doesn't
fun! commandAlias#setup(from, to)
  exec 'cnoreabbrev <expr> '.a:from
        \ .' ((getcmdtype() is# ":" && getcmdline() is# "'.a:from.'")'
        \ .'? ("'.a:to.'") : ("'.a:from.'"))'
endfun
