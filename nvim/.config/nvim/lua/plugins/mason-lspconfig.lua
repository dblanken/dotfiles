return {
  'williamboman/mason-lspconfig.nvim',
  dependencies = { 'williamboman/mason.nvim', 'neovim/nvim-lspconfig' },
  config = function()
    require('mason').setup()
    require('mason-lspconfig').setup()

    local lspconfig = require('lspconfig')
    local servers = require('mason-lspconfig').get_installed_servers()
    local lsp_capabilities = require('cmp_nvim_lsp').default_capabilities()

    for _, server_name in ipairs(servers) do
      lspconfig[server_name].setup({
        capabilities = lsp_capabilities,
      })
    end

  -- Intelephense like to create a directory on my home directory
  -- I don't like this.
    lspconfig.intelephense.setup {
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
