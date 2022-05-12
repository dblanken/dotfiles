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
packadd! ale

nnoremap ]d <Plug>(ale_next)
nnoremap [d <Plug>(ale_previous)
let g:ale_echo_msg_format = '[%linter%] %code: %%s'
let g:ale_fix_on_save = 1
let g:ale_linters = {
      \ 'ruby': ['reek', 'solargraph', 'brakeman', 'cspell', 'debride']
      \ }
let g:ale_fixers = {
      \ '*': ['remove_trailing_lines'],
      \ 'ruby': ['rubocop']
      \ }

" Taken from thoughtbot/dotfiles
" Tab completion
" will insert tab at beginning of line,
" will traverse popup menu if open and enabled for XO,
" will use omni completion if not at beginning
set wildmode=list:longest,list:full
function! InsertTabWrapper()
  let proglang = get(g:, 'programming_mode', 1)
  let col = col('.') - 1
  if !col || getline('.')[col - 1] !~ '\k'
    return "\<Tab>"
  elseif !pumvisible() && proglang == 1
    return "\<C-x>\<C-o>"
  else
    return "\<C-p>"
  endif
endfunction
inoremap <Tab> <C-r>=InsertTabWrapper()<CR>
inoremap <S-Tab> <C-n>

command! EnableProgramming let g:programming_mode=1
command! DisableProgramming let g:programming_mode=0

" Switch between the last two files
nnoremap <Leader><Leader> <C-^>

colorscheme desert
