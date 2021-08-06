" Use like CTRL-P plugin
nnoremap <C-p> :Files<CR>
" New way I'm trying out
nnoremap <Leader>ff :Files<CR>
" Git only version
nnoremap <Leader>fg :GFiles<CR>
" Currenlty open buffers
nnoremap <Leader>fb :Buffers<CR>
" Replace default grep with :RG
nnoremap <Leader>g :Rg<Space>
" Easily get to my dotfiles
nnoremap <Leader>ez :Files $HOME/.dotfiles<CR>

let g:fzf_layout = { 'window': { 'width': 0.8, 'height': 0.8 } }

" Use bat in fzf
let $FZF_DEFAULT_OPTS='--reverse --preview "bat --style=numbers --color=always --line-range :500 {}"'

augroup fzf_overrides
  autocmd!
  " Allow Esc to exit fzf
  autocmd FileType fzf tnoremap <buffer> <Esc> <Esc><Esc>
augroup END
