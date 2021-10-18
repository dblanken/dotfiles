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
set directory=$HOME/.local/share/nvim/swap//
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
set undodir=$HOME/.local/share/nvim/undo//
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

