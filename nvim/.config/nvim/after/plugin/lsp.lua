local lsp = require('lsp-zero').preset({
  -- name = 'minimal',
  -- set_lsp_keymaps = true,
  -- manage_nvim_cmp = true,
  -- suggest_lsp_servers = true,
})

lsp.on_attach(function(client, bufnr)
  lsp.default_keymaps({buffer = bufnr})

  if client.server_capabilities.documentSymbolProvider then
    require('nvim-navic').attach(client, bufnr)
  end
end)

local cmp = require('cmp')
local cmp_select = {behavior = cmp.SelectBehavior.Select}
local cmp_mappings = lsp.defaults.cmp_mappings({
  ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
  ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
  ['<C-y>'] = cmp.mapping.confirm({ select = true }),
  ["<C-Space>"] = cmp.mapping.complete(),
  ['<CR>'] = cmp.mapping.confirm({
    behavior = cmp.ConfirmBehavior.Replace,
    select = false,
  }),
})

cmp_mappings['<Tab>'] = nil
cmp_mappings['<S-Tab>'] = nil

local cmp_sources = {
  {name = 'copilot'},
  {name = 'nvim_lsp'},
}

-- Get lsp-zero's default sources
local lsp_sources = lsp.defaults.cmp_sources()
--append to cmp_sources
for _, source in ipairs(lsp_sources) do
  table.insert(cmp_sources, source)
end

lsp.setup_nvim_cmp({
  mapping = cmp_mappings,
  sources = cmp_sources
})

-- Solargraph wigs out if you modify rubocop's defaults
-- So let's do this ourselves; this doesn't check for install
lsp.configure('solargraph', {
  force_setup = true
})
-- (Optional) Configure lua language server for neovim
require('lspconfig').lua_ls.setup(lsp.nvim_lua_ls())

lsp.setup()

local filetypes = {
  php = {"phpcs"},
}

local linters = {
  phpcs = {
    command = "phpcs",
    sourceName = "phpcs",
    debounce = 300,
    rootPatterns = {"composer.lock", "vendor", ".git"},
    args = {"--report=emacs", "-s", "-"},
    offsetLine = 0,
    offsetColumn = 0,
    formatLines = 1,
    formatPattern = {
      "^.*:(\\d+):(\\d+):\\s+(.*)\\s+-\\s+(.*)(\\r|\\n)*$",
      {
        line = 1,
        column = 2,
        message = 4,
        security = 3,
      },
    },
    securities = {
      error = "error",
      warning = "warning",
    },
    requiredFiles = { "phpcs" }
  },
}

require('lspconfig').diagnosticls.setup {
  on_attach = lsp.on_attach,
  filetypes = vim.tbl_keys(filetypes),
  init_options = {
    filetypes = filetypes,
    linters = linters,
  },
}
