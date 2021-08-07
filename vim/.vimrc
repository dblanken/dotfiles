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
    let g:perl_host_prog = expand('~/.asdf/shims/perl')
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
if has('nvim')
  set termguicolors
endif
" }}}
" {{{1 vim-polyglot
  " States that it must be set before loading the plugin
  let g:polyglot_disabled = ["ruby", "mason"]
" }}}
" {{{1 Plugins
function! PluginLocation() abort
  if has('nvim')
    return '~/.local/share/nvim/plugins'
  else
    return '~/.local/share/vim/plugins'
  endif
endfunction
let g:plugin_location = PluginLocation()
call plug#begin(g:plugin_location)

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
" Plug 'tpope/vim-flagship' " Using airline right now, but who knows
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
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
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

if has('nvim')
  Plug 'wincent/corpus'
  Plug 'neovim/nvim-lspconfig'
  Plug 'nvim-lua/popup.nvim'
  Plug 'nvim-lua/plenary.nvim'
  Plug 'nvim-telescope/telescope.nvim'
  Plug 'nvim-telescope/telescope-fzy-native.nvim'
  Plug 'kyazdani42/nvim-web-devicons'
  Plug 'nvim-lua/lsp-status.nvim'
  Plug 'glepnir/lspsaga.nvim'
  Plug 'hrsh7th/nvim-compe'
  Plug 'hrsh7th/vim-vsnip'
  Plug 'hrsh7th/vim-vsnip-integ'
  Plug 'rafamadriz/friendly-snippets'
  Plug 'windwp/nvim-autopairs'
  Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
  " Plug '~/code/nvim-treesitter', {'do': ':TSUpdate'}
  Plug 'windwp/nvim-ts-autotag'
  Plug 'nvim-treesitter/playground'
  Plug 'tree-sitter/tree-sitter-embedded-template'
