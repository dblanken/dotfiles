" An easy way to handle transparency overrides for colorschemes
" Should be loaded before colorscheme mentioned

" Enables transparency
function! transparency#enable()
  let g:transparency = 1
  augroup transparency
    autocmd!
    autocmd ColorScheme * hi Normal guibg=NONE ctermbg=NONE
  augroup END
  doautocmd ColorScheme
endfunction

" Disables transparency
" You'll need to reload the colorscheme
function! transparency#disable()
  unlet g:transparency
  autocmd! transparency
  exe "colorscheme " .. g:colors_name
endfunction

" Toggles transparency
"
function! transparency#toggle()
  if transparency#is_transparent()
    call transparency#disable()
  else
    call transparency#enable()
  endif
endfunction

function! transparency#is_transparent()
  return exists(g:transparency)
endfunction
