if has('nvim')
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
else
  Plug 'Shougo/deoplete.nvim'
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
endif

" Enable deoplete when InsertEnter.
let g:deoplete#enable_at_startup = 0
augroup deopleter
	au!
	autocmd InsertEnter * call deoplete#enable()
augroup END

" Must set trigger to no-op so we can handle it
let g:UltiSnipsExpandTrigger = "<nop>"
let g:UltiSnipsJumpForwardTrigger = "<Tab>"
let g:UltiSnipsJumpBackwardTrigger = "<S-Tab>"
" This is a variable that ultisnips will set when
" UltiSnips#ExpandSnippetOrJump() is called.
"   1 = It expanded or jumped
"   0 = It did nothing
let g:ulti_expand_or_jump_res = 0

" We define our own function that attemps the expand or jump, and if nothing
" happened, we return just a regular return.
function ExpandSnippetOrCarriageReturn()
	let snippet = UltiSnips#ExpandSnippetOrJump()
	if g:ulti_expand_or_jump_res > 0
		return snippet
	else
		return "\<CR>"
	endif
endfunction
" Make sure we don't allow endwise to do its own magic to CR.
let g:endwise_no_mappings = 1

" Obligitory check last character was space function
" get the column number before the current
" if col is zero, return 1 so we know it was a space
" if col is not zero, get the character before and return 1 if it's a space
function! s:check_last_char_was_space() abort
	let col = col('.') - 1
	return !col || getline('.')[col - 1]  =~ '\s'
endfunction

" If tab is pressed:
"    and pull up menu is visible:
"      C-n to traverse list
"    else
"      if we are at the beginning of the line or the character before is a space,
"      then allow a tab (no autocomplete needed)
"      if we are not at the beginning of the line and the character before is not
"        a space, attempt a deoplete completion.
inoremap <silent><expr> <TAB> pumvisible() ? "\<C-n>" : <SID>check_last_char_was_space() ? "\<TAB>" : deoplete#mappings#manual_complete()
inoremap <expr>   <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"| " Shift-Tab is previous entry if completion menu open.

" If CR is pressed:
"  if the pull up menu is visible
"    We attempt to expand the snippet or jump
"  otherwise
"    We CR with our own endwise call
inoremap <expr> <CR> pumvisible() ? "\<C-R>=ExpandSnippetOrCarriageReturn()\<CR>" : "\<CR>\<C-R>=EndwiseDiscretionary()\<CR>"
