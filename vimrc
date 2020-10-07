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
  set autoindent
  set autoread
  set background=dark
  set belloff=all
  set cscopeverbose
  set directory=$HOME/.local/share/vim/swap//
  set encoding=utf8
  set fileencoding=utf8
  set formatoptions+=j
  set fillchars="vert:│,fold:·"
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
  set smarttab
  set tabpagemax=50
  set ttimeoutlen=50
  set viewoptions+=unix,slash
  set undodir=$HOME/.local/share/vim/undo
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
set clipboard=unnamedplus,unnamed
set colorcolumn=80
set expandtab
set hidden
set nobackup
set noerrorbells
set noswapfile
set number
set relativenumber
set shiftwidth=2
set smartcase
set softtabstop=2
set undofile
set formatoptions-=cro
set nowrap
set incsearch
set updatetime=50
" }}}

" " {{{1 Plugins
function! PackInit() abort
  packadd minpac

  call minpac#init()
  call minpac#add('k-takata/minpac', {'type': 'opt'})

  call minpac#add('tpope/vim-bundler')
  call minpac#add('tpope/vim-commentary')
  call minpac#add('tpope/vim-dispatch')
  call minpac#add('tpope/vim-endwise')
  call minpac#add('tpope/vim-eunuch')
  call minpac#add('tpope/vim-fugitive')
  call minpac#add('tpope/vim-projectionist')
  call minpac#add('tpope/vim-markdown')
  call minpac#add('tpope/vim-obsession')
  call minpac#add('tpope/vim-ragtag')
  call minpac#add('tpope/vim-rails')
  call minpac#add('tpope/vim-rake')
  call minpac#add('tpope/vim-repeat')
  call minpac#add('tpope/vim-surround')
  call minpac#add('dblanken/vim-unimpaired')
  call minpac#add('tpope/vim-vinegar')
  call minpac#add('vim-ruby/vim-ruby')
  call minpac#add('christoomey/vim-tmux-navigator')
  call minpac#add('AndrewRadev/splitjoin.vim')
  call minpac#add('vim-test/vim-test')
  call minpac#add('junegunn/fzf.vim')
  call minpac#add('gruvbox-community/gruvbox', {'type': 'opt'})
  call minpac#add('wincent/loupe')
  call minpac#add('wincent/terminus')
  call minpac#add('jiangmiao/auto-pairs')
  call minpac#add('mattn/emmet-vim')
  call minpac#add('dpelle/vim-LanguageTool', {'type': 'opt'})
  call minpac#add('vim-pandoc/vim-pandoc', {'type': 'opt'})
  call minpac#add('vim-pandoc/vim-pandoc-syntax', {'type': 'opt'})
  call minpac#add('joshdick/onedark.vim', {'type': 'opt'})
  call minpac#add('itchyny/lightline.vim')
  " call minpac#add('dense-analysis/ale')
  call minpac#add('oguzbilgic/sexy-railscasts-theme', {'type': 'opt'})

  call minpac#add('neovim/nvim-lspconfig', {'type': 'opt'})
  call minpac#add('nvim-lua/completion-nvim', {'type': 'opt'})
  call minpac#add('nvim-lua/diagnostic-nvim', {'type': 'opt'})
  call minpac#add('nvim-lua/lsp-status.nvim', {'type': 'opt'})

  call minpac#add('unblevable/quick-scope')
endfunction

command! PackUpdate source $MYVIMRC | call PackInit() | call minpac#update()
command! PackClean  source $MYVIMRC | call PackInit() | call minpac#clean()
command! PackStatus packadd minpac | call minpac#status()
command! PackInstall PackUpdate

set rtp+=/usr/local/opt/fzf
" set rtp+=$HOME/code/ale
" " }}}

" {{{1 nvim-lspconfig
if has('nvim')
lua <<EOF
vim.cmd('packadd nvim-lspconfig')
vim.cmd('packadd completion-nvim')
vim.cmd('packadd diagnostic-nvim')
vim.cmd('packadd lsp-status.nvim')

local nvim_lsp = require('nvim_lsp')
local on_attach_vim = function(client)
  require'completion'.on_attach(client)
  require'diagnostic'.on_attach(client)
  require'lsp-status'.on_attach(client)
