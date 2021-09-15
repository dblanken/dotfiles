" {{{1 Plugins
set packpath^=~/.local/share/vim
function! PackInit() abort
  packadd minpac

  call minpac#init()
  call minpac#add('k-takata/minpac', {'type': 'opt'})

  call minpac#add('AndrewRadev/sideways.vim')       " Argument swapping
  call minpac#add('AndrewRadev/splitjoin.vim')      " Splitting/Joining blocks
  call minpac#add('bkad/CamelCaseMotion')           " Traverse CamelCaseWords (<Leader>w)
  call minpac#add('christoomey/vim-tmux-navigator') " Tmux integration
  call minpac#add('dense-analysis/ale')             " linting
  call minpac#add('godlygeek/tabular')              " Easy tabbed formatting
  call minpac#add('jiangmiao/auto-pairs')           " { } pairing
  call minpac#add('junegunn/fzf.vim')               " Fuzzy finding
  call minpac#add('kana/vim-textobj-user')          " Needed for rubyblock
  call minpac#add('mattn/emmet-vim')                " Easy HTML
  call minpac#add('morhetz/gruvbox')                " The best colorscheme
  call minpac#add('nelstrom/vim-textobj-rubyblock') " ir and ar
  call minpac#add('tpope/vim-commentary')           " For commenting
  call minpac#add('tpope/vim-dispatch')             " Async test running
  call minpac#add('tpope/vim-endwise')              " Endings
  call minpac#add('tpope/vim-eunuch')               " Shell file operations
  call minpac#add('tpope/vim-fugitive')             " Git
  call minpac#add('tpope/vim-projectionist')        " Easy project traversal
  call minpac#add('tpope/vim-rails')                " Rails
  call minpac#add('tpope/vim-rake')                 " Rake
  call minpac#add('tpope/vim-repeat')               " Make plugins repeatable
  call minpac#add('tpope/vim-sensible')             " I prefer these defaults
  call minpac#add('tpope/vim-sleuth')               " Don't worry about tabs/spacing
  call minpac#add('tpope/vim-surround')             " Surround mappings
  call minpac#add('tpope/vim-unimpaired')           " [/] mappings
  call minpac#add('tpope/vim-vinegar')              " File tree navigation
  call minpac#add('vim-ruby/vim-ruby')              " Ruby
  call minpac#add('vim-test/vim-test')              " Testing
  call minpac#add('SirVer/ultisnips')               " Snippet manager
  call minpac#add('honza/vim-snippets')             " Snippet repository

  if isdirectory('/usr/local/opt/fzf')
    set rtp+=/usr/local/opt/fzf
  elseif isdirectory('$HOME/.fzf')
    set rtp+=~/.fzf
  else
    call minpac#add('junegunn/fzf')
  endif
endfunction

" Define user commands for updating/cleaning the plugins.
" Each of them calls PackInit() to load minpac and register
" the information of plugins, then performs the task.
command! PackUpdate call PackInit() | call minpac#update()
command! PackClean  call PackInit() | call minpac#clean()
command! PackStatus packadd minpac | call minpac#status()

" {{{1 Settings
let mapleader="\<Space>"

if !has('nvim')
  unlet! skip_defaults_vim
  source $VIMRUNTIME/defaults.vim
else
  let g:loaded_sensible = 1
end

