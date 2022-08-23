" {{{1 Vim defaults
if !has('nvim')
  unlet! skip_defaults_vim
  source $VIMRUNTIME/defaults.vim
endif

" {{{1 vim-plug bootstrap
let vimplug_exists=expand('~/.vim/autoload/plug.vim')
if has('win32')&&!has('win64')
  let curl_exists=expand('C:\Windows\Sysnative\curl.exe')
else
  let curl_exists=expand('curl')
endif

if !filereadable(vimplug_exists)
  if !executable(curl_exists)
    echoerr "You have to install curl or first install vim-plug yourself!"
    execute "q!"
  endif
  echo "Installing Vim-Plug..."
  echo ""
  silent exec "!"curl_exists" -fLo " . shellescape(vimplug_exists) . " --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
  let g:not_finish_vimplug = "yes"

  autocmd VimEnter * PlugInstall
endif

" {{{1 Mapleaders
let mapleader=' '
let maploadloeader='\\'

" {{{1 Options
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
elseif exists('+undodir') && !has('nvim-0.5')
  if !empty($XDG_DATA_HOME)
    let s:data_home = substitute($XDG_DATA_HOME, '/$', '', '') . '/vim/'
  elseif has('win32')
    let s:data_home = expand('~/AppData/Local/vim/')
  else
    let s:data_home = expand('~/.local/share/vim/')
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
    execute 'set ' . s:viminfo . "='0,<0,f0,n~/.cache/vim/" . s:viminfo
    if !empty(glob('~/.cache/vim/' . s:viminfo))
      if !filereadable(expand('~/.cache/vim/' . s:viminfo))
        echoerr 'warning: ~/.cache/vim/' . s:viminfo . ' exists but is not readable'
      endif
    endif
  endif
endif

" {{{1 Common remaps
nnoremap Q @q
nnoremap <Leader>= migg=G`i
nnoremap Y y$
nnoremap <Leader>h :nohl<CR>
nnoremap <Leader><Leader> <C-^>
nnoremap / /\v
vnoremap p "_dp
vnoremap p "_dP
vnoremap / /\v
tnoremap <Esc> <C-\><C-n>
" Emacs-like beginning and end of line.
imap <C-e> <C-o>$
imap <C-a> <C-o>^

" {{{1 Common autocommands
" Removes all whitespace from the buffer
function! TrimWhitespace() abort
  let l:save = winsaveview()
  keeppatterns %s/\s\+$//e
  call winrestview(l:save)
endfunction

augroup vimStartup
  autocmd!

  " When resized, resize the windows inside
  autocmd VimResized * execute "normal! \<c-w>="

  " Nest source on changes to vimrc
  autocmd BufWritePost .vimrc,init.vim,init.lua,vimrc nested source %

  autocmd BufEnter,BufNewFile .zshrc,zshrc setlocal filetype=zsh

  autocmd BufWritePre * :call TrimWhitespace()

  " When editing a file, always jump to the last known cursor position.
  " Don't do it for commit messages, when the position is invalid, or when
  " inside an event handler (happens when dropping a file on gvim).
  "
  autocmd BufReadPost *
        \ if &ft != 'gitcommit' && line("'\"") > 0 && line("'\"") <= line("$") |
        \   exe "normal g`\"" |
        \ endif
augroup end

" {{{1 Grep

" AG: ag\ --nogroup\ --nocolor\ --column
" RG: rg\ --no-heading\ --vimgrep\ --smart-case
set grepprg=ag\ --nogroup\ --nocolor\ --column

" {{{1 vim-ruby
let g:ruby_path = '~/.asdf/shims'
" Use old regex engine for ruby
set re=1
let g:rubycomplete_buffer_loading = 1
let g:rubycomplete_classes_in_global = 1
let g:rubycomplete_rails = 1

" {{{1 Plugin syncing
set runtimepath^=~/.local/share/vim runtimepath+=~/.local/share/vim/after
let &packpath = &runtimepath
call plug#begin(s:data_home .. 'plugged')

Plug 'vim-ruby/vim-ruby'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-bundler'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-projectionist'
Plug 'tpope/vim-rake'
Plug 'tpope/vim-rails'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-rhubarb'
if !has('nvim')
  Plug 'tpope/vim-sensible'
endif
Plug 'tpope/vim-scriptease'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-speeddating'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-vinegar'