else
  Plug 'dense-analysis/ale'
  Plug 'jiangmiao/auto-pairs'
  Plug 'tpope/vim-endwise'
  Plug 'junegunn/fzf'
  Plug 'junegunn/fzf.vim', { 'do': { -> fzf#install()  } }
endif

call plug#end()
" }}}

" {{{1 nvim-treesitter
if has('nvim')
lua <<EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = "maintained", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
  highlight = {
    enable = true,              -- false will disable the whole extension
    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
}
EOF
endif
" }}}
" {{{1 nvim-ts-autotag
if has('nvim')
lua <<LUA
require('nvim-ts-autotag').setup({
  filetypes = {
    'html', 'javascript', 'javascriptreact', 'typescriptreact', 'svelte', 'vue', 'eruby'
  }
})
LUA
endif
" }}}
" {{{1 nvim-autopairs
if has('nvim')
lua <<LUA
require('nvim-autopairs').setup{}
require("nvim-autopairs.completion.compe").setup({
  map_cr = true, --  map <CR> on insert mode
  map_complete = true -- it will auto insert `(` after select function or method item
})

require('nvim-autopairs').add_rules(require('nvim-autopairs.rules.endwise-lua'))
require('nvim-autopairs').add_rules(require('nvim-autopairs.rules.endwise-ruby'))
LUA
endif
" }}}
" {{{1 nvim-compe
if has_key(plugs, 'nvim-compe')
  set completeopt=menuone,noselect
  let g:compe = {}
  let g:compe.enabled = v:true
  let g:compe.autocomplete = v:true
  let g:compe.debug = v:false
  let g:compe.min_length = 1
  let g:compe.preselect = 'enable'
  let g:compe.throttle_time = 80
  let g:compe.source_timeout = 200
  let g:compe.resolve_timeout = 800
  let g:compe.incomplete_delay = 400
  let g:compe.max_abbr_width = 100
  let g:compe.max_kind_width = 100
  let g:compe.max_menu_width = 100
  let g:compe.documentation = v:true

  let g:compe.source = {}
  let g:compe.source.path = v:true
  let g:compe.source.buffer = v:true
  let g:compe.source.calc = v:true
  let g:compe.source.nvim_lsp = v:true
  let g:compe.source.nvim_lua = v:true
  let g:compe.source.vsnip = v:true
  let g:compe.source.ultisnips = v:true
  let g:compe.source.luasnip = v:true
  let g:compe.source.emoji = v:true

  inoremap <silent><expr> <C-Space> compe#complete()
  imap     <silent><expr> <CR>      compe#confirm("<CR>")
  inoremap <silent><expr> <C-e>     compe#close('<C-e>')
  inoremap <silent><expr> <C-f>     compe#scroll({ 'delta': +4 })
  inoremap <silent><expr> <C-d>     compe#scroll({ 'delta': -4 })

lua <<LUA
  local t = function(str)
    return vim.api.nvim_replace_termcodes(str, true, true, true)
  end

  local check_back_space = function()
      local col = vim.fn.col('.') - 1
      return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') ~= nil
  end

  -- Use (s-)tab to:
  --- move to prev/next item in completion menuone
  --- jump to prev/next snippet's placeholder
  _G.tab_complete = function()
    if vim.fn.pumvisible() == 1 then
      return t "<C-n>"
    elseif vim.fn['vsnip#available'](1) == 1 then
      return t "<Plug>(vsnip-expand-or-jump)"
    elseif check_back_space() then
      return t "<Tab>"
    else
      return vim.fn['compe#complete']()
    end
  end
  _G.s_tab_complete = function()
    if vim.fn.pumvisible() == 1 then
      return t "<C-p>"
    elseif vim.fn['vsnip#jumpable'](-1) == 1 then
      return t "<Plug>(vsnip-jump-prev)"
    else
      -- If <S-Tab> is not working in your terminal, change it to <C-h>
      return t "<S-Tab>"
    end
  end

  vim.api.nvim_set_keymap("i", "<Tab>", "v:lua.tab_complete()", {expr = true})
  vim.api.nvim_set_keymap("s", "<Tab>", "v:lua.tab_complete()", {expr = true})
  vim.api.nvim_set_keymap("i", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
  vim.api.nvim_set_keymap("s", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
LUA
endif
" }}}
" {{{1 ale
if !has('nvim')
  if has_key(plugs, 'ale')
    nmap <silent> [W <Plug>(ale_first)
    nmap <silent> [w <Plug>(ale_previous)
    nmap <silent> ]W <Plug>(ale_last)
    nmap <silent> ]w <Plug>(ale_next)

    nmap <silent> [D <Plug>(ale_first)
    nmap <silent> [d <Plug>(ale_previous)
    nmap <silent> ]D <Plug>(ale_last)
    nmap <silent> ]d <Plug>(ale_next)

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
    let g:ale_hover_to_floating_preview = 1
  endif
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
" {{{1 corpus
if has('nvim')
  lua <<
    CorpusDirectories = {
      ['~/Documents/Corpus'] = {
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
      }
    }
.
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
  buf_set_keymap('n', '<Leader>ld', '<cmd>lua require("lspsaga.diagnostic").show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
  buf_set_keymap('n', '<space>rn', '<cmd>lua require("lspsaga.rename").rename()<CR>', opts)
  buf_set_keymap('n', 'K', '<Cmd>lua require("lspsaga.hover").render_hover_doc()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua require("lspsaga.diagnostic").lsp_jump_diagnostic_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua require("lspsaga.diagnostic").lsp_jump_diagnostic_next()<CR>', opts)
  buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)

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
local sumneko_root_path = vim.fn.expand('~/code/lua-language-server')
local sumneko_binary = sumneko_root_path.."/bin/"..system_name.."/lua-language-server"

require'lspconfig'.sumneko_lua.setup {
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

local signs = { Error = " ", Warning = " ", Hint = " ", Information = " " }

for type, icon in pairs(signs) do
  local hl = "LspDiagnosticsSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end
EOF
endif
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
" {{{ vim-bujo
if has_key(plugs, 'vim-bujo')
  " Remap these since surround attempts to take over experimental stuff
  function! SetBujoMappings() abort
    nmap <buffer> <C-S> <Plug>BujoAddnormal
    imap <buffer> <C-S> <Plug>BujoAddinsert
    nmap <buffer> <C-Q> <Plug>BujoChecknormal
    imap <buffer> <C-Q> <Plug>BujoCheckinsert
  endfunction
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
if has_key(plugs, 'base16-vim')
  if filereadable(expand("~/.vimrc_background"))
    let base16colorspace=256
    silent! source ~/.vimrc_background
  endif
endif
" }}}
