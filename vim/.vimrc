" {{{1 Vim defaults
if !has('nvim')
  unlet! skip_defaults_vim
  source $VIMRUNTIME/defaults.vim
endif

" {{{1 vim-plug bootstrap
let vimplug_exists=expand('~/.vim/autoload/plug.vim')
if has('win32')&&!has('win64')
  let curl_exists=expand('C:\Windows\Sysnative\curl.exe')
else
  let curl_exists=expand('curl')
endif

if !filereadable(vimplug_exists)
  if !executable(curl_exists)
    echoerr "You have to install curl or first install vim-plug yourself!"
    execute "q!"
  endif
  echo "Installing Vim-Plug..."
  echo ""
  silent exec "!"curl_exists" -fLo " . shellescape(vimplug_exists) . " --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
  let g:not_finish_vimplug = "yes"

  autocmd VimEnter * PlugInstall
endif

" {{{1 Mapleaders
let mapleader=' '
let maploadloeader='\\'

" {{{1 Options
set clipboard=unnamed
set completeopt=menu,menuone,noselect
set encoding=utf-8
set fileencoding=utf-8
set fileencodings=utf-8
set hidden
set hlsearch
set incsearch
set ignorecase
set smartcase
set ttyfast
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
set backupcopy=yes                      " overwrite files to update, instead of renaming + rewriting

set nobackup                            " don't make backups before writing
set nowritebackup                       " don't keep backups after writing

if !empty($SUDO_USER) && $USER !=# $SUDO_USER
  setglobal viminfo=
  setglobal directory-=~/tmp
  setglobal backupdir-=~/tmp
elseif exists('+undodir') && !has('nvim-0.5')
  if !empty($XDG_DATA_HOME)
    let s:data_home = substitute($XDG_DATA_HOME, '/$', '', '') . '/vim/'
  elseif has('win32')
    let s:data_home = expand('~/AppData/Local/vim/')
  else
    let s:data_home = expand('~/.local/share/vim/')
  endif
  let &undodir = s:data_home . 'undo//'
  let &directory = s:data_home . 'swap//'
  let &backupdir = s:data_home . 'backup//'
  if !isdirectory(&undodir) | call mkdir(&undodir, 'p') | endif
  if !isdirectory(&directory) | call mkdir(&directory, 'p') | endif
  if !isdirectory(&backupdir) | call mkdir(&backupdir, 'p') | endif
endif

set noswapfile                          " don't create swap files

if has('viminfo') " ie. Vim.
  let s:viminfo='viminfo'
elseif has('shada') " ie. Neovim.
  let s:viminfo='shada'
endif

if exists('s:viminfo')
  if exists('$SUDO_USER')
    " Don't create root-owned files.
    execute 'set ' . s:viminfo . '='
    execute 'set ' . s:viminfo . 'file=NONE'
  else
    " Defaults:
    "   Vim:    '100,<50,s10,h
    "
    " - ! save/restore global variables (only all-uppercase variables)
    " - '100 save/restore marks from last 100 files
    " - <50 save/restore 50 lines from each register
    " - s10 max item size 10KB
    " - h do not save/restore 'hlsearch' setting
    "
    " Our overrides:
    " - '0 store marks for 0 files
    " - <0 don't save registers
    " - f0 don't store file marks
    " - n: store or ~/.vim/
    "
    execute 'set ' . s:viminfo . "='0,<0,f0,n~/.cache/vim/" . s:viminfo
    if !empty(glob('~/.cache/vim/' . s:viminfo))
      if !filereadable(expand('~/.cache/vim/' . s:viminfo))
        echoerr 'warning: ~/.cache/vim/' . s:viminfo . ' exists but is not readable'
      endif
    endif
  endif
endif

