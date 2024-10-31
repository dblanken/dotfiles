return {
  "neovim/nvim-lspconfig",
  opts = function()
    local ret = {
      servers = {
        bashls = true,
        cssls = true,
        ts_ls = true,
        intelephense = {
          on_init = function(client)
            client.server_capabilities.documentFormattingProvider = false
          end,
          init_options = {
            globalStoragePath = os.getenv("HOME") .. "/.local/share/intelephense",
          },
          config = {
            ["intelephense.environment.includePaths"] = {
              "web/core/includes",
            },
            ["intelephense.files.associations"] = {
              "*.inc",
              "*.theme",
              "*.install",
              "*.module",
              "*.profile",
              "*.php",
              "*.phtml",
            },
          },
        },
        settings = {
          jsonls = {
            json = {
              schemas = require("schemastore").json.schemas(),
              validate = { enable = true },
            },
          },
        },
        yamlls = true,
        -- {
        --   settings = {
        --     yaml = {
        --       schemaStore = {
        --         enable = false,
        --         url = "",
        --       },
        --       schemas = require("schemastore").yaml.schemas(),
        --       yamlVersion = "1.1",
        --     },
        --   },
        -- },
      },
    }
  end,
}
