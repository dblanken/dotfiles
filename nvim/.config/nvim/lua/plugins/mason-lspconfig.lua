return {
  'williamboman/mason-lspconfig.nvim',
  dependencies = { 'williamboman/mason.nvim', 'neovim/nvim-lspconfig', 'SmiteshP/nvim-navic' },
  config = function()
    require('mason').setup()
    require('mason-lspconfig').setup()
    require('nvim-navic').setup()

    local lspconfig = require('lspconfig')
    local servers = require('mason-lspconfig').get_installed_servers()
    local lsp_capabilities = require('cmp_nvim_lsp').default_capabilities()
    local on_attach = function(client, buffer)
      if client.server_capabilities.documentSymbolProvider then
        require('nvim-navic').attach(client, buffer)
      end
    end

    for _, server_name in ipairs(servers) do
      lspconfig[server_name].setup({
        capabilities = lsp_capabilities,
        on_attach = on_attach,
      })
    end

    -- Add vimwiki file type to marksman lsp along with the existing filetypes supported.
    lspconfig.marksman.setup({
      filetypes = { 'vimwiki', 'markdown', 'pandoc' },
      capabilities = lsp_capabilities,
      on_attach = on_attach,
    })

    -- Intelephense like to create a directory on my home directory
    -- I don't like this.
    lspconfig.intelephense.setup {
      on_attach = on_attach,
      init_options = {
        globalStoragePath = os.getenv('HOME') .. '/.local/share/intelephense'
      },
      config = {
        ["intelephense.environment.includePaths"] = {
          "web/core/includes"
        },
        ["intelephense.files.associations"] = {
          "*.inc",
          "*.theme",
          "*.install",
          "*.module",
          "*.profile",
          "*.php",
          "*.phtml"
        },
      },
    }

    lspconfig.lua_ls.setup {
      -- ... other configs
      settings = {
        Lua = {
          diagnostics = {
            globals = { 'vim' }
          }
        }
      }
    }
  end
}
