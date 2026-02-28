return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      bashls = {
        enabled = true
      },
      cssls = {
        enabled = true
      },
      ts_ls = {
        enabled = true
      },
      phpactor = {
        enabled = true,
        init_options = {
          ["language_server_phpstan.enabled"] = true,
          ["language_server_psalm.enabled"] = true,
          ["language_server_php_cs_fixer.enabled"] = true,
          ["php_code_sniffer.enabled"] = true,
          ["php_code_sniffer.args"] = {"--standard=Drupal,DrupalPractice"},
          ["code_transform.indentation"] = "  ",
          ["prophecy.enabled"] = true,
          ["behat.enabled"] = true,
          ["symfony.enabled"] = true,
        },
      },
      intelephense = {
        enabled = false,
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
      jsonls = {
        settings = {
          json = {
            schemas = require("schemastore").json.schemas(),
            validate = { enable = true },
          }
        }
      },
      yamlls = {
        enabled = true
      },
    },
  }
}
