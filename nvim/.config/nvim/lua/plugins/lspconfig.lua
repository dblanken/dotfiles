local present1, lspconfig = pcall(require, "lspconfig")
local present2, lspinstall = pcall(require, "lspinstall")
if not (present1 or present2) then
  return
end

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(_client, bufnr)
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
  local special_servers = {"lua", "ruby"}

  local function contains(table, val)
    for key,_ in pairs(table) do
      if key == val then
        return true
      end
    end
    return false
  end

  for _, lang in pairs(servers) do
    if not contains(special_servers, lang) then
      lspconfig[lang].setup {
        on_attach = on_attach,
        capabilities = capabilities,
        root_dir = vim.loop.cwd,
        flags = {
          debounce_text_changes = 150,
        }
      }
    elseif lang == "ruby" then
      -- Use custom command since default solargraph does not respect
      -- rubocop extensions
      lspconfig[lang].setup {
        cmd = vim.fn.expand("~/.asdf/shims/solargraph"),
        on_attach = on_attach,
        capabilities = capabilities,
        root_dir = vim.loop.cwd,
        settings = {
          solargraph = {
            diagnostics = true
          }
        },
        flags = {
          debounce_text_changes = 150,
        }
      }
    elseif lang == "lua" then
      lspconfig[lang].setup {
        root_dir = vim.loop.cwd,
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
vim.notify = function(msg, log_level, _opts)
  if msg:match("exit code") then
    return
  end
  if log_level == vim.log.levels.ERROR then
    vim.api.nvim_err_writeln(msg)
  else
    vim.api.nvim_echo({{msg}}, true, {})
  end
end
