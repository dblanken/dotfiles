" vim: nowrap fdm=marker

let mapleader="\<Space>"

" {{{1 Settings
unlet! skip_defaults_vim
source $VIMRUNTIME/defaults.vim

" My attempt to get as close to a nvim setup for vim as I can
" Referenced :h defaults in neovim
" set smarttab
set autoindent
set autoread
set background=dark
set belloff=all
set cscopeverbose
set directory=$HOME/.local/share/vim/swap//
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
set colorcolumn=81
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
" {{{1 vim-polyglot
" States that it must be set before loading the plugin
let g:polyglot_disabled = ["ruby", "mason"]
" }}}
" {{{1 Plugins
" Note: { 'for': [] } makes it an optional plugin
call plug#begin('~/.local/share/vim/plugins')

Plug 'chriskempson/base16-vim'
Plug 'christoomey/vim-tmux-navigator'
Plug 'godlygeek/tabular'
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
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-fireplace'
Plug 'tpope/vim-flagship' " Using airline right now, but who knows
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-git'
Plug 'tpope/vim-jdaddy'
Plug 'tpope/vim-markdown'
Plug 'tpope/vim-projectionist'
Plug 'tpope/vim-ragtag'
Plug 'tpope/vim-rails'
Plug 'tpope/vim-rake'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-rhubarb'
Plug 'tpope/vim-salve'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-speeddating'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-tbone'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-vinegar'
Plug 'tpope/vim-vividchalk'
Plug 'vim-pandoc/vim-pandoc'
Plug 'vim-test/vim-test'
Plug 'vuciv/vim-bujo'
Plug 'wincent/loupe'
Plug 'wincent/terminus'
Plug 'sheerun/vim-polyglot'
Plug 'vim-airline/vim-airline', { 'for': [] }
Plug 'vim-airline/vim-airline-themes', { 'for': [] }
Plug 'AndrewRadev/splitjoin.vim'
Plug 'airblade/vim-gitgutter'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'editorconfig/editorconfig-vim'
Plug 'kana/vim-textobj-user'
Plug 'kana/vim-textobj-entire'
Plug 'kana/vim-textobj-indent'
Plug 'kana/vim-textobj-syntax'
Plug 'kana/vim-textobj-line'
Plug 'nelstrom/vim-textobj-rubyblock'
Plug 'Julian/vim-textobj-variable-segment'
Plug 'bkad/CamelCaseMotion'
Plug 'b4winckler/vim-angry'
Plug 'saihoooooooo/vim-textobj-space'

Plug 'dense-analysis/ale'
Plug 'jiangmiao/auto-pairs'
Plug 'tpope/vim-endwise'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim', { 'do': { -> fzf#install()  } }
Plug 'neoclide/coc.nvim', {'branch': 'release', 'for': []}

Plug 'gruvbox-community/gruvbox'

call plug#end()
" }}}

" {{{1 ale
if has_key(plugs, 'ale')
  function! OnAttachAle() abort
    nmap <buffer><silent> [W <Plug>(ale_first)<Plug>(ale_detail)
    nmap <buffer><silent> [w <Plug>(ale_previous)<Plug>(ale_detail)
    nmap <buffer><silent> ]W <Plug>(ale_last)<Plug>(ale_detail)
    nmap <buffer><silent> ]w <Plug>(ale_next)<Plug>(ale_detail)

    nmap <buffer><silent> [D <Plug>(ale_first)<Plug>(ale_detail)
    nmap <buffer><silent> [d <Plug>(ale_previous)<Plug>(ale_detail)
    nmap <buffer><silent> ]D <Plug>(ale_last)<Plug>(ale_detail)
    nmap <buffer><silent> ]d <Plug>(ale_next)<Plug>(ale_detail)

    nmap <buffer><silent> gd <Plug>(ale_go_to_definition)
    nmap <buffer><silent> gr <Plug>(ale_find_references)
    nmap <buffer><silent> <Leader>rn <Plug>(ale_rename)
    nmap <buffer><silent> <Leader>f <Plug>(ale_fix)
    nmap <buffer><silent> <Leader>e <Plug>(ale_detail)

    setlocal omnifunc=ale#completion#OmniFunc
  endfunction

  augroup ales
    autocmd!
    autocmd FileType ruby,eruby call OnAttachAle()
  augroup END

  " Always show sign column
  let g:ale_sign_column_always = 1

  " Set to show which linter says there is an issue
  let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
  let g:ale_sign_error = '✖'
  let g:ale_sign_info = 'ℹ'
  let g:ale_sign_warning = '⚠'

  " Use popup windows
  let g:ale_set_balloons = 1
  let g:ale_hover_to_preview = 1
  let g:ale_hover_cursor = 1
  let g:ale_hover_to_floating_preview = 1
  let g:ale_hover_to_detail = 1
  let g:ale_floating_preview = 1

  let g:ale_linters = {
        \ "ruby": [ "brakeman", "rails_best_practices", "reek", "solargraph" ]
        \ }
  let g:ale_fixers = {
        \ "*": [ "remove_trailing_lines" ],
        \ "ruby": [ "rubocop" ]
        \ }
  let g:ale_fix_on_save = 1

  function! LinterStatus() abort
    let l:counts = ale#statusline#Count(bufnr(''))

    let l:all_errors = l:counts.error + l:counts.style_error
    let l:all_non_errors = l:counts.total - l:all_errors

    return l:counts.total == 0 ? 'OK' : printf(
          \   '%dW %dE',
          \   all_non_errors,
          \   all_errors
          \)
  endfunction

  if has_key(plugs, 'vim-flagship')
    augroup ale_flagship
      autocmd!
      autocmd User Flags call Hoist("buffer", "LinterStatus")
    augroup END
  endif

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
  let g:ale_completion_enabled = 1
