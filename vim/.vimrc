" {{{1 Plugins
call plug#begin(expand('~/.local/share/vim/plugins'))

Plug 'AndrewRadev/sideways.vim'       " Argument swapping
Plug 'AndrewRadev/splitjoin.vim'      " Splitting/Joining blocks
Plug 'bkad/CamelCaseMotion'           " Traverse CamelCaseWords (<Leader>w)
Plug 'christoomey/vim-tmux-navigator' " Tmux integration
Plug 'dense-analysis/ale'             " linting
Plug 'godlygeek/tabular'              " Easy tabbed formatting
Plug 'jiangmiao/auto-pairs'           " { } pairing
Plug 'junegunn/fzf.vim'               " Fuzzy finding
Plug 'kana/vim-textobj-user'          " Needed for rubyblock
Plug 'mattn/emmet-vim'                " Easy HTML
Plug 'morhetz/gruvbox'                " The best colorscheme
Plug 'nelstrom/vim-textobj-rubyblock' " ir and ar
Plug 'tpope/vim-commentary'           " For commenting
Plug 'tpope/vim-dispatch'             " Async test running
Plug 'tpope/vim-endwise'              " Endings
Plug 'tpope/vim-eunuch'               " Shell file operations
Plug 'tpope/vim-fugitive'             " Git
Plug 'tpope/vim-projectionist'        " Easy project traversal
Plug 'tpope/vim-rails'                " Rails
Plug 'tpope/vim-rake'                 " Rake
Plug 'tpope/vim-repeat'               " Make plugins repeatable
Plug 'tpope/vim-sleuth'               " Don't worry about tabs/spacing
Plug 'tpope/vim-surround'             " Surround mappings
Plug 'tpope/vim-unimpaired'           " [/] mappings
Plug 'tpope/vim-vinegar'              " File tree navigation
Plug 'vim-ruby/vim-ruby'              " Ruby
Plug 'vim-test/vim-test'              " Testing
Plug 'SirVer/ultisnips'               " Snippet manager
Plug 'honza/vim-snippets'             " Snippet repository

if isdirectory('/usr/local/opt/fzf')
  set rtp+=/usr/local/opt/fzf
elseif isdirectory('$HOME/.fzf')
  set rtp+=~/.fzf
else
  Plug 'junegunn/fzf'
endif

call plug#end()
" {{{1 Settings
let mapleader="\<Space>"

unlet! skip_defaults_vim
source $VIMRUNTIME/defaults.vim

set smarttab
set autoindent
set autoread
set background=dark
set belloff=all
set complete+=kspell
set cscopeverbose
set directory=$HOME/.local/share/vim/swap//
set diffopt+=vertical
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
set splitbelow
set splitright
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

" If I ever stop using vim-sleuth, set these again
" set expandtab
" set shiftwidth=2
" set softtabstop=2
set clipboard=unnamedplus,unnamed
set textwidth=80
set colorcolumn=+1
set formatoptions-=cro
set guioptions-=e
set hidden
set incsearch
set nobackup
set noerrorbells
set noswapfile
set nowrap
set number
set numberwidth=5
set relativenumber
set showtabline=2
set smartcase
set undofile
set updatetime=50

" {{{1 autogroups
augroup misc
  autocmd!

  " When resized, resize the windows inside
  autocmd VimResized * execute "normal! \<c-w>="

  " Nest source on changes to vimrc
  autocmd BufWritePost .vimrc,init.vim,vimrc nested source %

  autocmd BufEnter,BufNewFile .zshrc,zshrc setlocal filetype=zsh

  autocmd BufWritePre * :call whitespace#trim()

  " When editing a file, always jump to the last known cursor position.
  " Don't do it for commit messages, when the position is invalid, or when
  " inside an event handler (happens when dropping a file on gvim).
  autocmd BufReadPost *
        \ if &ft != 'gitcommit' && line("'\"") > 0 && line("'\"") <= line("$") |
        \   exe "normal g`\"" |
        \ endif
augroup end

augroup ruby
  autocmd!
  " Make ? part of a keyword
  autocmd FileType ruby,eruby,yaml setlocal iskeyword+=?
augroup end

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

