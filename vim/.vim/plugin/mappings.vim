" I know Bram likes gq for Q, but I like to redo my macros with it
nnoremap Q @q
" Format the whole document
nnoremap <Leader>= migg=G`i
" Copy to the end of the line
nnoremap Y y$
" Escape out of terminal windows like vim
tnoremap <Esc> <C-\><C-n>

" I sometimes use :W instead of :w, so replace them
call commandAlias#setup("W", "w")
