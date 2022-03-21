if $VIM_BARE
  setglobal noloadplugins
  finish
endif

filetype plugin on

exe 'augroup my'
autocmd!
setglobal nocompatible

let mapleader=' '

" Section: Moving around, searching, patterns, and tags

setglobal cpoptions+=J
setglobal smartcase
setglobal incsearch
setglobal include=
setglobal path=.,,

" Section: Displaying text

setglobal display=lastline
setglobal scrolloff=1
setglobal sidescrolloff=5
setglobal lazyredraw
set cmdheight=2
set breakindent showbreak=\ +
if (&termencoding ==# 'utf-8' || &encoding ==# 'utf-8') && v:version >= 700
  let &g:listchars = "tab:\u21e5\u00b7,trail:\u2423,extends:\u21c9,precedes:\u21c7,nbsp:\u00b7"
  let &g:fillchars = "vert:\u250b,fold:\u00b7"
else
  setglobal listchars=tab:>\ ,trail:-,extends:>,precedes:<
endif

" Section: Windows

setglobal laststatus=2
setglobal showtabline=2
if empty(&g:statusline)
  setglobal statusline=[%n]\ %<%.99f\ %y%h%w%m%r%=%-14.(%l,%c%V%)\ %P
endif
setglobal titlestring=%{v:progname}\ %{tolower(empty(v:servername)?'':'--servername\ '.v:servername.'\ ')}%{fnamemodify(getcwd(),':~')}%{exists('$SSH_TTY')?'\ <'.hostname().'>':''}
setglobal iconstring=%{tolower(empty(v:servername)?v:progname\ :\ v:servername)}%{exists('$SSH_TTY')?'@'.hostname():''}

" Section: GUI

if has('nvim') && len($TMUX)
  set guicursor=
endif
setglobal printoptions=paper:letter
setglobal mousemodel=popup

if $TERM =~# '^screen' || $TERM =~# '^tmux'
  if exists('+ttymouse') && &ttymouse ==# ''
    setglobal ttymouse=xterm
  endif
endif

autocmd FocusLost * let s:confirm = &confirm | setglobal noconfirm | silent! wall | let &confirm = s:confirm

" Section: Messages and info

setglobal confirm
setglobal showcmd
setglobal visualbell
syntax enable
set number
set relativenumber
set signcolumn=yes

" Section: Editing text and indent

setglobal textwidth=0
setglobal backspace=2
setglobal complete-=i
setglobal formatoptions+=j
setglobal infercase
setglobal showmatch
setglobal virtualedit=block

setglobal shiftround
setglobal smarttab
setglobal autoindent
setglobal omnifunc=syntaxcomplete#Complete
setglobal completefunc=syntaxcomplete#Complete

autocmd FileType json set sw=2 et

" Section: Folding and Comments

setglobal foldmethod=marker
setglobal foldopen+=jump
setglobal commentstring=#\ %s
if !get(v:, 'vim_did_enter', !has('vim_starting'))
  setlocal commentstring<
endif

autocmd FileType git,gitcommit        setlocal foldmethod=syntax foldlevel=1

inoremap <C-X>^ <C-R>=substitute(&commentstring,' \=%s\>'," -*- ".&ft." -*- vim:set ft=".&ft." ".(&et?"et":"noet")." sw=".&sw.(&sts ? " sts=".&sts : "").':','')<CR>

" Section: Maps

setglobal timeoutlen=1200
setglobal ttimeoutlen=50

digraph ,. 8230
digraph cl 8984

nnoremap Y y$
nnoremap Q @q

" Section: Reading and writing files

setglobal autoread
setglobal autowrite
setglobal fileformats=unix,dos,mac

set undofile
setglobal viminfo=!,'20,<50,s10,h
if !empty($SUDO_USER) && $USER !=# $SUDO_USER
  setglobal viminfo=
  setglobal directory-=~/tmp
  setglobal backupdir-=~/tmp
elseif exists('+undofile')
  setglobal undodir=~/.cache/vim/undo
  if !isdirectory(&undodir)
    call mkdir(&undodir, 'p')
  endif
  setglobal directory=~/.cache/vim/swap//
  if !isdirectory(&directory)
    call mkdir(&directory, 'p')
  endif
  setglobal backupdir=~/.cache/vim/backup
  if !isdirectory(&backupdir)
    call mkdir(&backupdir, 'p')
  endif
endif 

" Section: Command line editing

setglobal history=200
setglobal wildmenu
setglobal wildmode=full
setglobal wildignore+=tags,.*.un~,*.pyc

" Section: External commands

setglobal grepformat=%f:%l:%c:%m,%f:%l:%m,%f:%l%m,%f\ \ %l%m
if executable('ag')
  setglobal grepprg=ag\ -s\ --vimgrep
elseif has('unix')
  setglobal grepprg=grep\ -rn\ $*\ /dev/null
endif

autocmd FileType tmux let b:dispatch = 'tmux source %:p:S'
autocmd FileType html let b:dispatch = ':Browse'

" Section: Filetype settings

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
autocmd FileType tex setlocal formatoptions+=l
autocmd FileType vim setlocal keywordprg=:help |
      \ if &foldmethod !=# 'diff' | setlocal foldmethod=expr foldlevel=1 | endif |
    \ setlocal foldexpr=getline(v:lnum)=~'^\"\ Section:'?'>1':'='

let g:sh_fold_enabled = has('folding')
let g:is_posix = 1
let g:go_fmt_autosave = 0
let g:sql_type_default = 'mysql'

" Section: Highlighting

setglobal spelllang=en_us
setglobal spellfile=~/.vim/spell/en.utf-8.add
let g:spellfile_URL = 'http://ftp.vim.org/vim/runtime/spell'
autocmd FileType gitcommit setlocal spell
autocmd FileType help if &buftype ==# 'help' | setlocal nospell | endif

" Section: Plugins

call plug#begin()

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
Plug 'tpope/vim-flagship'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-git'
Plug 'tpope/vim-jdaddy'
Plug 'tpope/vim-markdown'
Plug 'tpope/vim-obsession'
Plug 'tpope/vim-projectionist'
Plug 'tpope/vim-ragtag'
Plug 'tpope/vim-rails'
Plug 'tpope/vim-rake'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-rhubarb'
Plug 'tpope/vim-scriptease'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-speeddating'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-tbone'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-vinegar'
Plug 'tpope/vim-vividchalk'

Plug 'christoomey/vim-tmux-navigator'
Plug 'vim-test/vim-test'
Plug 'tribela/vim-transparent'
Plug 'dense-analysis/ale'
Plug 'ecomba/vim-ruby-refactoring'
Plug 'kana/vim-textobj-user'
Plug 'nelstrom/vim-textobj-rubyblock'

Plug 'gruvbox-community/gruvbox'

call plug#end()

" Section: Plugin settings

let g:omni_sql_no_default_maps = 1
let g:sh_noisk = 1
let g:markdown_fenced_languages = ['ruby', 'html', 'javascript', 'css', 'bash=sh', 'sh']
let g:liquid_highlight_types = g:markdown_fenced_languages + ['jinja=liquid', 'html+erb=eruby.html', 'html+jinja=liquid.html']

let g:CSApprox_verbose_level = 0
let g:NERDTreeHijackNetrw = 0
let g:netrw_dirhistmax = 0
let g:ragtag_global_maps = 1
let b:surround_{char2nr('e')} = "\r\n}"
let g:surround_{char2nr('-')} = "<% \r %>"
let g:surround_{char2nr('=')} = "<%= \r %>"
let g:surround_{char2nr('8')} = "/* \r */"
let g:surround_{char2nr('s')} = " \r"
let g:surround_{char2nr('^')} = "/^\r$/"
let g:surround_indent = 1

nmap <silent> <leader>t :TestNearest<CR>
nmap <silent> <leader>T :TestFile<CR>
nmap <silent> <leader>a :TestSuite<CR>
nmap <silent> <leader>l :TestLast<CR>
let test#strategy = 'dispatch' " or 'dispatch_background'

nmap <silent> ]d :ALENext<CR>
nmap <silent> [d :ALEPrevious<CR>

let g:gruvbox_italic=1
let g:gruvbox_italicize_strings=1
let g:colors_name='gruvbox'
set background=light
colorscheme gruvbox

if (&t_Co > 2 || has('gui_running')) && has('syntax')
  if &g:highlight =~# 'NonText'
    let &g:highlight = substitute(&g:highlight, 'NonText', 'SpecialKey', 'g')
  endif
  if !exists('syntax_on') && !exists('syntax_manual')
    exe 'augroup END'
    syntax on
    exe 'augroup my'
  endif
  if !get(v:, 'vim_did_enter', !has('vim_starting'))
    set list
    if !exists('g:colors_name')
      colorscheme vividchalk
    endif
  endif

  autocmd Syntax sh   syn sync minlines=500
  autocmd Syntax css  syn sync minlines=50
endif

" Section: Misc

setglobal sessionoptions-=buffers sessionoptions-=curdir sessionoptions+=sesdir,globals
autocmd VimEnter * nested
      \ if !argc() && empty(v:this_session) && filereadable('Session.vim') && !&modified |
      \   source Session.vim |
      \ endif

" Section: Fin

if filereadable(expand('~/.vimrc.local'))
  source ~/.vimrc.local
endif

exe 'augroup END'

" vim:set et sw=2 foldmethod=expr"
