" vim: nowrap fdm=marker
scriptencoding utf-8

" {{{1 Short circuits
if has('nvim')
  if has('unix')
    let g:python_host_prog = expand('~/.asdf/shims/python2')
    let g:python3_host_prog = expand('~/.asdf/shims/python3')
    let g:ruby_host_prog = expand('~/.asdf/shims/neovim-ruby-host')
    let g:node_host_prog = expand('~/.config/yarn/global/node_modules/neovim/bin/cli.js')
    let g:perl_host_prog = expand('/usr/local/bin/perl')
  endif
endif
" }}}

let mapleader="\<Space>"

" {{{1 Settings
if !has('nvim')
  unlet! skip_defaults_vim
  source $VIMRUNTIME/defaults.vim

  set autoindent
  set autoread
  set background=dark
  set belloff=all
  set cscopeverbose
  set directory=$HOME/.local/share/vim/swap//
  set encoding=utf8
  set fileencoding=utf8
  set formatoptions+=j
  set fillchars="vert:│,fold:·"
  set history=10000
  set hlsearch
  set laststatus=2
  set listchars="tab:> ,trail:-,nbsp:+"
  set nrformats-=octal
  set sessionoptions+=unix,slash
  set sessionoptions-=options
  set shortmess+=F
  set shortmess-=S
  set sidescroll=1
  set smarttab
  set tabpagemax=50
  set ttimeoutlen=50
  set viewoptions+=unix,slash
  set undodir=$HOME/.local/share/vim/undo
  set wildmenu
  set wildoptions=tagfile

  let g:loaded_getscriptPlugin = 1
  let g:loaded_gzip = 1
  let g:loaded_logiPat = 1
  let g:loaded_rrhelper = 1
  let g:loaded_tarPlugin = 1
  let g:loaded_vimballPlugin = 1
  let g:loaded_zipPlugin = 1
endif
set clipboard=unnamedplus,unnamed
set colorcolumn=80
set expandtab
set hidden
set nobackup
set noerrorbells
set noswapfile
set number
set relativenumber
set shiftwidth=2
set smartcase
set softtabstop=2
set undofile
set formatoptions-=cro
set nowrap
set incsearch
set updatetime=50
" }}}

" {{{1 Plugins
call plugpac#begin()
Pack 'k-takata/minpac', {'type': 'opt'}

Pack 'tpope/vim-abolish'
Pack 'tpope/vim-apathy'
Pack 'tpope/vim-bundler'
Pack 'tpope/vim-characterize'
Pack 'tpope/vim-commentary'
Pack 'tpope/vim-dadbod'
Pack 'tpope/vim-dispatch'
Pack 'tpope/vim-dotenv'
Pack 'tpope/vim-endwise'
Pack 'tpope/vim-eunuch'
Pack 'tpope/vim-flagship'
Pack 'tpope/vim-fugitive'
Pack 'tpope/vim-git'
Pack 'tpope/vim-haml'
Pack 'tpope/vim-jdaddy'
Pack 'tpope/vim-markdown'
Pack 'tpope/vim-obsession'
Pack 'tpope/vim-projectionist'
Pack 'tpope/vim-ragtag'
Pack 'tpope/vim-rails'
Pack 'tpope/vim-rake'
Pack 'tpope/vim-repeat'
Pack 'tpope/vim-rhubarb'
if !has('nvim')
  Pack 'tpope/vim-sensible', {'type': 'opt'}
  packadd! vim-sensible
endif
Pack 'tpope/vim-sleuth'
Pack 'tpope/vim-speeddating'
Pack 'tpope/vim-surround'
Pack 'tpope/vim-tbone'
Pack 'tpope/vim-unimpaired'
Pack 'tpope/vim-vinegar'
Pack 'tpope/vim-vividchalk', {'type': 'opt'}

Pack 'vim-ruby/vim-ruby'

Pack 'tpope/vim-fireplace'
Pack 'tpope/vim-sexp-mappings-for-regular-people'
Pack 'guns/vim-sexp'