end

nvim_lsp.vimls.setup{on_attach=on_attach_vim}
nvim_lsp.bashls.setup{on_attach=on_attach_vim}
nvim_lsp.html.setup{on_attach=on_attach_vim}
nvim_lsp.jsonls.setup{on_attach=on_attach_vim}
nvim_lsp.rls.setup{on_attach=on_attach_vim}
nvim_lsp.solargraph.setup{
  on_attach = on_attach_vim,
    settings = {
      solargraph = {
        diagnostics = true
    }
  }
}
nvim_lsp.sqlls.setup{on_attach=on_attach_vim}
nvim_lsp.yamlls.setup{on_attach=on_attach_vim}
EOF
endif

" Use <Tab> and <S-Tab> to navigate through popup menu
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" Set completeopt to have a better completion experience
set completeopt=menuone,noinsert,noselect

" Avoid showing message extra message when using completion
set shortmess+=c

let g:completion_matching_strategy_list = ['exact', 'substring', 'fuzzy']

let g:diagnostic_enable_virtual_text = 1

function! LspStatus() abort
  if luaeval('#vim.lsp.buf_get_clients() > 0')
    return luaeval("require('lsp-status').status()")
  endif
endfunction
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

" " {{{1 ALE
" nmap <silent> [W <Plug>(ale_first)
" nmap <silent> [w <Plug>(ale_previous)
" nmap <silent> ]w <Plug>(ale_next)
" nmap <silent> ]W <Plug>(ale_last)

" let g:ale_linters = {
"       \ 'ruby': ['standardrb', 'reek', 'brakeman', 'solargraph'],
"       \ 'javascript': ['tsserver', 'eslint'],
"       \ 'vim': ['vimls']
"       \ }

" let g:ale_fixers = {
"       \ '*': [ 'trim_whitespace', 'remove_trailing_lines'],
"       \ 'ruby': [ 'standardrb', 'trim_whitespace', 'remove_trailing_lines'],
"       \ 'javascript': [ 'eslint', 'trim_whitespace', 'remove_trailing_lines' ],
"       \ 'vim': ['remove_trailing_lines', 'trim_whitespace']
"       \ }

" " Always show sign column
" let g:ale_sign_column_always = 1
" " Fix on save
" let g:ale_fix_on_save = 1
" " Set to show which linter says there is an issue
" let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'

" " Allow go to definition
" nmap <silent> gd <Plug>(ale_go_to_definition)
" nmap <silent> gr <Plug>(ale_find_references)

" " Allow hovering in balloons
" let g:ale_set_balloons = 1

" let g:ale_javascript_tsserver_use_global = 1
" let g:ale_vim_vimls_use_global = 1

" let g:ale_sign_error='✖'
" let g:ale_sign_warning='⚠'
" let g:ale_sign_info='ℹ'
" let g:ale_sign_hint='➤'

" " Becuase we're using ALE with StandardRb, we need vim-ruby to change its
" " indentation style.
" " https://github.com/testdouble/standard/wiki/IDE:-vim
" let g:ruby_indent_assignment_style = 'variable'
" " Same for hanging elements
" let g:ruby_indent_hanging_elements = 0
" " Disable lsp server on ALE only
" let g:ale_disable_lsp = 1

" " Try ALE's completion from the LSP
" let g:ale_completion_enabled = 1

" if has('nvim')
"   " Allow floating windows in ale
"   let g:ale_floating_window = 1
" end
" " }}}

" {{{1 nvim-lsp
" if has('nvim')
"   let g:completion_matching_strategy_list = ['exact', 'substring', 'fuzzy']
"   let g:diagnostic_enable_virtual_text = 1

"   set completeopt=menuone,noinsert,noselect
"   set shortmess+=c

" lua <<EOF
" vim.cmd('packadd nvim-lspconfig')
" vim.cmd('packadd completion-nvim')
" -- Do not use yet since I have ale
" -- vim.cmd('packadd diagnostic-nvim')

" local on_attach_vim = function(client)
"   require'completion'.on_attach(client)
"   -- require'diagnostic'.on_attach(cllient)
" end

