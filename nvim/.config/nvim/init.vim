"
"              _
"   _ __   ___(_)_ __ ___   ___   ___  _ __
"  | '_ \ / _ \ | '_ ` _ \ / _ \ / _ \| '_ \
"  | | | |  __/ | | | | | | (_) | (_) | | | |
"  |_| |_|\___|_|_| |_| |_|\___/ \___/|_| |_|
"
"
" {{{ General Settings
let mapleader = "\<Space>"

set expandtab
set tabstop=2
set softtabstop=2
set shiftwidth=2
set number
set relativenumber
set notermguicolors
set scrolloff=8
set sidescrolloff=8

" {{{ Plugins
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin(data_dir . '/plugins')

source ~/.config/nvim/plugins/CamelCaseMotion.vim
source ~/.config/nvim/plugins/abolish.vim
source ~/.config/nvim/plugins/apathy.vim
source ~/.config/nvim/plugins/bundler.vim
source ~/.config/nvim/plugins/cmp.vim
source ~/.config/nvim/plugins/commentary.vim
source ~/.config/nvim/plugins/copilot.vim
source ~/.config/nvim/plugins/dadbod.vim
source ~/.config/nvim/plugins/dispatch.vim
source ~/.config/nvim/plugins/dracula.vim
source ~/.config/nvim/plugins/emmet.vim
source ~/.config/nvim/plugins/endwise.vim
source ~/.config/nvim/plugins/eunuch.vim
source ~/.config/nvim/plugins/fugitive.vim
source ~/.config/nvim/plugins/git.vim
source ~/.config/nvim/plugins/jdaddy.vim
source ~/.config/nvim/plugins/lightline-lsp.vim
source ~/.config/nvim/plugins/lightline-webdevicons.vim
source ~/.config/nvim/plugins/lightline.vim
source ~/.config/nvim/plugins/lspconfig.vim
source ~/.config/nvim/plugins/markdown-preview.vim
source ~/.config/nvim/plugins/markdown.vim
source ~/.config/nvim/plugins/nvim-web-devicons.vim
source ~/.config/nvim/plugins/pandoc.vim
source ~/.config/nvim/plugins/projectionist.vim
source ~/.config/nvim/plugins/ragtag.vim
source ~/.config/nvim/plugins/rails.vim
source ~/.config/nvim/plugins/rake.vim
source ~/.config/nvim/plugins/repeat.vim
source ~/.config/nvim/plugins/rhubarb.vim
source ~/.config/nvim/plugins/ruby.vim
source ~/.config/nvim/plugins/sleuth.vim
source ~/.config/nvim/plugins/speeddating.vim
source ~/.config/nvim/plugins/splitjoin.vim
source ~/.config/nvim/plugins/surround.vim
source ~/.config/nvim/plugins/tabber.vim
source ~/.config/nvim/plugins/telescope.vim
source ~/.config/nvim/plugins/test.vim
source ~/.config/nvim/plugins/tmux-navigator.vim
source ~/.config/nvim/plugins/transparent.vim
source ~/.config/nvim/plugins/treesitter.vim
source ~/.config/nvim/plugins/unimpaired.vim
source ~/.config/nvim/plugins/vinegar.vim

call plug#end()
" Call this here in case we don't load any theme plugins
colorscheme desert
doautocmd User PlugLoaded

" {{{ Mappings
nnoremap <Leader>ve :e ~/.config/nvim/init.vim<CR>'
nnoremap <Leader>vr :source ~/.config/nvim/init.vim<CR>:PlugInstall<CR>:source ~/.config/nvim/init.vim<CR>
nnoremap gf :edit <cfile><CR>
nnoremap Q @q
nnoremap <Leader>= migg=G`i
nnoremap Y y$
nnoremap <Leader>h :nohl<CR>
nnoremap <Leader><Leader> <C-^>
tnoremap <Esc> <C-\><C-n>

nnoremap n nzzzv
nnoremap N Nzzzv
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

" Reselect visual selection after indenting
vnoremap < <gv
vnoremap > >gv

" Maintain the cursor position when yanking a visual selection
" http://ddrscott.github.io/blog/2016/yank-without-jank/
vnoremap y myy`y
vnoremap Y myY`y

" Visual moving of lines
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

imap ;; <Esc>A;<Esc>
imap ,, <Esc>A,<Esc>

" {{{ rg/ag/grep
if executable('rg')
  set grepprg=rg\ --no-heading\ --vimgrep\ --smart-case

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

" {{{ Miscellaneous
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
  "
  autocmd BufReadPost *
        \ if &ft != 'gitcommit' && line("'\"") > 0 && line("'\"") <= line("$") |
        \   exe "normal g`\"" |
        \ endif
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
  autocmd FileType help setlocal ai formatoptions+=2n nospell
  autocmd FileType ruby setlocal comments=:#\ tw=78
  autocmd BufRead,BufNewFile *.md set filetype=markdown
  autocmd FileType liquid,markdown,text,txt setlocal tw=78 linebreak keywordprg=dict spell
augroup END

let g:netrw_browse_split = 2
let g:netrw_banner = 0
let g:netrw_winsize = 25

setglobal spelllang=en_us
setglobal spellfile=~/.vim/spell/en.utf-8.add
let g:spellfile_URL = 'http://ftp.vim.org/vim/runtime/spell'