if has('nvim')
  Pack 'neovim/nvim-lspconfig', {'type': 'opt'}
  Pack 'nvim-lua/completion-nvim', {'type': 'opt'}
  Pack 'nvim-lua/diagnostic-nvim', {'type': 'opt'}
  Pack 'nvim-lua/lsp-status.nvim', {'type': 'opt'}
  " Pack 'nvim-lua/popup.nvim'
  " Pack 'nvim-lua/plenary.nvim'
  " Pack 'nvim-lua/telescope.nvim'
  packadd nvim-lspconfig
  packadd completion-nvim
  packadd diagnostic-nvim
  packadd lsp-status.nvim
endif

Pack 'christoomey/vim-tmux-navigator'

Pack 'AndrewRadev/splitjoin.vim'

Pack 'vim-test/vim-test'

Pack 'honza/vim-snippets'
Pack 'Sirver/ultisnips'

Pack 'junegunn/fzf.vim'

Pack 'gruvbox-community/gruvbox', {'type': 'opt'}

Pack 'tweekmonster/startuptime.vim', {'on': 'StartupTime'}

Pack 'wincent/loupe'
Pack 'wincent/terminus'

Pack 'mattn/emmet-vim'

Pack 'jiangmiao/auto-pairs'

call plugpac#end()

set rtp+=/usr/local/opt/fzf

" }}}

" {{{1 FZF config
let g:fzf_layout = { 'window': { 'width': 0.8, 'height': 0.8 } }
let $FZF_DEFAULT_OPTS='--reverse'
nnoremap <C-p> :GFiles<CR>
" }}}

" {{{1 Netrw config
let g:netrw_browse_split = 2
let g:netrw_banner = 0
let g:netrw_winsize = 25
" }}}

" {{{1 vim-test config
nmap <silent> <leader>t :TestNearest<CR>
nmap <silent> <leader>T :TestFile<CR>
nmap <silent> <leader>a :TestSuite<CR>
nmap <silent> <leader>l :TestLast<CR>
let test#strategy = 'dispatch'
" }}}

" {{{1 Mappings
nnoremap Q @q
nmap 0 ^
nnoremap <Leader>= migg=G`i
nnoremap Y y$
nnoremap <Leader>g :grep!<Space>
if exists(':tnoremap')
  tnoremap <Esc> <C-\><C-n>
endif

command! Vimrc vsp ~/.vimrc
" }}}

let g:rails_projections = {
      \ "test/models/*_test.rb": {"command": "modeltest",
      \   "template":
      \     ["require \"test_helper\"",
      \      "",
      \      "class {camelcase|capitalize|colons}Test < ActiveSupport::TestCase",
      \      "end"]
      \   }
      \ }

" {{{1 vim-rhubarb configs
let g:github_enterprise_urls = ['https://github.iu.edu']
" }}}

" {{{1 Autogroups
function! TrimWhitespace()
    let l:save = winsaveview()
    keeppatterns %s/\s\+$//e
    call winrestview(l:save)
endfunction

augroup misc
  autocmd!

  " This is already in the default.vim, so only for nvim here
  if has('nvim')
    " On opening a file, jump to the last known cursor position (see :h line())
    autocmd BufReadPost *
          \ if line("'\"") > 1 && line("'\"") <= line("$") && &ft !~# 'commit' |
          \   exe "normal! g`\"" |
          \ endif
  endif

  " When resized, resize the windows inside
  autocmd VimResized * execute "normal! \<c-w>="

  " Nest source on changes to vimrc
  autocmd BufWritePost .vimrc,init.vim,vimrc nested source %

  autocmd BufEnter,BufNewFile .zshrc,zshrc setlocal filetype=zsh

  autocmd BufWritePre * :call TrimWhitespace()
augroup end

augroup ruby
  autocmd!
  " Make ? part of a keyword
  autocmd FileType ruby,eruby,yaml setlocal iskeyword+=?
augroup end

if has('nvim')
  augroup TextYankPoster
    autocmd!
    if exists('##TextYankPost')
      autocmd TextYankPost * silent! lua vim.highlight.on_yank {"IncSearch", 200}
    endif
  augroup END
endif
" }}}

" {{{1 rg/grep
if executable('rg')
  set grepprg=rg\ --no-heading\ --vimgrep\ --smart-case
endif
" }}}

" {{{1 Colorscheme
let g:gruvbox_contrast_dark = 'hard'
if exists('+termguicolors')
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
    set termguicolors
endif
let g:gruvbox_invert_selection='0'
colorscheme gruvbox
" }}}
