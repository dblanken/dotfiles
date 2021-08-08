local present1, lspconfig = pcall(require, "lspconfig")
local present2, lspinstall = pcall(require, "lspinstall")
if not (present1 or present2) then
  return
end

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(_, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  --Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<Cmd>lua require("lspsaga.hover").render_hover_doc()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<space>rn', '<cmd>lua require("lspsaga.rename").rename()<CR>', opts)
  buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<space>e', '<cmd>lua require("lspsaga.diagnostic").show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua require("lspsaga.diagnostic").lsp_jump_diagnostic_next()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua require("lspsaga.diagnostic").lsp_jump_diagnostic_prev()<CR>', opts)
  buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
  buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

local function setup_servers()
  lspinstall.setup()
  local servers = lspinstall.installed_servers()
  for _, lang in pairs(servers) do
    -- if lang == "ruby" then
    --   -- Use custom command since default solargraph does not respect
    --   -- rubocop extensions
    --   lspconfig[lang].setup {
    --     cmd = {vim.fn.expand("~/.asdf/shims/solargraph")},
    --     on_attach = on_attach,
    --     capabilities = capabilities,
    --     root_dir = vim.loop.cwd,
    --     settings = {
    --       solargraph = {
    --         diagnostics = true
    --       }
    --     },
    --     flags = {
    --       debounce_text_changes = 150,
    --     }
    --   }
    if lang == "lua" then
      lspconfig[lang].setup {
        root_dir = vim.loop.cwd,
        on_attach = on_attach,
        flags = {
          debounce_text_changes = 150,
        },
        settings = {
          Lua = {
            diagnostics = {
              globals = {"vim"}
            },
            workspace = {
              library = {
                [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true
              },
              maxPreload = 100000,
              preloadFileSize = 10000
            },
            telemetry = {
              enable = false
            }
          }
        }
      }
    elseif lang == "diagnosticls" then
      vim.lsp.set_log_level("debug")
      lspconfig[lang].setup {
        on_attach = on_attach,
        cmd = {"diagnostic-languageserver", "--stdio"},
        filetypes = {
          "sh",
          "markdown",
          "yaml",
          "toml",
          "pandoc",
          "text",
        },
        init_options = {
          linters = {
            reek = {
              command = "reek",
              debounce = 100,
              args = {"--format", "json", "%file"},
              sourceName = "reek",
              parseJson = {
                line = "lines[0]",
                message = "${message} [${smell_type}]",
              }
            },
            languagetool = {
              command = 'languagetool',
              args = {'--language', 'en-US', '%file'},
              debounce = 200,
              offsetLine = 0,
              offsetColumn = 1,
              sourceName = 'languagetool',
              formatLines = 2,
              formatPattern = { "^\\d+?\\.\\)\\s+Line\\s+(\\d+),\\s+column\\s+(\\d+),\\s+([^\\n]+)\nMessage:\\s+(.*)$",
              {
                line = 1,
                column = 2,
                message = { 4, 3 }
              }
            },
          },
          shellcheck = {
            command = "shellcheck",
            debounce = 100,
            args = {"--format", "json", "-"},
            sourceName = "shellcheck",
            parseJson = {
              line = "line",
              column = "column",
              endLine = "endLine",
              endColumn = "endColumn",
              message = "${message} [${code}]",
              security = "level"
            },
            securities = {
              error = "error",
              warning = "warning",
              info = "info",
              style = "hint"
            }
          },
          markdownlint = {
            command = "markdownlint",
            isStderr = true,
            debounce = 100,
            args = {"--stdin"},
            offsetLine = 0,
            offsetColumn = 0,
            sourceName = "markdownlint",
            formatLines = 1,
            formatPattern = {
              "^.*?:\\s?(\\d+)(:(\\d+)?)?\\s(MD\\d{3}\\/[A-Za-z0-9-/]+)\\s(.*)$",
              {
                line = 1,
                column = 3,
                message = {4}
              }
            }
          }
        },
        filetypes = {
          sh = "shellcheck",
          markdown = {"markdownlint"},
          text = "languagetool",
          -- ruby = "reek",
          -- ruby = "brakeman",
          -- ruby = {"reek", "brakeman"},
        },
        formatters = {
          shfmt = {
            command = "shfmt",
            args = {"-i", "2", "-bn", "-ci", "-sr"}
          },
          prettier = {
            command = "prettier",
            args = {"--stdin-filepath", "%filepath"},
          }
        },
        formatFiletypes = {
          sh = "shfmt",
          json = "prettier",
          yaml = "prettier",
          toml = "prettier",
          markdown = "prettier",
          lua = "prettier",
          pandoc = "prettier"
        }
      }
    }
  else
    lspconfig[lang].setup {
      on_attach = on_attach,
      capabilities = capabilities,
      root_dir = vim.loop.cwd,
      flags = {
        debounce_text_changes = 150,
      }
    }
  end
end
end

setup_servers()

-- Automatically reload after `:LspInstall <server>` so we don't have to restart neovim
lspinstall.post_install_hook = function()
  setup_servers() -- reload installed servers
  vim.cmd("bufdo e") -- triggers FileType autocmd that starts the server
end

-- Set custom signs in the gutter
local signs = { Error = " ", Warning = " ", Hint = " ", Information = " " }

for type, icon in pairs(signs) do
  local hl = "LspDiagnosticsSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

vim.lsp.handlers["textDocument/publishDiagnostics"] =
vim.lsp.with(
vim.lsp.diagnostic.on_publish_diagnostics,
{
  virtual_text = {
    prefix = "",
    spacing = 0
  },
  signs = true,
  underline = true,
  update_in_insert = false
}
)

-- suppress error messages from lang servers
vim.notify = function(msg, log_level, _)
  if msg:match("exit code") then
    return
  end
  if log_level == vim.log.levels.ERROR then
    vim.api.nvim_err_writeln(msg)
  else
    vim.api.nvim_echo({{msg}}, true, {})
  end
end
