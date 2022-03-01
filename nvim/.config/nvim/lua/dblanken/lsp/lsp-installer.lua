local status_ok, lsp_installer = pcall(require, 'nvim-lsp-installer')
if not status_ok then
  return
end

lsp_installer.on_server_ready(function(server)
  local opts = {
    on_attach = require('dblanken.lsp.handlers').on_attach,
    capabilities = require('dblanken.lsp.handlers').capabilities,
  }

  if server.name == "jsonls" then
    local jsonls_opts = require('dblanken.lsp.settings.jsonls')
    opts = vim.tbl_deep_extend('force', jsonls_opts, opts)
  end

  if server.name == "sumneko_lua" then
    local sumneko_opts = require('dblanken.lsp.settings.sumneko_lua')
    opts = vim.tbl_deep_extend('force', sumneko_opts, opts)
  end

  if server.name == "solargraph" then
    print("Please do not install solargraph from nvim-lsp-installer.  It mucks up other libraries used with solargraph.")
  end

  server:setup(opts)
end)
