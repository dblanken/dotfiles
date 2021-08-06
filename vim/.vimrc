" vim: nowrap fdm=marker

let mapleader="\<Space>"

" {{{1 Settings
if !has('nvim')
	unlet! skip_defaults_vim
	source $VIMRUNTIME/defaults.vim
endif

" Save our packages in a different location outside of our dotfiles
let g:config = expand('~/.local/share/vim')
let &packpath= g:config . "," . &packpath

" My attempt to get as close to a nvim setup for vim as I can
" Referenced :h defaults in neovim
set autoindent
set autoread
set background=dark
set belloff=all
set cscopeverbose
let &directory = g:config . '/swap//'
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
set signcolumn=auto
set tabpagemax=50
set ttimeoutlen=50
let &undodir = g:config . '/undo'
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

" Stuff not in either version
set clipboard=unnamedplus,unnamed
set colorcolumn=80
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
let s:minpac_dir = g:config . '/pack/minpac/opt/minpac'
if !isdirectory(s:minpac_dir)
	silent! execute printf('!git clone https://github.com/k-takata/minpac.git %s', s:minpac_dir)
end

function! PackInit() abort
	packadd minpac

	call minpac#init()
	call minpac#add('k-takata/minpac', {'type': 'opt'})

	call minpac#add('chriskempson/base16-vim')
	call minpac#add('christoomey/vim-tmux-navigator')
	call minpac#add('machakann/vim-highlightedyank')
	call minpac#add('tpope/vim-commentary')
	call minpac#add('tpope/vim-dispatch')
	call minpac#add('tpope/vim-endwise')
	call minpac#add('tpope/vim-eunuch')
	call minpac#add('tpope/vim-flagship')
	call minpac#add('tpope/vim-fugitive')
	call minpac#add('tpope/vim-projectionist')
	call minpac#add('tpope/vim-rails')
	call minpac#add('tpope/vim-repeat')
	call minpac#add('tpope/vim-sensible')
	call minpac#add('tpope/vim-sleuth')
	call minpac#add('tpope/vim-surround')
	call minpac#add('tpope/vim-unimpaired')
	call minpac#add('tpope/vim-vinegar')
	call minpac#add('tweekmonster/startuptime.vim')
	call minpac#add('vim-test/vim-test')
	call minpac#add('junegunn/fzf.vim')
	call minpac#add('junegunn/fzf', { 'do': '!./install --bin' })
	call minpac#add('SirVer/ultisnips')
	call minpac#add('honza/vim-snippets')

endfunction

command! PackUpdate source $MYVIMRC | call PackInit() | call minpac#update()
command! PackClean  source $MYVIMRC | call PackInit() | call minpac#clean()
command! PackStatus packadd minpac | call minpac#status()
command PackInstall PackUpdate
" }}}

" {{{1 autogroups
augroup events
	autocmd!

	" When resized, resize the windows inside
	autocmd VimResized * execute "normal! \<c-w>="

	" Nest source on changes to vimrc
	autocmd BufWritePost .vimrc,init.vim,vimrc nested source %

	autocmd BufEnter,BufNewFile .zshrc,zshrc setlocal filetype=zsh

	autocmd BufWritePre * :call whitespace#trim()
augroup end

augroup filetypes
	autocmd!

	autocmd FileType * setlocal nolinebreak
	autocmd FileType sh,zsh,csh,tcsh setlocal fo-=t
	autocmd FileType liquid,markdown,text,txt setlocal tw=78 linebreak keywordprg=dict
	autocmd FileType ruby,eruby,yaml setlocal iskeyword+=?
augroup END

" }}}
" {{{1 rg/grep
if executable('rg')
	set grepprg=rg\ --no-heading\ --vimgrep\ --smart-case
endif
" }}}
" {{{1 spelling
setglobal spelllang=en_us
setglobal spellfile=~/.vim/spell/en.utf-8.add
let g:spellfile_URL = 'http://ftp.vim.org/vim/runtime/spell'
" }}}
