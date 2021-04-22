" vim: nowrap fdm=marker

let mapleader="\<Space>"

" {{{1 Short circuits
if has('nvim')
  if has('unix')
    if glob('~/.asdf')
      let g:python_host_prog = expand('~/.asdf/shims/python2')
      let g:python3_host_prog = expand('~/.asdf/shims/python3')
      let g:ruby_host_prog = expand('~/.asdf/shims/neovim-ruby-host')
    endif
    let g:node_host_prog = expand('~/.config/yarn/global/node_modules/neovim/bin/cli.js')
    let g:perl_host_prog = expand('/usr/local/bin/perl')
  endif
endif
" }}}

" {{{1 Settings
if !has('nvim')
  unlet! skip_defaults_vim
  source $VIMRUNTIME/defaults.vim

  " My attempt to get as close to a nvim setup for vim as I can
  " Referenced :h defaults in neovim
  " set smarttab
  set autoindent
  set autoread
  set background=dark
  set belloff=all
  set cscopeverbose
  set directory=$HOME/.local/share/vim/swap//
  set encoding=utf8
  set fileencoding=utf8
  set fillchars="vert:│,fold:·"
  set formatoptions+=j
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
  set signcolumn=yes
  set tabpagemax=50
  set ttimeoutlen=50
  set undodir=$HOME/.local/share/vim/undo
  set viewoptions+=unix,slash
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
" If I ever stop using vim-sleuth, set these again
" set expandtab
" set shiftwidth=2
" set softtabstop=2
set clipboard=unnamedplus,unnamed
set colorcolumn=81
set formatoptions-=cro
set guioptions-=e
set hidden
set incsearch
set nobackup
set noerrorbells
set noswapfile
set nowrap
set number
set relativenumber
set showtabline=2
set smartcase
set undofile
set updatetime=50
" }}}

" {{{1 Plugins
call plug#begin()
Plug 'christoomey/vim-tmux-navigator'
Plug 'dense-analysis/ale'
Plug 'godlygeek/tabular'
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-afterimage'
Plug 'tpope/vim-apathy'
Plug 'tpope/vim-bundler'
Plug 'tpope/vim-characterize'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-cucumber'
Plug 'tpope/vim-dadbod'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-dotenv'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-fireplace'
Plug 'tpope/vim-flagship'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-git'
Plug 'tpope/vim-jdaddy'
Plug 'tpope/vim-markdown'
Plug 'tpope/vim-projectionist'
Plug 'tpope/vim-ragtag'
Plug 'tpope/vim-rails'
Plug 'tpope/vim-rake'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-rhubarb'
Plug 'tpope/vim-salve'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-speeddating'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-tbone'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-vinegar'
Plug 'tpope/vim-vividchalk'
Plug 'vim-test/vim-test'
Plug 'vuciv/vim-bujo'
Plug 'wincent/loupe'
Plug 'wincent/terminus'
Plug 'chriskempson/base16-vim'

call plug#end()

set rtp+=/usr/local/opt/fzf
" }}}

" {{{1 FZF config
let g:fzf_layout = { 'window': { 'width': 0.8, 'height': 0.8 } }
let $FZF_DEFAULT_OPTS='--reverse'
nnoremap <C-p> :Files<CR>

augroup fzf_overrides
  autocmd!
  " Allow Esc to exit fzf
  autocmd FileType fzf tnoremap <buffer> <Esc> <Esc><Esc>
augroup END
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

" {{{1 vim-rails config
" This lets me create a test file properly
let g:rails_projections = {
      \ "test/models/*_test.rb": {"command": "modeltest",
      \   "template":
      \     ["require \"test_helper\"",
      \      "",
      \      "class {camelcase|capitalize|colons}Test < ActiveSupport::TestCase",
      \      "end"]
      \   }
      \ }
" }}}

" {{{1 vim-fugitive
nnoremap <Leader>gd :Gvdiffsplit!<CR>
nnoremap gdh :diffget //2<CR>
nnoremap gdl :diffget //3<CR>
" }}}

