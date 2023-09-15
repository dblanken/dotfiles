return {                                                   -- vim-tmux-navigator
    'numToStr/Navigator.nvim',
    config = true,
    keys = {
      {
        mode = { "n", "t" },
        "<C-h>",
        "<CMD>NavigatorLeft<CR>",
        desc = "Navigate left",
      },
      {
        mode = { "n", "t" },
        "<C-l>",
        "<CMD>NavigatorRight<CR>",
        desc = "Navigate right",
      },
      {
        mode = { "n", "t" },
        "<C-k>",
        "<CMD>NavigatorUp<CR>",
        desc = "Navigate up",
      },
      {
        mode = { "n", "t" },
        "<C-j>",
        "<CMD>NavigatorDown<CR>",
        desc = "Navigate down",
      },
    },
  }
