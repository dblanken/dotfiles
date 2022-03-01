local status_ok, lspconfig = pcall(require, 'lspconfig')
if not status_ok then
  return
end

local opts = {
  on_attach = require('dblanken.lsp.handlers').on_attach,
  capabilities = require('dblanken.lsp.handlers').capabilities,
}

local solargraph_opts = require('dblanken.lsp.settings.solargraph')
opts = vim.tbl_deep_extend('force', solargraph_opts, opts)
lspconfig.solargraph.setup(opts)
