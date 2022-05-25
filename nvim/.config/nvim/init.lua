require "user.globals"
require "user.keymaps"
require "user.plugins"
require "user.autocommands"
require "user.colorscheme"
require "user.options"
require "user.providers"
require "user.builtins"

require "user.treesitter"
require "user.telescope"
require "user.autopairs"
require "user.endwise"
require "user.lsp"

-- -- {{{1 Autocmds
-- vim.cmd [[

-- " Removes all whitespace from the buffer
-- function! TrimWhitespace() abort
--   let l:save = winsaveview()
--   keeppatterns %s/\s\+$//e
--   call winrestview(l:save)
-- endfunction

-- augroup misc
-- autocmd!

-- " When resized, resize the windows inside
-- autocmd VimResized * execute "normal! \<c-w>="

-- " Nest source on changes to vimrc
-- autocmd BufWritePost .vimrc,init.vim,init.lua,vimrc nested source %

-- autocmd BufEnter,BufNewFile .zshrc,zshrc setlocal filetype=zsh

-- autocmd BufWritePre * :call TrimWhitespace()

-- " When editing a file, always jump to the last known cursor position.
-- " Don't do it for commit messages, when the position is invalid, or when
-- " inside an event handler (happens when dropping a file on gvim).
-- "
-- autocmd BufReadPost *
-- \ if &ft != 'gitcommit' && line("'\"") > 0 && line("'\"") <= line("$") |
-- \   exe "normal g`\"" |
-- \ endif
-- augroup end

-- augroup dblanken_filetypes
-- autocmd FileType * setlocal nolinebreak
-- autocmd FileType xml,xsd,xslt,javascript setlocal ts=2
-- autocmd FileType mail,gitcommit setlocal tw=72 spell
-- autocmd FileType sh,zsh,csh,tcsh setlocal fo-=t|
-- \ inoremap <silent> <buffer> <C-X>! #!/bin/<C-R>=&ft<CR>
-- autocmd FileType perl,python,ruby,tcl
-- \ inoremap <silent> <buffer> <C-X>! #!/usr/bin/env<Space><C-R>=&ft<CR>
-- autocmd FileType javascript
-- \ inoremap <silent> <buffer> <C-X>! #!/usr/bin/env<Space>node
-- autocmd FileType help setlocal ai formatoptions+=2n nospell
-- autocmd FileType ruby setlocal comments=:#\ tw=78
-- autocmd BufRead,BufNewFile *.md set filetype=markdown
-- autocmd FileType liquid,markdown,text,txt setlocal tw=78 linebreak keywordprg=dict spell
-- autocmd BufRead,BufNewFile */.zsh/* set ft=zsh
-- augroup END
-- ]]

-- -- {{{1 Grep
-- local function setupGrepProgram()
--   if vim.fn.executable('rg') then
--     return 'rg --no-heading --vimgrep --smart-case'
--   elseif vim.fn.executable('ag') then
--     return 'ag --nogroup --nocolor'
--   end

--   return vim.o.grepprg
-- end

-- vim.opt.grepprg = setupGrepProgram()

-- -- {{{1 Plugins
-- -- {{{2 Loading
-- vim.cmd [[
-- packadd! vim-commentary
-- packadd! vim-eunuch
-- packadd! vim-fugitive
-- packadd! vim-dispatch
-- packadd! vim-projectionist
-- packadd! vim-rails
-- packadd! vim-rake
-- packadd! vim-repeat
-- packadd! vim-surround
-- packadd! vim-tmux-navigator
-- packadd! vim-test
-- packadd! nvim-base16.lua
-- packadd! nvim-treesitter            " Run ':TSUpdate' and ':TSInstall all' after
-- packadd! plenary.nvim
-- packadd! telescope.nvim
-- packadd! nvim-lspconfig
-- packadd! cmp-nvim-lsp
-- packadd! cmp-buffer
-- packadd! cmp-path
-- packadd! cmp-cmdline
-- packadd! cmp-git
-- packadd! nvim-cmp
-- packadd! cmp-vsnip
-- packadd! vim-vsnip
-- packadd! friendly-snippets
-- packadd! nvim-lsp-installer
-- packadd! vim-unimpaired
-- packadd! vimwiki
-- packadd! vim-pandoc
-- packadd! vim-pandoc-syntax
-- packadd! markdown-preview.nvim
-- packadd! vim-transparent
-- ]]

-- -- {{{2 Plugin Configuration
-- -- {{{3 vim-rails
-- g.rails_projections = {
--   ["test/models/*_test.rb"] = {
--     ["command"] = "modeltest",
--     ["template"] = {
--       "require 'test_helper'",
--       "",
--       "class {camelcase|capitalize|colons}Test < ActiveSupport::TestCase",
--       "",
--       "end"
--     },
--     ["alternate"] = "app/models/{}.rb"
--   }
-- }
-- -- {{{3 vimwiki
-- g.vimwiki_list = {
--   {
--     path = '~/code/vimwiki',
--     syntax = 'markdown',
--     ext = '.md'
--   },
--   {
--     path = '~/vimwiki',
--     syntax = 'markdown',
--     ext = '.md'
--   }
-- }

-- -- {{{3 vim-test
-- api.nvim_set_keymap('n', '<Leader>t', ':TestNearest<CR>', { silent = true })
-- api.nvim_set_keymap('n', '<Leader>T', ':TestFile<CR>', { silent = true })
-- api.nvim_set_keymap('n', '<Leader>a', ':TestSuite<CR>', { silent = true })
-- api.nvim_set_keymap('n', '<Leader>l', ':TestLast<CR>', { silent = true })
-- g['test#strategy'] = 'dispatch'

-- -- {{{3 nvim-treesitter
-- require 'nvim-treesitter.configs'.setup {
--   -- A list of parser names, or "all"
--   ensure_installed = "all",

--   -- Install parsers synchronously (only applied to `ensure_installed`)
--   sync_install = false,

--   -- List of parsers to ignore installing (for "all")
--   ignore_install = {},

--   highlight = {
--     -- `false` will disable the whole extension
--     enable = true,

--     -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
--     -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
--     -- the name of the parser)
--     -- list of language that will be disabled
--     disable = {},

--     -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
--     -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
--     -- Using this option may slow down your editor, and you may see some duplicate highlights.
--     -- Instead of true it can also be a list of languages
--     additional_vim_regex_highlighting = true,
--   },
-- }

-- -- {{{3 Telescope
-- function edit_neovim()
--   local opts = {
--     prompt_title = "Neovim",
--     shorten_path = false,
--     cwd = "~/.config/nvim",
--     layout_strategy = "flex",
--     layout_config = {
--       width = 0.9,
--       height = 0.8,
--       horizontal = {
--         width = { padding = 0.15 },
--       },
--       vertical = {
--         preview_height = 0.75,
--       },
--     },
--     find_command = { "rg", "--ignore", "--hidden", "--files", "--glob=!pack" },
--   }

--   require("telescope.builtin").find_files(opts)
-- end

-- function edit_dotfiles()
--   local opts = {
--     prompt_title = "Neovim",
--     shorten_path = false,
--     cwd = "~/.dotfiles",
--     layout_strategy = "flex",
--     layout_config = {
--       width = 0.9,
--       height = 0.8,
--       horizontal = {
--         width = { padding = 0.15 },
--       },
--       vertical = {
--         preview_height = 0.75,
--       },
--     },
--     find_command = { "rg", "--ignore", "--hidden", "--files", "--glob=!pack", "--glob=!.git" },
--   }

--   require("telescope.builtin").find_files(opts)
-- end

-- api.nvim_set_keymap('n', '<Leader>ff', "<cmd>lua require'telescope.builtin'.find_files()<CR>", { noremap = true })
-- api.nvim_set_keymap('n', '<Leader>fg', "<cmd>lua require'telescope.builtin'.live_grep()<CR>", { noremap = true })
-- api.nvim_set_keymap('n', '<Leader>fb', "<cmd>lua require'telescope.builtin'.buffers()<CR>", { noremap = true })
-- api.nvim_set_keymap('n', '<Leader>fh', "<cmd>lua require'telescope.builtin'.help_tags()<CR>", { noremap = true })
-- api.nvim_set_keymap('n', '<Leader>fn', "<cmd>lua edit_neovim()<CR>", { noremap = true })
-- api.nvim_set_keymap('n', '<Leader>fd', "<cmd>lua edit_dotfiles()<CR>", { noremap = true })

-- -- {{{3 nvim-cmp
-- local cmp = require 'cmp'

-- local has_words_before = function()
--   local line, col = unpack(vim.api.nvim_win_get_cursor(0))
--   return col ~= 0 and api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
-- end

-- local feedkey = function(key, mode)
--   api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
-- end

-- cmp.setup({
--   snippet = {
--     -- REQUIRED - you must specify a snippet engine
--     expand = function(args)
--       vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
--     end,
--   },
--   window = {
--     completion = cmp.config.window.bordered(),
--     documentation = cmp.config.window.bordered(),
--   },
--   mapping = cmp.mapping.preset.insert({
--     ["<Tab>"] = cmp.mapping(function(fallback)
--       if cmp.visible() then
--         cmp.select_next_item()
--       elseif vim.fn["vsnip#available"](1) == 1 then
--         feedkey("<Plug>(vsnip-expand-or-jump)", "")
--       elseif has_words_before() then
--         cmp.complete()
--       else
--         fallback() -- The fallback function sends a already mapped key. In this case, it's probably `<Tab>`.
--       end
--     end, { "i", "s" }),

--     ["<S-Tab>"] = cmp.mapping(function()
--       if cmp.visible() then
--         cmp.select_prev_item()
--       elseif vim.fn["vsnip#jumpable"](-1) == 1 then
--         feedkey("<Plug>(vsnip-jump-prev)", "")
--       end
--     end, { "i", "s" }),
--     ['<C-b>'] = cmp.mapping.scroll_docs(-4),
--     ['<C-f>'] = cmp.mapping.scroll_docs(4),
--     ['<C-Space>'] = cmp.mapping.complete(),
--     ['<C-e>'] = cmp.mapping.abort(),
--     ['<CR>'] = cmp.mapping.confirm({ select = false }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
--   }),
--   sources = cmp.config.sources({
--     { name = 'nvim_lsp' },
--     { name = 'vsnip' }, -- For vsnip users.
--   }, {
--     { name = 'buffer' },
--   })
-- })

-- -- Set configuration for specific filetype.
-- cmp.setup.filetype('gitcommit', {
--   sources = cmp.config.sources({
--     { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
--   }, {
--     { name = 'buffer' },
--   })
-- })

-- -- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
-- cmp.setup.cmdline('/', {
--   mapping = cmp.mapping.preset.cmdline(),
--   sources = {
--     { name = 'buffer' }
--   }
-- })

-- -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
-- cmp.setup.cmdline(':', {
--   mapping = cmp.mapping.preset.cmdline(),
--   sources = cmp.config.sources({
--     { name = 'path' }
--   }, {
--     { name = 'cmdline' }
--   })
-- })

-- -- Allow rails filetypes to use ruby snippets
-- vim.cmd [[
-- let g:vsnip_filetypes = {}
-- let g:vsnip_filetypes.ruby = ['rails']
-- ]]

-- -- Used later for lspconfig.
-- local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())

-- -- {{{3 nvim-lsp-installer
-- local lsp_installer = require("nvim-lsp-installer")

-- -- Register a handler that will be called for each installed server when it's ready (i.e. when installation is finished
-- -- or if the server is already installed).
-- lsp_installer.on_server_ready(function(server)
--   local on_attach = function(_client, bufnr)
--     local opts = { noremap = true, silent = true }
--     -- Enable completion triggered by <c-x><c-o>
--     api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

--     -- Mappings.
--     -- See `:help vim.lsp.*` for documentation on any of the below functions
--     api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
--     api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
--     api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
--     api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
--     api.nvim_buf_set_keymap(bufnr, 'n', '<Leader>k', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
--     api.nvim_buf_set_keymap(bufnr, 'n', '<Leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
--     api.nvim_buf_set_keymap(bufnr, 'n', '<Leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
--     api.nvim_buf_set_keymap(bufnr, 'n', '<Leader>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
--     api.nvim_buf_set_keymap(bufnr, 'n', '<Leader>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
--     api.nvim_buf_set_keymap(bufnr, 'n', '<Leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
--     api.nvim_buf_set_keymap(bufnr, 'n', '<Leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
--     api.nvim_buf_set_keymap(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
--     api.nvim_buf_set_keymap(bufnr, 'n', '<Leader>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
--     api.nvim_buf_set_keymap(bufnr, 'n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
--     api.nvim_buf_set_keymap(bufnr, 'n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
--     api.nvim_buf_set_keymap(bufnr, 'n', '<Leader>=', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
--   end

--   local opts = {
--     on_attach = on_attach,
--     capabilities = capabilities
--   }

--   -- (optional) Customize the options passed to the server
--   -- if server.name == "tsserver" then
--   --     opts.root_dir = function() ... end
--   -- end
--   if server.name == "ruby" then
--     opts.diagnostics = true
--   elseif server.name == "diagnosticls" then
--     opts.filetypes = {
--       "ruby"
--     }
--     opts.init_options = {
--       linters = {
--         reek = {
--           command = "reek",
--           debounce = 100,
--           args = { "--format", "json", "%file" },
--           sourceName = "reek",
--           parseJson = {
--             line = "lines[0]",
--             message = "${message} [${smell_type}]",
--           }
--         },
--       },
--       filetypes = {
--         ruby = "reek"
--       }
--     }
--   end

--   -- This setup() function will take the provided server configuration and decorate it with the necessary properties
--   -- before passing it onwards to lspconfig.
--   -- Refer to https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
--   server:setup(opts)
-- end)

-- -- {{{3 ale
-- -- g.ale_disable_lsp = 1
-- -- g.ale_linters = {
-- --   ['ruby'] = { 'reek' }
-- -- }

-- -- {{{3 colorscheme
-- vim.cmd('colorscheme base16-' .. vim.env["BASE16_THEME"])
