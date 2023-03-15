local dap = require('dap')
dap.adapters.chrome = {
  type = 'executable',
  command = 'node',
  args = {os.getenv('HOME') .. '/code/microsoft/vscode-chrome-debug/out/src/chromeDebug.js'}
}
dap.configurations.typescriptreact = {
  {
    type = "chrome",
    request = "attach",
    program = "${file}",
    cwd = vim.fn.getcwd(),
    sourceMaps = true,
    protocol = 'inspector',
    port = 9222,
    webRoot = "${workspaceFolder}",
  }
}
-- require('dap-vscode-js').setup({
--   debugger_path = os.getenv('HOME') .. "/.local/share/nvim/lazy/vscode-js-debug", -- Path to vscode-js-debug installation.
--   adapters = { 'pwa-node', 'pwa-chrome', 'pwa-msedge', 'node-terminal', 'pwa-extensionHost' },
-- })

-- for _, language in ipairs({ "typescript", "javascript", "typescriptreact" }) do
--   require("dap").configurations[language] = {
--     {
--       {
--         type = "pwa-node",
--         request = "launch",
--         name = "Launch file",
--         program = "${file}",
--         cwd = "${workspaceFolder}",
--       },
--       {
--         type = "pwa-node",
--         request = "attach",
--         name = "Attach",
--         processId = require'dap.utils'.pick_process,
--         cwd = "${workspaceFolder}",
--       }
--     }
--   }
-- end

-- dap.adapters.node2 = {
--   type = 'executable',
--   command = 'node',
--   args = {os.getenv('HOME') .. '/code/microsoft/vscode-node-debug2/out/src/nodeDebug.js'},
-- }

-- dap.configurations.javascript = {
--   {
--     name = 'Launch',
--     type = 'node2',
--     request = 'launch',
--     program = '${file}',
--     cwd = vim.fn.getcwd(),
--     sourceMaps = true,
--     protocol = 'inspector',
--     console = 'integratedTerminal',
--   },
--   {
--     -- For this to work you need to make sure the node process is started with the `--inspect` flag.
--     name = 'Attach to process',
--     type = 'node2',
--     request = 'attach',
--     processId = require'dap.utils'.pick_process,
--   },
-- }

-- dap.configurations.typescriptreact = {
--   {
--     name = 'Launch',
--     type = 'node2',
--     request = 'launch',
--     program = '${file}',
--     cwd = vim.fn.getcwd(),
--     sourceMaps = true,
--     protocol = 'inspector',
--     console = 'integratedTerminal',
--   },
--   {
--     -- For this to work you need to make sure the node process is started with the `--inspect` flag.
--     name = 'Attach to process',
--     type = 'node2',
--     request = 'attach',
--     processId = require'dap.utils'.pick_process,
--   },
-- }

-- dap.adapters.php = {
--   type = 'executable',
--   command = 'node',
--   args = { os.getenv('HOME') .. '/code/microsoft/vscode-php-debug/out/phpDebug.js' }
-- }

-- dap.configurations.php = {
--   {
--     type = 'php',
--     request = 'launch',
--     name = 'Listen for Xdebug',
--     port = 9000
--   }
-- }

local map = function(lhs, rhs, desc)
  if desc then
    desc = "[DAP] " .. desc
  end

  vim.keymap.set("n", lhs, rhs, { silent = true, desc = desc })
end

map("<F11>", require("dap").step_into, "step_into")
map("<F10>", require("dap").step_over, "step_over")
map("<F12>", require("dap").step_out, "step_out")
map("<F5>", require("dap").continue, "continue")

require('dapui').setup()

-- TODO:
-- disconnect vs. terminate

map("<leader>dr", require("dap").repl.open)

map("<leader>b", require("dap").toggle_breakpoint)
map("<leader>B", function()
  require("dap").set_breakpoint(vim.fn.input "[DAP] Condition > ")
end)

map("<leader>de", require("dapui").eval)
map("<leader>dE", function()
  require("dapui").eval(vim.fn.input "[DAP] Expression > ")
end)

dap.listeners.after.event_initialized["dapui_config"] = function()
  require('dapui').open()
end

dap.listeners.before.event_terminated["dapui_config"] = function()
  require('dapui').close()
end

dap.listeners.before.event_exited["dapui_config"] = function()
  require('dapui').close()
end
