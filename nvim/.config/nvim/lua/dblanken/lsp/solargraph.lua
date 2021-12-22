local opts = {
  on_attach = require('dblanken.lsp.handlers').on_attach,
  capabilities = require('dblanken.lsp.handlers').capabilities,
}

local solargraph_opts = require('dblanken.lsp.settings.solargraph')
opts = vim.tbl_deep_extend('force', solargraph_opts, opts)
require('lspconfig').solargraph.setup(opts)