" require'nvim_lsp'.vimls.setup{on_attach=on_attach_vim}
" require'nvim_lsp'.yamlls.setup{on_attach=on_attach_vim}
" require'nvim_lsp'.solargraph.setup{on_attach=on_attach_vim}
" require'nvim_lsp'.jsonls.setup{on_attach=on_attach_vim}
" require'nvim_lsp'.html.setup{on_attach=on_attach_vim}
" require'nvim_lsp'.cssls.setup{on_attach=on_attach_vim}
" require'nvim_lsp'.bashls.setup{on_attach=on_attach_vim}
" EOF
" endif

" nnoremap <silent> gd    <cmd>lua vim.lsp.buf.declaration()<CR>
" nnoremap <silent> <c-]> <cmd>lua vim.lsp.buf.definition()<CR>
" nnoremap <silent> K     <cmd>lua vim.lsp.buf.hover()<CR>
" nnoremap <silent> gD    <cmd>lua vim.lsp.buf.implementation()<CR>
" nnoremap <silent> <c-k> <cmd>lua vim.lsp.buf.signature_help()<CR>
" nnoremap <silent> 1gD   <cmd>lua vim.lsp.buf.type_definition()<CR>
" nnoremap <silent> gr    <cmd>lua vim.lsp.buf.references()<CR>
" nnoremap <silent> g0    <cmd>lua vim.lsp.buf.document_symbol()<CR>
" nnoremap <silent> gW    <cmd>lua vim.lsp.buf.workspace_symbol()<CR>
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
" }}}

" {{{1 rg/grep
if executable('rg')
  set grepprg=rg\ --no-heading\ --vimgrep\ --smart-case
endif
" }}}

" {{{1 Colorscheme
let g:gruvbox_contrast_dark = 'hard'
let g:gruvbox_invert_selection='0'
if exists('+termguicolors')
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif
packadd! onedark.vim
let g:onedark_terminal_italics=1
colorscheme onedark
" {{{2 Lighline
function! LightlineFugitive() abort
  if exists('*FugitiveHead')
    let branch = FugitiveHead()
    return branch !=# '' ? ''.branch : ''
  endif
  return ''
endfunction

let g:lightline = {
      \ 'colorscheme': 'onedark',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'fugitive', 'gitbranch', 'readonly', 'filename', 'modified' ] ],
      \   'right': [
      \              [ 'lineinfo' ],
      \              [ 'percent'  ],
      \              [ 'fileformat', 'fileencoding', 'filetype' ],
      \              [ 'lsp' ]
      \   ]
      \ },
      \ 'component_function': {
      \   'fugitive': 'LightlineFugitive',
      \   'filename': 'FilenameForLightLine',
      \   'lsp': 'LspStatus'
      \ },
      \ 'separator': { 'left': '', 'right': '' },
      \ 'subseparator': { 'left': '', 'right': '' }
      \ }
function! FilenameForLightLine()
  return expand('%')
endfunction
" }}}
" }}}

" {{{1 Writing
function! Writer() abort
  setlocal spell spelllang=en_us
  setlocal formatoptions=t1
  setlocal textwidth=80
  setlocal noautoindent
  setlocal tabstop=5
  setlocal shiftwidth=5
  setlocal expandtab
  setlocal thesaurus=~/.thesaurus/thesaurus.txt
  packadd vim-LanguageTool
  packadd vim-pandoc-syntax
  packadd vim-pandoc
  runtime ftplugin/pandoc.vim
endfunction
command! WR call Writer()
" Since I use other java versions, point it to the adoptopenjdk8 java binary
let g:languagetool_jar='/usr/local/Cellar/languagetool/5.0/libexec/languagetool-commandline.jar'
let g:languagetool_cmd='/Library/Java/JavaVirtualMachines/adoptopenjdk-8.jdk/Contents/Home/bin/java -jar ' . g:languagetool_jar

" let g:pandoc#command#latex_engine="mactex"
let g:pandoc#modules#enabled = [
      \'yaml',
      \'completion',
      \'command',
      \'formatting',
      \'indent',
      \'menu',
      \'metadata',
      \'keyboard' ,
      \'toc',
      \'spell',
      \'hypertext']
" }}}
