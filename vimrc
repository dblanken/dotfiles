let skip_defaults_vim=1
set nocompatible

set autoindent
set autowrite
set number relativenumber
set ruler
set showmode
set tabstop=2
set softtabstop=2
set shiftwidth=2
set smartindent
set smarttab
set expandtab

if v:version >= 800
  set nofixendofline

  " better ascii friendly listchars
  set listchars=space:*,trail:*,nbsp:*,extends:>,precedes:<,tab:\|>

  set foldmethod=manual
endif

match ErrorMsg '\s\+$'

set textwidth=72

highlight NonText guifg=bg

set nobackup
set noswapfile
set nowritebackup

set icon

set hlsearch
set incsearch
set linebreak
map <silent> <leader><cr> :noh<cr>:redraw!<cr>

set shortmess=aoOtI

set viminfo='20,<1000,s1000

let g:loaded_matchparen=1
set noshowmatch

" Just the defaults, these are changed per filetype by plugins.
" Most of the utility of all of this has been superceded by the use of
" modern simplified pandoc for capturing knowledge source instead of
" arbitrary raw text files.

set formatoptions-=t   " don't auto-wrap text using text width
set formatoptions+=c   " autowrap comments using textwidth with leader
set formatoptions-=r   " don't auto-insert comment leader on enter in insert
set formatoptions-=o   " don't auto-insert comment leader on o/O in normal
set formatoptions+=q   " allow formatting of comments with gq
set formatoptions-=w   " don't use trailing whitespace for paragraphs
set formatoptions-=a   " disable auto-formatting of paragraph changes
set formatoptions-=n   " don't recognized numbered lists
set formatoptions+=j   " delete comment prefix when joining
set formatoptions-=2   " don't use the indent of second paragraph line
set formatoptions-=v   " don't use broken 'vi-compatible auto-wrapping'
set formatoptions-=b   " don't use broken 'vi-compatible auto-wrapping'
set formatoptions+=l   " long lines not broken in insert mode
set formatoptions+=m   " multi-byte character line break support
set formatoptions+=M   " don't add space before or after multi-byte char
set formatoptions-=B   " don't add space between two multi-byte chars in join 
set formatoptions+=1   " don't break a line after a one-letter word

" requires PLATFORM env variable set (in ~/.bashrc)
if $PLATFORM == 'mac'
  " required for mac delete to work
  set backspace=indent,eol,start
endif


" stop complaints about switching buffer with changes
set hidden

" command history
set history=100

" here because plugins and stuff need it
syntax enable

" faster scrolling
set ttyfast

" allow sensing the filetype
filetype plugin on

" Install vim-plug if not already installed
if v:version >= 800 && executable('curl') && empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
      \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall
endif

if filereadable(expand("~/.vim/autoload/plug.vim"))
  call plug#begin('~/.vimplugins')
  Plug 'tpope/vim-commentary'
  Plug 'tpope/vim-rails'
  Plug 'tpope/vim-dispatch'
  Plug 'tpope/vim-fugitive'
  Plug 'tpope/vim-unimpaired'
  Plug 'vim-test/vim-test'
  call plug#end()
endif

" Plugin-specific: Vim-Test
nmap <silent> <leader>t :TestNearest<CR>
nmap <silent> <leader>T :TestFile<CR>
nmap <silent> <leader>a :TestSuite<CR>
nmap <silent> <leader>l :TestLast<CR>
let test#strategy = 'dispatch'

" high contrast for streaming, etc.
set background=dark

hi Normal ctermbg=NONE " for transparent background
hi SpellBad ctermbg=red " for transparent background
hi SpellRare ctermbg=red
hi Special ctermfg=cyan
au FileType pandoc hi pandocAtxHeader ctermfg=yellow cterm=bold
au FileType pandoc hi pandocAtxHeaderMark ctermfg=yellow cterm=bold
au FileType pandoc hi pandocAtxStart ctermfg=yellow cterm=bold

set noruler
set laststatus=2
set statusline=
set statusline+=%*\ %<%.60F%*                      " path, trunc to 80 length
set statusline+=\ [%{strlen(&ft)?&ft:'none'}]      " filetype
set statusline+=%*\ %l:%c%*                        " current line and column
set statusline+=%*\ %p%%%*                         " percentage
set cmdheight=1

" if you are gonna visual, might as well...
vmap < <gv
vmap > >gv

" make Y consitent with D and C (yank til end)
map Y y$

" better command-line completion
set wildmenu

" disable search highlighting with <C-L> when refreshing screen
nnoremap <C-L> :nohl<CR><C-L>

" enable omni-completion
set omnifunc=syntaxcomplete#Complete

" force some file names to be specific file type
au bufnewfile,bufRead *.bash* set ft=sh
au bufnewfile,bufRead *.pegn set ft=config
au bufnewfile,bufRead *.profile set filetype=sh
au bufnewfile,bufRead *.crontab set filetype=crontab
au bufnewfile,bufRead *ssh/config set filetype=sshconfig
au bufnewfile,bufRead .dockerignore set filetype=gitignore
au bufnewfile,bufRead *gitconfig set filetype=gitconfig
au bufnewfile,bufRead /tmp/psql.edit.* set syntax=sql
au bufnewfile,bufRead doc.go set spell

" displays all the syntax rules for current position, useful
" when writing vimscript syntax plugins
function! <SID>SynStack()
  if !exists("*synstack")
    return
  endif
    echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc  

" start at last place you were editing
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

" functions keys
map <F1> :set number!<CR> :set relativenumber!<CR>
nmap <F2> :call <SID>SynStack()<CR>
set pastetoggle=<F3>
map <F4> :set list!<CR>
map <F5> :set cursorline!<CR>
map <F7> :set spell!<CR>
map <F12> :set fdm=indent<CR>

nmap <leader>2 :set paste<CR>i

" disable arrow keys (vi muscle memory)
noremap <up> :echoerr "Umm, use k instead"<CR>
noremap <down> :echoerr "Umm, use j instead"<CR>
noremap <left> :echoerr "Umm, use h instead"<CR>
noremap <right> :echoerr "Umm, use l instead"<CR>
inoremap <up> <NOP>
inoremap <down> <NOP>
inoremap <left> <NOP>
inoremap <right> <NOP>

" Map alternatives the <ESC> key (<C-[> already is) 
inoremap jj <Esc>
cnoremap jj <Esc>
inoremap kk <Esc> 
cnoremap kk <Esc>
inoremap kj <Esc>
cnoremap kj <Esc> 

" Better page down and page up
noremap <C-n> <C-d>
noremap <C-p> <C-b>

hi StatusLineNC term=bold cterm=bold gui=bold
hi StatusLine term=bold cterm=bold gui=bold
