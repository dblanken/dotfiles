" vim: nowrap fdm=marker

let mapleader="\<Space>"

" {{{1 Short circuits
if has('nvim')
  if has('mac')
    if isdirectory(glob('~/.asdf'))
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
endif
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
" {{{1 Plugins
call plug#begin()

" Essentials
Plug 'christoomey/vim-tmux-navigator'
Plug 'tpope/vim-bundler'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-projectionist'
Plug 'tpope/vim-ragtag'
Plug 'tpope/vim-rails'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'vim-test/vim-test'
Plug 'jiangmiao/auto-pairs'
Plug 'chriskempson/base16-vim'

" Niceties
Plug 'AndrewRadev/sideways.vim'
Plug 'AndrewRadev/splitjoin.vim'
Plug 'godlygeek/tabular'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-afterimage'
Plug 'tpope/vim-apathy'
Plug 'tpope/vim-characterize'
Plug 'tpope/vim-cucumber'
Plug 'tpope/vim-dadbod'
Plug 'tpope/vim-dotenv'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-fireplace'
Plug 'tpope/vim-flagship'
Plug 'tpope/vim-git'
Plug 'tpope/vim-jdaddy'
Plug 'tpope/vim-markdown'
Plug 'tpope/vim-rake'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-rhubarb'
Plug 'tpope/vim-salve'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-speeddating'
Plug 'tpope/vim-tbone'
Plug 'tpope/vim-vinegar'
Plug 'tpope/vim-vividchalk'
Plug 'vim-pandoc/vim-pandoc'
Plug 'vuciv/vim-bujo'
Plug 'wincent/loupe'
Plug 'wincent/terminus'

if has('nvim')
  Plug 'neovim/nvim-lspconfig'
  Plug 'nvim-lua/popup.nvim'
  Plug 'nvim-lua/plenary.nvim'
  Plug 'nvim-telescope/telescope.nvim'
  Plug 'nvim-telescope/telescope-fzy-native.nvim'
  Plug 'kyazdani42/nvim-web-devicons'
  Plug 'nvim-lua/lsp-status.nvim'
  Plug 'wincent/corpus'
  Plug 'Shougo/deoplete.nvim', {'do': ':UpdateRemotePlugins'}
  Plug 'deoplete-plugins/deoplete-lsp'
  Plug 'SirVer/Ultisnips'
  Plug 'honza/vim-snippets'
