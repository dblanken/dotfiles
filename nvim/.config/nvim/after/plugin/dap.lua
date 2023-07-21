require('mason').setup()
require('mason-nvim-dap').setup({
  ensure_installed = {'node2', 'chrome', 'firefox', 'php', 'js', 'bash'},
  handlers = {},
})
local dap = require('dap')

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