" {{{1 Mappings
nnoremap Q @q
nnoremap <Leader>= migg=G`i
nnoremap Y y$
nnoremap <Leader>g :grep!<Space>
if exists(':tnoremap')
  tnoremap <Esc> <C-\><C-n>
endif

nnoremap <Leader>s :s/\(<C-r>=expand("<cword>")<CR>\)/

command! Vimrc vsp ~/.vimrc

nnoremap <Leader>\ :vsplit<CR>
nnoremap <Leader>- :split<CR>

" Delete what you have highlighted to the void register and paste what you
" wanted.  It does not replace what you've copied previously.  Actual delete.
vnoremap <Leader>p "_dP
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

augroup dblanken_filetypes
  autocmd FileType * setlocal nolinebreak
  autocmd FileType xml,xsd,xslt,javascript setlocal ts=2
  autocmd FileType mail,gitcommit setlocal tw=72
  autocmd FileType sh,zsh,csh,tcsh setlocal fo-=t|
        \ inoremap <silent> <buffer> <C-X>! #!/bin/<C-R>=&ft<CR>
  autocmd FileType perl,python,ruby,tcl
        \ inoremap <silent> <buffer> <C-X>! #!/usr/bin/env<Space><C-R>=&ft<CR>
  autocmd FileType javascript
        \ inoremap <silent> <buffer> <C-X>! #!/usr/bin/env<Space>node
  autocmd FileType help setlocal ai formatoptions+=2n
  autocmd FileType ruby setlocal comments=:#\ tw=78
  autocmd FileType liquid,markdown,text,txt setlocal tw=78 linebreak keywordprg=dict
  autocmd FileType markdown call SetBujoMappings()
augroup END
" }}}

" {{{1 rg/grep
if executable('rg')
  set grepprg=rg\ --no-heading\ --vimgrep\ --smart-case
endif
" }}}

" {{{1 vim-rhubarb
let g:github_enterprise_urls = ['https://github.iu.edu']
" }}}

" {{{1 vim-ragtag
let g:ragtag_global_maps = 1
" }}}

" {{{1 vim-surround
let b:surround_{char2nr('e')} = "\r\n}"
let g:surround_{char2nr('-')} = "<% \r %>"
let g:surround_{char2nr('=')} = "<%= \r %>"
let g:surround_{char2nr('8')} = "/* \r */"
let g:surround_{char2nr('s')} = " \r"
let g:surround_{char2nr('^')} = "/^\r$/"
let g:surround_indent = 1
" }}}

" {{{1 vim-markdown
let g:markdown_fenced_languages = ['ruby', 'html', 'javascript', 'css', 'bash=sh', 'sh']
" }}}

" {{{1 Spelling
if has('spell')
  setglobal spelllang=en_us
  setglobal spellfile=~/.vim/spell/en.utf-8.add
  let g:spellfile_URL = 'http://ftp.vim.org/vim/runtime/spell'
  autocmd FileType gitcommit setlocal spell
  autocmd FileType help if &buftype ==# 'help' | setlocal nospell | endif
endif

" }}}

" {{{ vim-bujo
" Remap these since surround attempts to take over experimental stuff
function! SetBujoMappings() abort
  nmap <buffer> <C-S> <Plug>BujoAddnormal
  imap <buffer> <C-S> <Plug>BujoAddinsert
  nmap <buffer> <C-Q> <Plug>BujoChecknormal
  imap <buffer> <C-Q> <Plug>BujoCheckinsert
endfunction
" }}}

" {{{1 ale
nmap <silent> [W <Plug>(ale_first)
nmap <silent> [w <Plug>(ale_previous)
nmap <silent> ]W <Plug>(ale_last)
nmap <silent> ]w <Plug>(ale_next)

" Always show sign column
let g:ale_sign_column_always = 1

" Set to show which linter says there is an issue
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
let g:ale_sign_error = '✖'
let g:ale_sign_info = 'ℹ'
let g:ale_sign_warning = '⚠'

let g:ale_set_balloons = 1
let g:ale_hover_to_preview = 1
let g:ale_hover_cursor = 1

let g:ale_linters = {
      \ "ruby": [ "brakeman", "rails_best_practices", "reek", "solargraph" ]
      \ }
let g:ale_fixers = {
      \ "*": [ "remove_trailing_lines" ],
      \ "ruby": [ "rubocop" ]
      \ }
let g:ale_fix_on_save = 1

function! LinterStatus() abort
  let l:counts = ale#statusline#Count(bufnr(''))

  let l:all_errors = l:counts.error + l:counts.style_error
  let l:all_non_errors = l:counts.total - l:all_errors

  return l:counts.total == 0 ? 'OK' : printf(
        \   '%dW %dE',
        \   all_non_errors,
        \   all_errors
        \)
endfunction

augroup ale_flagship
  autocmd!
  autocmd User Flags call Hoist("buffer", "LinterStatus")
augroup END

let g:ale_completion_symbols = {
      \ 'text': '',
      \ 'method': '',
      \ 'function': '',
      \ 'constructor': '',
      \ 'field': '',
      \ 'variable': '',
      \ 'class': '',
      \ 'interface': '',
      \ 'module': '',
      \ 'property': '',
      \ 'unit': 'unit',
      \ 'value': 'val',
      \ 'enum': '',
      \ 'keyword': 'keyword',
      \ 'snippet': '',
      \ 'color': 'color',
      \ 'file': '',
      \ 'reference': 'ref',
      \ 'folder': '',
      \ 'enum member': '',
      \ 'constant': '',
      \ 'struct': '',
      \ 'event': 'event',
      \ 'operator': '',
      \ 'type_parameter': 'type param',
      \ '<default>': 'v'
      \ }
" let g:ale_completion_enabled = 1
let g:ale_hover_to_floating_preview = 1
" }}}

if filereadable(expand("~/.vimrc_background"))
  let base16colorspace=256
  source ~/.vimrc_background
endif
