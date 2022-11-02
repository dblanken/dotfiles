Plug 'dense-analysis/ale'

nnoremap ]d <Plug>(ale_next)
nnoremap [d <Plug>(ale_previous)
if &rtp =~ 'coc.nvim'
	let g:ale_disable_lsp = 1
endif
let g:ale_echo_msg_format = '[%linter%] %code: %%s'
let g:ale_fix_on_save = 1
let g:ale_linters = {
			\ 'ruby': ['rubocop', 'reek', 'brakeman', 'cspell', 'debride'],
			\ 'javascript': ['tsserver']
			\ }
let g:ale_fixers = {
			\ '*': ['remove_trailing_lines'],
			\ 'ruby': ['rubocop'],
			\ 'javascript': ['eslint']
			\ }

function! LinterStatus() abort
	let l:counts = ale#statusline#Count(bufnr(''))

	let l:all_errors = l:counts.error + l:counts.style_error
	let l:all_non_errors = l:counts.total - l:all_errors

	return l:counts.total == 0 ? 'OK' : printf(
				\ '%dW %dE',
				\ all_non_errors,
				\ all_errors
				\)
endfunction

function! CreateLSPBufferMappings() abort
	"   nnoremap <buffer> <silent> gd <Plug>(ale_go_to_definition)
	"   nnoremap <buffer> <silent> <Leader>e <Plug>(ale_hover)
	"   nnoremap <buffer> <silent> <Leader>rn :ALERename<CR>
	nnoremap <buffer> <silent> ]d <Plug>(ale_next)
	nnoremap <buffer> <silent> [d <Plug>(ale_previous)
	nnoremap <buffer> <silent> <Leader>= <Plug>(ale_fix)
	"   nnoremap <buffer> <silent> gr <Plug>(ale_find_references)
endfunction

let s:ale_running = 0
augroup AleFlagship
	autocmd!
	autocmd User Flags call Hoist("buffer", "LinterStatus")
	autocmd User ALELSPStarted call CreateLSPBufferMappings()
augroup END