else
  Plug 'dense-analysis/ale'
  Plug 'junegunn/fzf'
  Plug 'junegunn/fzf.vim', { 'do': { -> fzf#install()  } }
endif

call plug#end()
" }}}

" {{{1 ale
if !has('nvim')
  nmap <silent> [W <Plug>(ale_first)
  nmap <silent> [w <Plug>(ale_previous)
  nmap <silent> ]W <Plug>(ale_last)
  nmap <silent> ]w <Plug>(ale_next)

  " Always show sign column
  let g:ale_sign_column_always = 1

  " Set to show which linter says there is an issue
  let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
  let g:ale_sign_error = '✖'
  let g:ale_sign_info = 'ℹ'
  let g:ale_sign_warning = '⚠'

  let g:ale_set_balloons = 1
  let g:ale_hover_to_preview = 1
  let g:ale_hover_cursor = 1

  let g:ale_linters = {
        \ "ruby": [ "brakeman", "rails_best_practices", "reek", "solargraph" ]
        \ }
  let g:ale_fixers = {
        \ "*": [ "remove_trailing_lines" ],
        \ "ruby": [ "standardrb" ]
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

  augroup ale_flagship
    autocmd!
    autocmd User Flags call Hoist("buffer", "LinterStatus")
  augroup END

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
  " let g:ale_completion_enabled = 1
  let g:ale_hover_to_floating_preview = 1
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
  " autocmd BufWritePost .vimrc,init.vim,vimrc nested source %

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

" Only if I have set it to be transparent
if exists("g:transparency")
  augroup dblanken_transparency
    autocmd!
    autocmd ColorScheme * hi Normal guibg=NONE ctermbg=NONE
  augroup END
endif
" }}}
" {{{1 base16-vim
function! TransparentColorscheme() abort
  highlight Normal ctermbg=NONE guibg=NONE
  highlight LineNr ctermbg=NONE guibg=NONE
  highlight Folded ctermbg=NONE guibg=NONE
  highlight NonText ctermbg=NONE guibg=NONE
  highlight SpecialKey ctermbg=NONE guibg=NONE
  highlight VertSplit ctermbg=NONE guibg=NONE
  highlight SignColumn ctermbg=NONE guibg=NONE
  highlight Statusline ctermbg=NONE guibg=NONE
  highlight SpellBad ctermbg=NONE guibg=NONE
  highlight error ctermbg=NONE guibg=NONE
  highlight CursorLineNr ctermbg=NONE guibg=NONE
  highlight clear ALEErrorSign
  highlight clear ALEWarningSign
endfunction

augroup transparent_background
  autocmd!
  autocmd ColorScheme * :call TransparentColorscheme()<CR>
augroup END

if filereadable(expand("~/.vimrc_background"))
  let base16colorspace=256
  silent! source ~/.vimrc_background
endif
" }}}
" {{{1 corpus
if has('nvim')
  lua <<
    CorpusDirectories = {
      ['~/Documents/wiki'] = {
          autocommit = true,
          autoreference = 1,
          autotitle = 1,
          base = './',
          transform = 'local',
      },
      ['~/OneDrive - Indiana University/wiki'] = {
          autocommit = true,
          autoreference = 1,
          autotitle = 1,
          base = './',
          transform = 'local',
      },
    }
.
endif
" }}}
" {{{1 deoplete
if has('nvim')
  let g:deoplete#enable_at_startup = 0
  let g:deoplete#lsp#use_icons_for_candidates = v:true
  augroup deoplete_lazy_load
    autocmd!
    autocmd InsertEnter * call deoplete#enable()
  augroup END
endif
" }}}
" {{{1 fzf config
if !has('nvim')
  let g:fzf_layout = { 'window': { 'width': 0.8, 'height': 0.8 } }

  let $FZF_DEFAULT_OPTS='--reverse --preview "bat --style=numbers --color=always --line-range :500 {}"'
  nnoremap <C-p> :Files<CR>
  nnoremap <Leader>ez :Files $HOME/code/dotfiles<CR>

  augroup fzf_overrides
    autocmd!
    " Allow Esc to exit fzf
    autocmd FileType fzf tnoremap <buffer> <Esc> <Esc><Esc>
  augroup END
endif
" }}}
" {{{1 lsp_status
if has('nvim')
lua <<EOF
  require('lsp-status').register_progress()
EOF
  function! LspStatus() abort
    if luaeval('#vim.lsp.buf_get_clients() > 0')
      return luaeval("require('lsp-status').status()")
    endif

    return ''
  endfunction
  autocmd User Flags call Hoist("buffer", "LspStatus")
endif
" }}}
" {{{1 Mappings
imap jj <esc>
nnoremap Q @q
nnoremap <Leader>= migg=G`i
nnoremap Y y$
nnoremap <Leader>g :grep!<Space>
if exists(':tnoremap')
  tnoremap <Esc> <C-\><C-n>
endif
nnoremap <Leader>z [s1z=

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
" {{{1 nvim-lsp
if has('nvim')
lua << EOF
local nvim_lsp = require('lspconfig')
local on_attach = function(client, bufnr)
  local has_lspstatus, _ = pcall(require, 'lsp-status')
  if has_lspstatus then
    require('lsp-status').on_attach(client)
  end
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }
  buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<C-s>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  --buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  --buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  --buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '[w', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']w', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)

  -- Set some keybinds conditional on server capabilities
  if client.resolved_capabilities.document_formatting then
    buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
  end
  if client.resolved_capabilities.document_range_formatting then
    buf_set_keymap("v", "<space>f", "<cmd>lua vim.lsp.buf.range_formatting()<CR>", opts)
  end

  -- Set autocommands conditional on server_capabilities
  if client.resolved_capabilities.document_highlight then
    vim.api.nvim_exec([[
      hi LspReferenceRead cterm=bold ctermbg=red guibg=LightYellow
      hi LspReferenceText cterm=bold ctermbg=red guibg=LightYellow
      hi LspReferenceWrite cterm=bold ctermbg=red guibg=LightYellow
      augroup lsp_document_highlight
        autocmd! * <buffer>
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      augroup END
    ]], false)
  end
end

-- Use a loop to conveniently both setup defined servers
-- and map buffer local keybindings when the language server attaches
local servers = { "solargraph", "tsserver", "vimls", "bashls", "cssls", "dockerls", "html", "jsonls", "yamlls" }
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup { on_attach = on_attach }
end

local system_name
if vim.fn.has("mac") == 1 then
  system_name = "macOS"
elseif vim.fn.has("unix") == 1 then
  system_name = "Linux"
elseif vim.fn.has('win32') == 1 then
  system_name = "Windows"
else
  print("Unsupported system for sumneko")
end

-- set the path to the sumneko installation; if you previously installed via the now deprecated :LspInstall, use
-- local sumneko_root_path = vim.fn.stdpath('cache')..'/lspconfig/sumneko_lua/lua-language-server'
local sumneko_root_path = '/Users/dblanken/code/lua-language-server'
local sumneko_binary = sumneko_root_path.."/bin/"..system_name.."/lua-language-server"

nvim_lsp.sumneko_lua.setup {
  on_attach = on_attach,
  cmd = {sumneko_binary, "-E", sumneko_root_path .. "/main.lua"};
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = 'LuaJIT',
        -- Setup your lua path
        path = vim.split(package.path, ';'),
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = {'vim'},
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = {
          [vim.fn.expand('$VIMRUNTIME/lua')] = true,
          [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true,
        },
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = {
        enable = false,
      },
    },
  },
}
EOF
endif
" }}}
" {{{1 sideways.vim
nnoremap <Left> :SidewaysLeft<CR>
nnoremap <Right> :SidewaysRight<CR>

omap aa <Plug>SidewaysArgumentTextobjA
xmap aa <Plug>SidewaysArgumentTextobjA
omap ia <Plug>SidewaysArgumentTextobjI
xmap ia <Plug>SidewaysArgumentTextobjI

nmap <leader>si <Plug>SidewaysArgumentInsertBefore
nmap <leader>sa <Plug>SidewaysArgumentAppendAfter
nmap <leader>sI <Plug>SidewaysArgumentInsertFirst
nmap <leader>sA <Plug>SidewaysArgumentAppendLast
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
  autocmd FileType gitcommit,vimwiki,markdown setlocal spell
  autocmd FileType help if &buftype ==# 'help' | setlocal nospell | endif

  inoremap <silent> <C-s> <C-x><C-k>
endif

" }}}
" {{{1 telescope.nvim
if has('nvim')
lua <<EOF
  function find_dotfiles()
    require('telescope.builtin').find_files {
      prompt_title = '~ dotfiles ~',
      shorten_path = false,
      cwd = '~/code/dotfiles',
      layout_strategy = 'flex',
      layout_config = {
        horizontal = {
          preview_width = 120,
        },
        vertical = {
          preview_height = 0.75,
        },
      },
    }
  end
  require('telescope').setup {
    extensions = {
      fzy_native = {
        override_generic_sorter = false,
        override_file_sorter = true,
      }
    }
  }
  require('telescope').load_extension('fzy_native')
EOF

  nnoremap <C-p> <cmd>Telescope find_files<CR>
  nnoremap <Leader>ez <cmd>lua find_dotfiles()<CR>
endif
" }}}
" {{{1 ultisnips
" Must set trigger to no-op so we can handle it
let g:UltiSnipsExpandTrigger = "<nop>"
let g:UltiSnipsJumpForwardTrigger = "<Tab>"
let g:UltiSnipsJumpBackwardTrigger = "<S-Tab>"
" This is a variable that ultisnips will set when
" UltiSnips#ExpandSnippetOrJump() is called.
"   1 = It expanded or jumped
"   0 = It did nothing
let g:ulti_expand_or_jump_res = 0

" We define our own function that attemps the expand or jump, and if nothing
" happened, we return just a regular return.
function ExpandSnippetOrCarriageReturn()
   let snippet = UltiSnips#ExpandSnippetOrJump()
   if g:ulti_expand_or_jump_res > 0
      return snippet
   else
      return "\<CR>"
   endif
endfunction
" Make sure we don't allow endwise to do its own magic to CR.
let g:endwise_no_mappings = 1

" Obligitory check last character was space function
" get the column number before the current
" if col is zero, return 1 so we know it was a space
" if col is not zero, get the character before and return 1 if it's a space
function! s:check_last_char_was_space() abort
   let col = col('.') - 1
   return !col || getline('.')[col - 1]  =~ '\s'
endfunction

" If tab is pressed:
"    and pull up menu is visible:
"      C-n to traverse list
"    else
"      if we are at the beginning of the line or the character before is a space,
"      then allow a tab (no autocomplete needed)
"      if we are not at the beginning of the line and the character before is not
"        a space, attempt a deoplete completion.
inoremap <silent><expr> <TAB> pumvisible() ? "\<C-n>" : <SID>check_last_char_was_space() ? "\<TAB>" : deoplete#mappings#manual_complete()
inoremap <expr>   <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"| " Shift-Tab is previous entry if completion menu open.

" If CR is pressed:
"  if the pull up menu is visible
"    We attempt to expand the snippet or jump
"  otherwise
"    We CR with our own endwise call
inoremap <expr> <CR> pumvisible() ? "\<C-R>=ExpandSnippetOrCarriageReturn()\<CR>" : "\<CR>\<C-R>=EndwiseDiscretionary()\<CR>"
" }}}
" {{{ vim-bujo
" Remap these since surround attempts to take over experimental stuff
function! SetBujoMappings() abort
  nmap <buffer> <C-S> <Plug>BujoAddnormal
  imap <buffer> <C-S> <Plug>BujoAddinsert
  nmap <buffer> <C-Q> <Plug>BujoChecknormal
  imap <buffer> <C-Q> <Plug>BujoCheckinsert
endfunction
" }}}
" {{{1 vim-dispatch
  let g:dispatch_no_maps = 1
" }}}
" {{{1 vim-fugitive
nnoremap <Leader>gd :Gvdiffsplit!<CR>
nnoremap gdh :diffget //2<CR>
nnoremap gdl :diffget //3<CR>
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
