set cmdheight=2                   " Better display for messages
if has('unnamedplus')
  set clipboard=unnamedplus
else
  set clipboard=unnamed
endif
set backupcopy=yes                " overwrite files to update, instead of renaming + rewriting
set colorcolumn=80
set completeopt=menu,menuone,noselect
set cursorline                    " Highlight my current line
set diffopt+=vertical             " Diff vertically unless specified
set encoding=utf-8
set expandtab                     " Convert tabs to spaces
set fileencoding=utf-8
set fileencodings=utf-8
set foldmethod=marker             " Use markers for folding
set formatoptions-=cro            " don't continue comments on next line
set hidden                        " Let buffers leave windows without saving
set hlsearch
set ignorecase                    " Ignore case on searching
set incsearch
set list                          " Show hidden characters
set list listchars=tab:»·,trail:· " Show tabs and trailing whitespace
set mouse=a                       " Allow the mouse (blasphemy)
set nobackup                      " Can conflict with LSP servers
set nowritebackup                 " Can conflict with LSP servers
set number relativenumber         " Must have line numbers
set scrolljump=-15                " j can only go 15% lines from the bottom
set scrolloff=8
set shiftwidth=2                  " Shifting lines 2 spaces
set shortmess+=c                  " don't give |ins-completion-menu| messages.
set showmatch                     " Show matching brackets.
set sidescrolloff=8
set signcolumn=yes                " always show signcolumns
set smartcase                     " Override ignore case if I use capital letters
set softtabstop=-1                " Use shiftwidth's setting
set spellcapcheck=                " don't check for capital letters at start of sentence
set switchbuf=usetab              " try to reuse windows/tabs when switching buffers
set tabstop=2                     " Tab produces 2 spaces
set timeoutlen=500                " Don't wait so long for next key
set ttyfast
set undofile                      " Persist undos
set updatetime=300                " For diagnostic messages

set nobackup                      " don't make backups before writing
set nowritebackup                 " don't keep backups after writing

if !empty($SUDO_USER) && $USER !=# $SUDO_USER
  setglobal viminfo=
  setglobal directory-=~/tmp
  setglobal backupdir-=~/tmp
else
  if !empty($XDG_DATA_HOME)
    let s:data_home = substitute($XDG_DATA_HOME, '/$', '', '') . '/'.g:vim_name.'/'
  elseif has('win32')
    let s:data_home = expand('~/AppData/Local/'.g:vim_name.'/')
  else
    let s:data_home = expand('~/.local/share/'.g:vim_name.'/')
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
    execute 'set ' . s:viminfo . "='0,<0,f0,n~/.cache/".g:vim_name."/" . s:viminfo
    if !empty(glob('~/.cache/'.g:vim_name.'/' . s:viminfo))
      if !filereadable(expand('~/.cache/'.g:vim_name.'/' . s:viminfo))
        echoerr 'warning: ~/.cache/'.g:vim_name.'/' . s:viminfo . ' exists but is not readable'
      endif
    endif
  endif
endif