endif
" }}}
" {{{1 autogroups
function! TrimWhitespace()
  let l:save = winsaveview()
  keeppatterns %s/\s\+$//e
  call winrestview(l:save)
endfunction

augroup misc
  autocmd!

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
" }}}
" {{{1 fzf config
let g:fzf_layout = { 'window': { 'width': 0.8, 'height': 0.8 } }

let $FZF_DEFAULT_OPTS='--reverse --preview "bat --style=numbers --color=always --line-range :500 {}"'
nnoremap <C-p> :Files<CR>
nnoremap <Leader>ez :Files $HOME/code/dotfiles<CR>

augroup fzf_overrides
  autocmd!
  " Allow Esc to exit fzf
  autocmd FileType fzf tnoremap <buffer> <Esc> <Esc><Esc>
augroup END
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

" Delete what you have highlighted to the void register and paste what you
" wanted.  It does not replace what you've copied previously.  Actual delete.
vnoremap <Leader>p "_dP
" }}}
" {{{1 netrw config
let g:netrw_browse_split = 2
let g:netrw_banner = 0
let g:netrw_winsize = 25
" }}}
" {{{1 rg/grep
if executable('rg')
  set grepprg=rg\ --no-heading\ --vimgrep\ --smart-case
endif
" }}}
" {{{1 spelling
if has('spell')
  setglobal spelllang=en_us
  setglobal spellfile=~/.vim/spell/en.utf-8.add
  let g:spellfile_URL = 'http://ftp.vim.org/vim/runtime/spell'
  autocmd FileType gitcommit setlocal spell
  autocmd FileType help if &buftype ==# 'help' | setlocal nospell | endif
endif

" }}}
" {{{1 vim-fugitive
if has_key(plugs, 'vim-fugitive')
  nnoremap <Leader>gd :Gvdiffsplit!<CR>
  nnoremap gdh :diffget //2<CR>
  nnoremap gdl :diffget //3<CR>
endif
" }}}
" {{{1 vim-markdown
let g:markdown_fenced_languages = ['ruby', 'html', 'javascript', 'css', 'bash=sh', 'sh']
" }}}
" {{{1 vim-ragtag
let g:ragtag_global_maps = 1
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
" {{{1 vim-rhubarb
let g:github_enterprise_urls = ['https://github.iu.edu']
" }}}
" {{{1 vim-surround
let b:surround_{char2nr('e')} = "\r\n}"
let g:surround_{char2nr('-')} = "<% \r %>"
let g:surround_{char2nr('=')} = "<%= \r %>"
let g:surround_{char2nr('8')} = "/* \r */"
let g:surround_{char2nr('s')} = " \r"
let g:surround_{char2nr('^')} = "/^\r$/"
let g:surround_indent = 1
" }}}
" {{{1 vim-test config
nmap <silent> <leader>t :TestNearest<CR>
nmap <silent> <leader>T :TestFile<CR>
nmap <silent> <leader>a :TestSuite<CR>
nmap <silent> <leader>l :TestLast<CR>
let test#strategy = 'dispatch'
" }}}
" {{{1 camelCaseMotion
let g:camelcasemotion_key = '<leader>'
" }}}
" {{{1 transparency
augroup coloroverride
  au!
  autocmd ColorScheme * hi Normal ctermbg=NONE guibg=NONE
augroup END
" }}}
" {{{1 base16-vim
" if has_key(plugs, 'base16-vim')
"   if filereadable(expand("~/.vimrc_background"))
"     let base16colorspace=256
"     silent! source ~/.vimrc_background
"   endif
" endif
colorscheme gruvbox
" }}}