" {{{1 Common remaps
nnoremap Q @q
nnoremap <Leader>= migg=G`i
nnoremap Y y$
nnoremap <Leader>h :nohl<CR>
nnoremap <Leader><Leader> <C-^>
vnoremap p "_dp
vnoremap p "_dP

tnoremap <Esc> <C-\><C-n>

" {{{1 Common autocommands
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

" {{{1 Grep

" AG: ag\ --nogroup\ --nocolor\ --column
" RG: rg\ --no-heading\ --vimgrep\ --smart-case
set grepprg=ag\ --nogroup\ --nocolor\ --column

" {{{1 vim-ruby
let g:ruby_path = '~/.asdf/shims'
" Use old regex engine for ruby
set re=1
let g:rubycomplete_buffer_loading = 1
let g:rubycomplete_classes_in_global = 1
let g:rubycomplete_rails = 1

" {{{1 Plugin syncing
set runtimepath^=~/.local/share/vim runtimepath+=~/.local/share/vim/after
let &packpath = &runtimepath
call plug#begin(s:data_home .. 'plugged')

" Completion and snippets
Plug 'Shougo/deoplete.nvim'
Plug 'roxma/nvim-yarp'
Plug 'roxma/vim-hug-neovim-rpc'
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'tpope/vim-endwise'

" Rails
Plug 'tpope/vim-rails'
Plug 'tpope/vim-rake'
Plug 'tpope/vim-bundler'
Plug 'vim-ruby/vim-ruby'
Plug 'andrewradev/splitjoin.vim'
Plug 'ecomba/vim-ruby-refactoring', {'tag': 'main'}

" Testing and Linting
Plug 'dense-analysis/ale'
Plug 'tpope/vim-dispatch'
Plug 'vim-test/vim-test'

" Markdown
Plug 'vimwiki/vimwiki'
Plug 'vim-pandoc/vim-pandoc'
Plug 'vim-pandoc/vim-pandoc-syntax'
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}

" HTML
Plug 'mattn/emmet-vim'

" Colorschemes and statusbar
Plug 'chriskempson/base16-vim'
Plug 'tribela/vim-transparent'
Plug 'morhetz/gruvbox'
Plug 'tpope/vim-flagship'

" Text Manipulation
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-commentary'
Plug 'godlygeek/tabular'
Plug 'tpope/vim-surround'

" Traversal
Plug 'christoomey/vim-tmux-navigator'
Plug 'ludovicchabant/vim-gutentags'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-projectionist'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-vinegar'

" Utility
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-sensible'

if isdirectory('/usr/local/opt/fzf')
  Plug '/usr/local/opt/fzf' | Plug 'junegunn/fzf.vim'
else
  Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --bin' }
  Plug 'junegunn/fzf.vim'
endif

call plug#end()

" {{{1 ALE
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
  nnoremap <buffer> <silent> gd <Plug>(ale_go_to_definition)
  nnoremap <buffer> <silent> <Leader>e <Plug>(ale_hover)
  nnoremap <buffer> <silent> <Leader>rn :ALERename<CR>
  nnoremap <buffer> <silent> ]d <Plug>(ale_next)
  nnoremap <buffer> <silent> [d <Plug>(ale_previous)
  nnoremap <buffer> <silent> <Leader>= <Plug>(ale_fix)
  nnoremap <buffer> <silent> gr <Plug>(ale_find_references)
endfunction

let s:ale_running = 0
augroup AleFlagship
  autocmd!
  autocmd User Flags call Hoist("buffer", "LinterStatus")
  autocmd User ALELSPStarted call CreateLSPBufferMappings()
augroup END

" {{{1 FZF
let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6 } }
nnoremap <Leader>ff :Files<CR>
nnoremap <Leader>fg :Ag<CR>
augroup FzfNess
  autocmd!
  autocmd FileType fzf tnoremap <buffer> <Esc> <Esc><Esc>
augroup END

" {{{1 vim-test
nmap <silent> <leader>t :TestNearest<CR>
nmap <silent> <leader>T :TestFile<CR>
nmap <silent> <leader>a :TestSuite<CR>
nmap <silent> <leader>l :TestLast<CR>
let g:test#strategy = 'dispatch'

" {{{1 Deoplete
" Enable deoplete when InsertEnter.
let g:deoplete#enable_at_startup = 0
augroup deopleter
  au!
  autocmd InsertEnter * call deoplete#enable()
augroup END

" {{{1 Deoplete, Endwise, Ultisnips, Tab Magic
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

" {{{1 Vimwiki
let g:vimwiki_list = [{'path': '~/vimwiki', 'syntax': 'markdown', 'ext': '.md'},
      \ {'path': '~/code/vimwiki', 'syntax': 'markdown', 'ext': '.md'}]

" {{{1 Colorscheme
let g:gruvbox_italic = 1
set background=dark
" colorscheme gruvbox

if filereadable(expand("~/.vimrc_background"))
  let base16colorspace=256
  source ~/.vimrc_background
endif
