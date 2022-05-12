unlet! skip_defaults_vim
source $VIMRUNTIME/defaults.vim

let mapleader=' '
let maploadloeader='\\'

set clipboard=unnamed
set completeopt=menu,menuone,noselect
set expandtab
set foldmethod=marker
set number
set relativenumber
set scrolloff=8
set shiftwidth=2
set sidescrolloff=8
set signcolumn=yes
set softtabstop=2
set tabstop=2
set colorcolumn=80

nnoremap Q @q
nnoremap <Leader>= migg=G`i
nnoremap Y y$
nnoremap <Leader>h :nohl<CR>
nnoremap <Leader><Leader> <C-^>

tnoremap <Esc> <C-\><C-n>

" Removes all whitespace from the buffer
function! TrimWhitespace() abort
  let l:save = winsaveview()
  keeppatterns %s/\s\+$//e
  call winrestview(l:save)
endfunction

augroup vimStartup
  autocmd!

  " When resized, resize the windows inside
  autocmd VimResized * execute "normal! \<c-w>="

  " Nest source on changes to vimrc
  autocmd BufWritePost .vimrc,init.vim,init.lua,vimrc nested source %

  autocmd BufEnter,BufNewFile .zshrc,zshrc setlocal filetype=zsh

  autocmd BufWritePre * :call TrimWhitespace()

  " When editing a file, always jump to the last known cursor position.
  " Don't do it for commit messages, when the position is invalid, or when
  " inside an event handler (happens when dropping a file on gvim).
  "
  autocmd BufReadPost *
        \ if &ft != 'gitcommit' && line("'\"") > 0 && line("'\"") <= line("$") |
        \   exe "normal g`\"" |
        \ endif
augroup end

" AG: ag\ --nogroup\ --nocolor\ --column
" RG: rg\ --no-heading\ --vimgrep\ --smart-case
set grepprg=ag\ --nogroup\ --nocolor\ --column

let g:ruby_path = '~/.asdf/shims'

packadd! vim-commentary
packadd! vim-dispatch
packadd! vim-projectionist
packadd! vim-surround
packadd! vim-tmux-navigator
packadd! vim-unimpaired
packadd! vim-fugitive

colorscheme desert