set autoindent
set autoread
set background=dark
set belloff=all
set clipboard=unnamedplus,unnamed
set colorcolumn=+1
set complete+=kspell
set cscopeverbose
set diffopt+=vertical
set directory=$HOME/.local/share/vim/swap//
set encoding=utf8
set expandtab
set fileencoding=utf8
set fillchars="vert:│,fold:·"
set formatoptions+=j
set formatoptions-=cro
set guioptions-=e
set hidden
set history=10000
set hlsearch
set incsearch
set laststatus=2
set listchars="tab:> ,trail:-,nbsp:+"
set nobackup
set noerrorbells
set noswapfile
set nowrap
set nrformats-=octal
set number
set numberwidth=5
set relativenumber
set sessionoptions+=unix,slash
set sessionoptions-=options
set shiftwidth=2
set shortmess+=F
set shortmess-=S
set showtabline=2
set sidescroll=1
set signcolumn=yes
set smartcase
set smarttab
set softtabstop=2
set splitbelow
set splitright
set tabpagemax=50
set textwidth=80
set ttimeoutlen=50
set undodir=$HOME/.local/share/vim/undo
set undofile
set updatetime=50
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
  autocmd FileType mail,gitcommit setlocal tw=72 spell
  autocmd FileType sh,zsh,csh,tcsh setlocal fo-=t|
        \ inoremap <silent> <buffer> <C-X>! #!/bin/<C-R>=&ft<CR>
  autocmd FileType perl,python,ruby,tcl
        \ inoremap <silent> <buffer> <C-X>! #!/usr/bin/env<Space><C-R>=&ft<CR>
  autocmd FileType javascript
        \ inoremap <silent> <buffer> <C-X>! #!/usr/bin/env<Space>node
  autocmd FileType help setlocal ai formatoptions+=2n
  autocmd FileType ruby setlocal comments=:#\ tw=78
  autocmd BufRead,BufNewFile *.md set filetype=markdown
  autocmd FileType liquid,markdown,text,txt setlocal tw=78 linebreak keywordprg=dict spell
  " When editing a file, always jump to the last known cursor position.
  " Don't do it for commit messages, when the position is invalid, or when
  " inside an event handler (happens when dropping a file on gvim).
  autocmd BufReadPost *
        \ if &ft != 'gitcommit' && line("'\"") > 0 && line("'\"") <= line("$") |
        \   exe "normal g`\"" |
        \ endif
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

nnoremap <Leader>h :nohl<CR>
nnoremap <Leader><Leader> <C-^>

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

" Next, center in screen, open folds
nnoremap n nzzzv
nnoremap N Nzzzv
" Mark z, J, go back to mark z
nnoremap J mzJ`z

" Undo breakpoints
inoremap , ,<c-g>u
inoremap . .<c-g>u
inoremap ! !<c-g>u
inoremap ? ?<c-g>u
inoremap = =<c-g>u
inoremap [ [<c-g>u
inoremap ] ]<c-g>u
inoremap { {<c-g>u
inoremap } }<c-g>u

" Add counted jumps to jump list
nnoremap <expr> k (v:count > 5 ? "m'" . v:count : "") . 'k'
nnoremap <expr> j (v:count > 5 ? "m'" . v:count : "") . 'j'

" Visual moving of lines
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

" {{{1 netrw config
let g:netrw_browse_split = 2
let g:netrw_banner = 0
let g:netrw_winsize = 25

" {{{1 rg/ag/grep
if executable('rg')
  set grepprg=rg\ --no-heading\ --vimgrep\ --smart-case
  " Use ag in fzf for listing files. Lightning fast and respects .gitignore
  let $FZF_DEFAULT_COMMAND = 'rg --hidden -no-ignore -l ""'

  if !exists(":Rg")
    command -nargs=+ -complete=file -bar Rg silent! grep! <args>|cwindow|redraw!
    nnoremap \ :Rg<SPACE>
  endif

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
let g:ale_fixers = {'ruby': ['standardrb', 'remove_trailing_lines', 'trim_whitespace']}
let g:ale_linters = {'ruby': ['standardrb', 'debride', 'brakeman', 'rails_best_practices', 'reek', 'solargraph']}
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

" {{{1 Misc
" When the type of shell script is /bin/sh, assume a POSIX-compatible
" shell for syntax highlighting purposes.
let g:is_posix = 1

" For some reason, CreateMotionMappings is not avaialble on initial startup, so
" it must wait until VimEnter
augroup CamelCaseMotions
 au!
 autocmd VimEnter call camelcasemotion#CreateMotionMappings('<leader>')
augroup END

nnoremap <silent> <C-p> :Files<CR>

" Treat <li> and <p> tags like the block tags they are
let g:html_indent_tags = 'li\|p'

let g:rubycomplete_rails = 1

iabbrev inc include
iabbrev req require
iabbrev eac each

" {{{1 Status line
set statusline=%<%f\ %h%m%r%{FugitiveStatusline()}%=%-14.(%l,%c%V%)\ %P

" {{{1 Colorscheme
let g:gruvbox_italic = 1
let g:gruvbox_transparent_bg = 1
let g:gruvbox_contrast_dark = 'hard'
let g:gruvbox_italicize_strings = 1
call transparency#enable()
colorscheme gruvbox

" {{{1 Modeline
" vim: nowrap fdm=marker
