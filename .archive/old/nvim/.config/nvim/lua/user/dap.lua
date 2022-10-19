local status_ok, dap = pcall(require, "dap")
if not status_ok then
  return
end

-- require('user.dap-ruby').setup()

dap.adapters.ruby = {
  type = 'executable';
  command = 'bundle';
  args = {'exec', 'readapt', 'stdio'};
}

dap.configurations.ruby = {
  {
    type = 'ruby';
    request = 'launch';
    name = 'Rails';
    program = 'bundle';
    programArgs = {'exec', 'rails', 's'};
    useBundler = true;
  },
}

vim.api.nvim_set_keymap('n', '<F5>', '<cmd>lua require"dap".continue()<CR>', { silent = true })
vim.api.nvim_set_keymap('n', '<F10>', '<cmd>lua require"dap".step_over()<CR>', { silent = true })
vim.api.nvim_set_keymap('n', '<F11>', '<cmd>lua require"dap".step_into()<CR>', { silent = true })
vim.api.nvim_set_keymap('n', '<F12>', '<cmd>lua require"dap".step_out()<CR>', { silent = true })
vim.api.nvim_set_keymap('n', '<Leader>b', '<cmd>lua require"dap".toggle_breakpoint()<CR>', { silent = true })
vim.api.nvim_set_keymap('n', '<Leader>B', '<cmd>lua require"dap".set_breakpoint(vim.fn.input("Breakpoint condition: "))<CR>', { silent = true })
vim.api.nvim_set_keymap('n', '<Leader>lp', '<cmd>lua require"dap".set_breakpoint(nil, nil, vim.fn.input("Log point message: "))<CR>', { silent = true })
vim.api.nvim_set_keymap('n', '<Leader>dr', '<cmd>lua require"dap".repl.open()<CR>', { silent = true })
vim.api.nvim_set_keymap('n', '<Leader>dl', '<cmd>lua require"dap".run_last()<CR>', { silent = true })

local status_ok, dapui = pcall(require, "dapui")
if not status_ok then
  return
end

dapui.setup({
  icons = { expanded = "▾", collapsed = "▸" },
  mappings = {
    -- Use a table to apply multiple mappings
    expand = { "<CR>", "<2-LeftMouse>" },
    open = "o",
    remove = "d",
    edit = "e",
    repl = "r",
    toggle = "t",
  },
  -- Expand lines larger than the window
  -- Requires >= 0.7
  expand_lines = vim.fn.has("nvim-0.7"),
  sidebar = {
    -- You can change the order of elements in the sidebar
    elements = {
      -- Provide as ID strings or tables with "id" and "size" keys
      {
        id = "scopes",
        size = 0.25, -- Can be float or integer > 1
      },
      { id = "breakpoints", size = 0.25 },
      { id = "stacks", size = 0.25 },
      { id = "watches", size = 00.25 },
    },
    size = 40,
    position = "left", -- Can be "left", "right", "top", "bottom"
  },
  tray = {
    elements = { "repl" },
    size = 10,
    position = "bottom", -- Can be "left", "right", "top", "bottom"
  },
  floating = {
    max_height = nil, -- These can be integers or a float between 0 and 1.
    max_width = nil, -- Floats will be treated as percentage of your screen.
    border = "single", -- Border style. Can be "single", "double" or "rounded"
    mappings = {
      close = { "q", "<Esc>" },
    },
  },
  windows = { indent = 1 },
  render = { 
    max_type_length = nil, -- Can be integer or nil.
  }
})
