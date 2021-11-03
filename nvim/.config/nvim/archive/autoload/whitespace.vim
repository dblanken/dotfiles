" Removes all whitespace from the buffer
function! whitespace#trim() abort
  let l:save = winsaveview()
  keeppatterns %s/\s\+$//e
  call winrestview(l:save)
endfunction