" Tab completion
" will insert tab at beginning of line,
" will use completion if not at beginning
set wildmode=list:longest,list:full
function! InsertTabWrapper()
    let col = col('.') - 1
    if !col || getline('.')[col - 1] !~ '\k'
        return "\<Tab>"
    else
        return "\<C-p>"
    endif
endfunction
inoremap <Tab> <C-r>=InsertTabWrapper()<CR>
inoremap <S-Tab> <C-n>

" Switch between the last two files
nnoremap <Leader><Leader> <C-^>

" {{{1 netrw config
let g:netrw_browse_split = 2
let g:netrw_banner = 0
let g:netrw_winsize = 25

" {{{1 rg/grep
if executable('rg')
  set grepprg=rg\ --no-heading\ --vimgrep\ --smart-case
  " Use The Silver Searcher https://github.com/ggreer/the_silver_searcher
elseif executable('ag')
  " Use Ag over Grep
  set grepprg=ag\ --nogroup\ --nocolor

  " Use ag in fzf for listing files. Lightning fast and respects .gitignore
  let $FZF_DEFAULT_COMMAND = 'ag --literal --files-with-matches --nocolor --hidden -g ""'

  if !exists(":Ag")
    command -nargs=+ -complete=file -bar Ag silent! grep! <args>|cwindow|redraw!
    nnoremap \ :Ag<SPACE>
  endif
endif

" {{{1 spelling
if has('spell')
  setglobal spelllang=en_us
  setglobal spellfile=~/.vim/spell/en.utf-8.add
  let g:spellfile_URL = 'http://ftp.vim.org/vim/runtime/spell'
  autocmd FileType gitcommit setlocal spell
  autocmd FileType help if &buftype ==# 'help' | setlocal nospell | endif
endif

" {{{1 Ultisnips
let g:UltiSnipsExpandTrigger = '<c-j>'

" {{{1 Vim-Test
nmap <silent> <leader>t :TestNearest<CR>
nmap <silent> <leader>T :TestFile<CR>
nmap <silent> <leader>a :TestSuite<CR>
nmap <silent> <leader>l :TestLast<CR>
let g:test#strategy = 'dispatch'

" {{{1 ALE
nmap <silent> ]d         <Plug>(ale_next_wrap)
nmap <silent> [d         <Plug>(ale_previous_wrap)
nmap <silent> gd         <Plug>(ale_go_to_definition)
nmap <silent> gr         <Plug>(ale_find_references)
nmap <silent> K          <Plug>(ale_hover)
nmap <silent> <leader>e  <Plug>(ale_detail)
nmap <silent> <leader>rn <Plug>(ale_rename)
nmap <silent> <leader>f  <Plug>(ale_fix)

" Set to show which linter says there is an issue
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
" Custom images for issues
let g:ale_sign_error = ' '
let g:ale_sign_info = ' '
let g:ale_sign_warning = ' '
let g:ale_fixers = {'ruby': ['rubocop']}
let g:ale_fix_on_save = 1
let g:ale_floating_preview = 1
let g:ale_cursor_detail = 1
let g:ale_completion_enabled = 1
set omnifunc=ale#completion#OmniFunc
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

augroup AleOmni
  au!
  autocmd FileType ruby setlocal omnifunc=ale#completion#OmniFunc
  autocmd VimEnter *
        \ set updatetime=1000 |
        \ let g:ale_lint_on_text_changed = 0
  autocmd CursorHold * call ale#Queue(0)
  autocmd CursorHoldI * call ale#Queue(0)
  autocmd InsertEnter * call ale#Queue(0)
  autocmd InsertLeave * call ale#Queue(0)
augroup END

" {{{ Misc
" When the type of shell script is /bin/sh, assume a POSIX-compatible
" shell for syntax highlighting purposes.
let g:is_posix = 1

call camelcasemotion#CreateMotionMappings('<leader>')

nnoremap <silent> <C-p> :Files<CR>

" Treat <li> and <p> tags like the block tags they are
let g:html_indent_tags = 'li\|p'

" {{{1 Colorscheme
let g:gruvbox_italic = 1
let g:gruvbox_transparent_bg = 1
let g:gruvbox_contrast_dark = 'hard'
let g:gruvbox_italicize_strings = 1
call transparency#enable()
colorscheme gruvbox

" {{{ Modeline
" vim: nowrap fdm=marker
