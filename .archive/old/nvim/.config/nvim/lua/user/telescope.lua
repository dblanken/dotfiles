local status_ok, telescope = pcall(require, "telescope")
if not status_ok then
  return
end

telescope.setup {}

local opts = { noremap = true, silent = true }

function edit_neovim()
  local opts = {
    prompt_title = "Neovim",
    shorten_path = false,
    cwd = "~/.config/nvim",
    layout_strategy = "flex",
    layout_config = {
      width = 0.9,
      height = 0.8,
      horizontal = {
        width = { padding = 0.15 },
      },
      vertical = {
        preview_height = 0.75,
      },
    },
    find_command = { "rg", "--ignore", "--hidden", "--files", "--glob=!pack" },
  }

  require("telescope.builtin").find_files(opts)
end

function edit_dotfiles()
  local opts = {
    prompt_title = "Neovim",
    shorten_path = false,
    cwd = "~/.dotfiles",
    layout_strategy = "flex",
    layout_config = {
      width = 0.9,
      height = 0.8,
      horizontal = {
        width = { padding = 0.15 },
      },
      vertical = {
        preview_height = 0.75,
      },
    },
    find_command = { "rg", "--ignore", "--hidden", "--files", "--glob=!pack", "--glob=!.git" },
  }

  require("telescope.builtin").find_files(opts)
end

vim.api.nvim_set_keymap('n', '<Leader>ff', "<cmd>lua require'telescope.builtin'.find_files()<CR>", opts)
vim.api.nvim_set_keymap('n', '<Leader>fg', "<cmd>lua require'telescope.builtin'.live_grep()<CR>", opts)
vim.api.nvim_set_keymap('n', '<Leader>fb', "<cmd>lua require'telescope.builtin'.buffers()<CR>", opts)
vim.api.nvim_set_keymap('n', '<Leader>fh', "<cmd>lua require'telescope.builtin'.help_tags()<CR>", opts)
vim.api.nvim_set_keymap('n', '<Leader>fn', "<cmd>lua edit_neovim()<CR>", opts)
vim.api.nvim_set_keymap('n', '<Leader>fd', "<cmd>lua edit_dotfiles()<CR>", opts)
