Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

function! SetupFzf() abort
  if executable('ag')
    " Use ag in fzf for listing files. Lightning fast and respects .gitignore
    let $FZF_DEFAULT_COMMAND = 'ag --literal --files-with-matches --nocolor --hidden -g ""'
  endif

  nnoremap <silent> <C-p> :Files<CR>
endfunction

augroup FzfSetup
  autocmd!
  autocmd User PlugLoaded call SetupFzf()
augroup END
