-- Global settings
vim.g.mapleader = " "
vim.g.localmapleader = "\\"

-- Options
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.termguicolors = true

vim.opt.colorcolumn = "80"

vim.opt.grepprg="rg --vimgrep --smart-case --hidden"
vim.opt.grepformat="%f:%l:%c:%m"

-- nvim-compe requires this
vim.opt.completeopt = "menuone,noselect"

-- Global Mappings
-- < and > reselects
vim.api.nvim_set_keymap('v', '<', '<gv', {})
vim.api.nvim_set_keymap('v', '>', '>gv', {})

-- Y functions as it should to yank end of line
vim.api.nvim_set_keymap('', 'Y', 'y$', {})

-- Format the whole document
vim.api.nvim_set_keymap('n', '<Leader>=', "migg=G'i", {})

-- autogroups
vim.cmd([[
augroup highlight_yank
    autocmd!
    au TextYankPost * silent! lua vim.highlight.on_yank{higroup="IncSearch", timeout=700}
augroup END
]])

-- Plugins
require('packer').startup(function()
  use 'wbthomason/packer.nvim'

  use 'tpope/vim-apathy'
  use 'tpope/vim-bundler'
  use 'tpope/vim-commentary'
  use 'tpope/vim-dispatch'
  use 'tpope/vim-eunuch'
  use 'tpope/vim-fugitive'
  use 'tpope/vim-git'
  use 'tpope/vim-projectionist'
  use 'tpope/vim-ragtag'
  use 'tpope/vim-rails'
  use 'tpope/vim-sleuth'
  use 'tpope/vim-surround'
  use 'tpope/vim-unimpaired'
  use 'tpope/vim-vinegar'

  use 'vim-pandoc/vim-pandoc'
  use 'vim-ruby/vim-ruby'
  use 'vim-test/vim-test'
  use { 'tweekmonster/startuptime.vim', opt = true, cmd = {'StartupTime'} }

  -- Nvim only
  use 'neovim/nvim-lspconfig'
  use 'hrsh7th/nvim-compe'
  use 'hrsh7th/vim-vsnip'
  use 'hrsh7th/vim-vsnip-integ'
  use 'rafamadriz/friendly-snippets'
  use {
    'nvim-telescope/telescope.nvim',
    requires = {{'nvim-lua/popup.nvim'}, {'nvim-lua/plenary.nvim'}}
  }
  use { 
    'nvim-treesitter/nvim-treesitter',
    require = {{'nvim-lua/plenary.nvim'}},
    run = ':TSUpdate'
  }
  use {
    'tjdevries/express_line.nvim',
    requires = {'kyazdani42/nvim-web-devicons', opt = true}
  }
  use {"npxbr/gruvbox.nvim", requires = {"rktjmp/lush.nvim"}}
  use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
  use 'glepnir/lspsaga.nvim'
end)

-- Vim-Test
local silent_only = { silent=true }
vim.api.nvim_set_keymap('n', '<Leader>t', ':TestNearest<CR>', silent_only)
vim.api.nvim_set_keymap('n', '<Leader>T', ':TestFile<CR>', silent_only)
vim.api.nvim_set_keymap('n', '<Leader>a', ':TestSuite<CR>', silent_only)
vim.api.nvim_set_keymap('n', '<Leader>l', ':TestLast<CR>', silent_only)
vim.g['test#strategy'] = 'dispatch'

-- Vim-Rails
vim.g.rails_projections = "{ 'test/models/*_test.rb': {'command': 'modeltest'} }"

-- Vim-Ruby
vim.g.ruby_path = "~/.asdf/shims/ruby"

-- nvim-lsp
local nvim_lsp = require('lspconfig')

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  local nnoremap = function(lhs, rhs)
    buf_set_keymap('n', lhs, rhs, {noremap = true, silent = true})
  end

  --Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')
  vim.api.nvim_win_set_option(0, 'signcolumn', 'yes')

  local mappings = {
    ['gd'] = '<Cmd>lua vim.lsp.buf.definition()<CR>',
    ['<c-]>'] = '<cmd>lua vim.lsp.buf.definition()<CR>',
    ['K'] = "<cmd>lua require('lspsaga.hover').render_hover_doc()<CR>",
    ['<Leader>d'] = "<cmd>lua require('lspsaga.diagnostic').show_line_diagnostics()<CR>",
    ['[w'] = "<cmd>lua require'lspsaga.diagnostic'.lsp_jump_diagnostic_prev()<CR>",
    [']w'] = "<cmd>lua require'lspsaga.diagnostic'.lsp_jump_diagnostic_next()<CR>",
  }

  for lhs, rhs in pairs(mappings) do
    nnoremap(lhs, rhs)
  end
end

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local servers = { "solargraph", "vimls", "bashls", "tsserver" }
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
    on_attach = on_attach,
    flags = {
      debounce_text_changes = 150,
    }
  }
end

-- telescope.nvim
-- with fzf-native
require('telescope').setup {
  extensions = {
    fzf = {
      fuzzy = true,                    -- false will only do exact matching
      override_generic_sorter = false, -- override the generic sorter
      override_file_sorter = true,     -- override the file sorter
      case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
                                       -- the default case_mode is "smart_case"
    }
  }
}

-- To get fzf loaded and working with telescope, you need to call
-- load_extension, somewhere after setup function:
require('telescope').load_extension('fzf')

vim.api.nvim_set_keymap('n', '<Leader>ff', '<cmd>lua require("telescope.builtin").find_files()<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<Leader>fg', '<cmd>lua require("telescope.builtin").live_grep()<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<Leader>fb', '<cmd>lua require("telescope.builtin").buffers()<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<Leader>fh', '<cmd>lua require("telescope.builtin").help_tags()<CR>', { noremap = true })

-- treesitter
require'nvim-treesitter.configs'.setup {
  ensure_installed = "maintained", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
  ignore_install = {}, -- List of parsers to ignore installing
  highlight = {
    enable = true,              -- false will disable the whole extension
    disable = {},  -- list of language that will be disabled
    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
}

-- nvim-compe
require'compe'.setup {
  enabled = true;
  autocomplete = true;
  debug = false;
  min_length = 1;
  preselect = 'enable';
  throttle_time = 80;
  source_timeout = 200;
  resolve_timeout = 800;
  incomplete_delay = 400;
  max_abbr_width = 100;
  max_kind_width = 100;
  max_menu_width = 100;
  documentation = {
    border = { '', '' ,'', ' ', '', '', '', ' ' }, -- the border option is the same as `|help nvim_open_win|`
    winhighlight = "NormalFloat:CompeDocumentation,FloatBorder:CompeDocumentationBorder",
    max_width = 120,
    min_width = 60,
    max_height = math.floor(vim.o.lines * 0.3),
    min_height = 1,
  };

  source = {
    path = true;
    buffer = true;
    calc = true;
    nvim_lsp = true;
    nvim_lua = true;
    vsnip = true;
    ultisnips = true;
    luasnip = true;
  };
}

-- The following allows us to use Tab for everything
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
vim.api.nvim_set_keymap("i", "<CR>", "compe#confirm('<CR>')", { silent = true, expr = true })

-- express_line
require('el').setup {}

-- Colorscheme
vim.opt.background = "dark"
vim.g.gruvbox_italic = 1
vim.cmd([[
augroup colorOverrides
  autocmd!
  autocmd ColorScheme * highlight Normal guibg=NONE
augroup END
]])
vim.cmd([[colorscheme gruvbox]])
