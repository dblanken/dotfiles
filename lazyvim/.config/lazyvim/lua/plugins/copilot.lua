return {
  {
    "zbirenbaum/copilot.lua",
    opts = function(_, opts)
      opts.copilot_node_command = vim.fn.expand("$HOME") .. "/.local/share/mise/installs/node/latest/bin/node"
    end,
  },
}
