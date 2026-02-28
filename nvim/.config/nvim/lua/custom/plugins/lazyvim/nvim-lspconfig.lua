-- Plugin: nvim-lspconfig
-- Description: LSP configuration and setup
-- Source: LazyVim
--
-- Set to false to disable this plugin
local enabled = true

if not enabled then
  return {}
end

return {
  "neovim/nvim-lspconfig",
  event = "VeryLazy",
  dependencies = {
    "mason.nvim",
    { "mason-org/mason-lspconfig.nvim", config = function() end },
  },
  opts = function()
    ---@class PluginLspOpts
    local ret = {
      -- options for vim.diagnostic.config()
      ---@type vim.diagnostic.Opts
      diagnostics = {
        underline = true,
        update_in_insert = false,
        virtual_text = {
          spacing = 4,
          source = "if_many",
          prefix = "●",
        },
        severity_sort = true,
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = " ",
            [vim.diagnostic.severity.WARN] = " ",
            [vim.diagnostic.severity.HINT] = " ",
            [vim.diagnostic.severity.INFO] = " ",
          },
        },
      },
      -- Enable this to enable the builtin LSP inlay hints on Neovim.
      inlay_hints = {
        enabled = true,
        exclude = { "vue" }, -- filetypes for which you don't want to enable inlay hints
      },
      -- Enable this to enable the builtin LSP code lenses on Neovim.
      codelens = {
        enabled = false,
      },
      -- Enable this to enable the builtin LSP folding on Neovim.
      folds = {
        enabled = true,
      },
      -- add any global capabilities here
      capabilities = {
        workspace = {
          fileOperations = {
            didRename = true,
            willRename = true,
          },
        },
      },
      -- options for vim.lsp.buf.format
      format = {
        formatting_options = nil,
        timeout_ms = nil,
      },
      -- LSP Server Settings
      servers = {
        lua_ls = {
          settings = {
            Lua = {
              workspace = {
                checkThirdParty = false,
              },
              codeLens = {
                enable = true,
              },
              completion = {
                callSnippet = "Replace",
              },
              doc = {
                privateName = { "^_" },
              },
              hint = {
                enable = true,
                setType = false,
                paramType = true,
                paramName = "Disable",
                semicolon = "Disable",
                arrayIndex = "Disable",
              },
            },
          },
        },
        -- User overrides: Additional LSP servers
        bashls = {},
        cssls = {},
        ts_ls = {},
        phpactor = {
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
        jsonls = {
          settings = {
            json = {
              schemas = require("schemastore").json.schemas(),
              validate = { enable = true },
            }
          }
        },
        yamlls = {},
      },
      setup = {},
    }
    return ret
  end,
  config = function(_, opts)
    -- diagnostics
    vim.diagnostic.config(vim.deepcopy(opts.diagnostics))

    if opts.capabilities then
      vim.lsp.config("*", { capabilities = opts.capabilities })
    end

    -- Configure servers
    for server, server_opts in pairs(opts.servers) do
      if server_opts then
        server_opts = server_opts == true and {} or server_opts
        vim.lsp.config(server, server_opts)
      end
    end

    -- inlay hints
    if opts.inlay_hints.enabled then
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local buffer = args.buf
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if client and client.supports_method("textDocument/inlayHint") then
            if vim.api.nvim_buf_is_valid(buffer) and vim.bo[buffer].buftype == "" then
              if not vim.tbl_contains(opts.inlay_hints.exclude, vim.bo[buffer].filetype) then
                vim.lsp.inlay_hint.enable(true, { bufnr = buffer })
              end
            end
          end
        end,
      })
    end

    -- folds
    if opts.folds.enabled then
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if client and client.supports_method("textDocument/foldingRange") then
            vim.wo.foldmethod = "expr"
            vim.wo.foldexpr = "v:lua.vim.lsp.foldexpr()"
          end
        end,
      })
    end

    -- code lens
    if opts.codelens.enabled and vim.lsp.codelens then
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if client and client.supports_method("textDocument/codeLens") then
            vim.lsp.codelens.refresh()
            vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
              buffer = args.buf,
              callback = vim.lsp.codelens.refresh,
            })
          end
        end,
      })
    end
  end,
}
