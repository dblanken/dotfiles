local lsp = require('lsp-zero').preset({
  name = 'minimal',
  set_lsp_keymaps = true,
  manage_nvim_cmp = true,
  suggest_lsp_servers = true,
})

-- Solargraph wigs out if you modify rubocop's defaults
-- So let's do this ourselves; this doesn't check for install
lsp.configure('solargraph', {
  force_setup = true
})
-- (Optional) Configure lua language server for neovim
lsp.nvim_workspace()

lsp.setup()