Plug 'MaxMEllon/vim-jsx-pretty'
Plug 'andrewradev/splitjoin.vim'
Plug 'chriskempson/base16-vim'
Plug 'christoomey/vim-tmux-navigator'
Plug 'ludovicchabant/vim-gutentags'
Plug 'mattn/emmet-vim'
Plug 'morhetz/gruvbox'
Plug 'thoughtbot/vim-rspec'
Plug 'vim-pandoc/vim-pandoc'
Plug 'vim-test/vim-test'
Plug 'vimwiki/vimwiki'

call plug#end()

" {{{1 ALE
if &rtp =~ 'ale'
  nnoremap ]d <Plug>(ale_next)
  nnoremap [d <Plug>(ale_previous)
  if &rtp =~ 'coc.nvim'
    let g:ale_disable_lsp = 1
  endif
  let g:ale_echo_msg_format = '[%linter%] %code: %%s'
  let g:ale_fix_on_save = 1
  let g:ale_linters = {
        \ 'ruby': ['reek', 'brakeman', 'cspell', 'debride'],
        \ 'javascript': ['tsserver']
        \ }
  let g:ale_fixers = {
        \ '*': ['remove_trailing_lines'],
        \ 'ruby': ['rubocop'],
        \ 'javascript': ['eslint']
        \ }

  function! LinterStatus() abort
    let l:counts = ale#statusline#Count(bufnr(''))

    let l:all_errors = l:counts.error + l:counts.style_error
    let l:all_non_errors = l:counts.total - l:all_errors

    return l:counts.total == 0 ? 'OK' : printf(
          \ '%dW %dE',
          \ all_non_errors,
          \ all_errors
          \)
  endfunction

  function! CreateLSPBufferMappings() abort
    "   nnoremap <buffer> <silent> gd <Plug>(ale_go_to_definition)
    "   nnoremap <buffer> <silent> <Leader>e <Plug>(ale_hover)
    "   nnoremap <buffer> <silent> <Leader>rn :ALERename<CR>
    nnoremap <buffer> <silent> ]d <Plug>(ale_next)
    nnoremap <buffer> <silent> [d <Plug>(ale_previous)
    nnoremap <buffer> <silent> <Leader>= <Plug>(ale_fix)
    "   nnoremap <buffer> <silent> gr <Plug>(ale_find_references)
  endfunction

  let s:ale_running = 0
  augroup AleFlagship
    autocmd!
    autocmd User Flags call Hoist("buffer", "LinterStatus")
    autocmd User ALELSPStarted call CreateLSPBufferMappings()
  augroup END
endif

" {{{1 vim-test
if &rtp =~ 'vim-test'
  nmap <silent> <leader>t :TestNearest<CR>
  nmap <silent> <leader>T :TestFile<CR>
  nmap <silent> <leader>a :TestSuite<CR>
  nmap <silent> <leader>l :TestLast<CR>
  let g:test#strategy = 'dispatch'
endif

" {{{1 Vimwiki
if &rtp =~ 'vimwiki'
  let g:vimwiki_list = [{'path': '~/vimwiki', 'syntax': 'markdown', 'ext': '.md', 'diary_rel_path': '../.diary'},
        \ {'path': '~/code/vimwiki', 'syntax': 'markdown', 'ext': '.md'}]
endif

" {{{1 Ruby
" Make ?s part of words
autocmd FileType ruby,eruby,yaml setlocal iskeyword+=?

" {{{1 [coc.nvim]
if &rtp =~ 'coc.nvim'
  " Use tab for trigger completion with characters ahead and navigate.
  " Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
  " coc#_select_confirm() :
  " \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
  inoremap <silent><expr> <TAB>
        \ coc#pum#visible() ? coc#pum#next(1) :
        \ <SID>check_back_space() ? "\<TAB>" :
        \ coc#refresh()
  inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

  function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~# '\s'
  endfunction

  " Load all of the extensions I want
  let g:coc_global_extensions = ['coc-solargraph', 'coc-snippets', 'coc-marketplace', 'coc-css', 'coc-html', 'coc-json', 'coc-lists', 'coc-yaml', 'coc-pairs', 'coc-yank', 'coc-highlight']

  " For coc-highlight
  " Highlight symbol under cursor on CursorHold
  autocmd CursorHold * silent call CocActionAsync('highlight')

  " Set next placeholder keybinding
  let g:coc_snippet_next = '<tab>'

  " Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
  " Coc only does snippet and additional edit on confirm.
  inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
        \: "<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

  " Remap keys for gotos
  nmap <silent> gd <Plug>(coc-definition)
  nmap <silent> gy <Plug>(coc-type-definition)
  nmap <silent> gi <Plug>(coc-implementation)
  nmap <silent> gr <Plug>(coc-references)

  " Use K to show documentation in preview window
  nnoremap <silent> K :call <SID>show_documentation()<CR>

  function! s:show_documentation()
    " If we are in a vim or vim help, use help command
    if (index(['vim','help'], &filetype) >= 0)
      execute 'h '.expand('<cword>')
    else
      call CocAction('doHover')
    endif
  endfunction

  " Remap for rename current word
  nmap <leader>rn <Plug>(coc-rename)

  " Remap for format selected region
  xmap <leader>f  <Plug>(coc-format-selected)
  nmap <leader>f  <Plug>(coc-format-selected)

  augroup cocFormatting
    autocmd!
    " Setup formatexpr specified filetype(s).
    autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
    " autocmd FileType ruby,eruby,erb setl formatexpr=CocAction('formatSelected')
    " Update signature help on jump placeholder
    autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
  augroup end

  " Remap for do codeAction of selected region, ex: `<leader>caap` for current paragraph
  xmap <leader>ca  <Plug>(coc-codeaction-selected)
  nmap <leader>ca  <Plug>(coc-codeaction-selected)

  " Remap for do codeAction of current line
  nmap <leader>ac  <Plug>(coc-codeaction)
  " Fix autofix problem of current line
  nmap <leader>qf  <Plug>(coc-fix-current)

  " Use <tab> for select selections ranges, needs server support, like: coc-tsserver, coc-python
  nmap <silent> <TAB> <Plug>(coc-range-select)
  xmap <silent> <TAB> <Plug>(coc-range-select)
  xmap <silent> <S-TAB> <Plug>(coc-range-select-backword)

  " Use `:Format` to format current buffer
  command! -nargs=0 Format :call CocAction('format')

  " Use `:Fold` to fold current buffer
  command! -nargs=? Fold :call     CocAction('fold', <f-args>)

  " use `:OR` for organize import of current buffer
  command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

  " Add status line support, for integration with other plugin, checkout `:h coc-status`
  " set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}\

  " Using CocList
  " Show all diagnostics
  nnoremap <silent> <LocalLeader>a  :<C-u>CocList diagnostics<cr>
  " Manage extensions
  nnoremap <silent> <LocalLeader>e  :<C-u>CocList extensions<cr>
  " Show commands
  nnoremap <silent> <LocalLeader>c  :<C-u>CocList commands<cr>
  " Find symbol of current document
  nnoremap <silent> <LocalLeader>o  :<C-u>CocList outline<cr>
  " Search workLocalLeader symbols
  nnoremap <silent> <LocalLeader>s  :<C-u>CocList -I symbols<cr>
  " Do default action for next item.
  nnoremap <silent> <LocalLeader>j  :<C-u>CocNext<CR>
  " Do default action for previous item.
  nnoremap <silent> <LocalLeader>k  :<C-u>CocPrev<CR>
  " Resume latest coc list
  nnoremap <silent> <LocalLeader>p  :<C-u>CocListResume<CR>

  " Fuzzy file searching with CTRL-P
  nnoremap <silent> <C-p> :<C-u>CocList files<CR>

  " Grep current word
  nnoremap <silent> <leader>wo :exe 'CocList -I --normal --input='.expand('<cword>').' grep'<CR>

  let g:airline#extensions#tabline#enabled = 1
endif

" {{{1 [vim-rails]
" Since you cannot create an alternate file, we will try to make our own.
command! Coverage :Dispatch COVERAGE=true bundle exec rails test
command! Rubycritic :Dispatch! bundle exec rubycritic
command! Critic :Dispatch! critic
" }}}
" {{{1 Rhubarb
if &rtp =~ 'vim-rhubarb'
  let g:github_enterprise_urls = ['https://github.iu.edu']
endif
" {{{1 Colorscheme
let g:gruvbox_italic = 1
set background=dark
" colorscheme gruvbox
" colorscheme slate

if filereadable(expand("~/.vimrc_background"))
  let base16colorspace=256
  source ~/.vimrc_background
endif
