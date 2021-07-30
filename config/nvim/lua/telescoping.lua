vim.api.nvim_set_keymap('n', '<Leader>ff', "<cmd>lua require('telescope.builtin').find_files()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>fg', "<cmd>lua require('telescope.builtin').live_grep()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>fn', "<cmd>lua EditNeovim()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>fd', "<cmd>lua EditDotfiles()<CR>", { noremap = true, silent = true })


require('telescope').setup {
  extensions = {
    fzf = {
      fuzzy = true,                    -- false will only do exact matching
      override_generic_sorter = false, -- override the generic sorter
      override_file_sorter = true,     -- override the file sorter
      case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
                                       -- the default case_mode is "smart_case"
    }
  }
}

-- To get fzf loaded and working with telescope, you need to call
-- load_extension, somewhere after setup function:
require('telescope').load_extension('fzf')

function EditNeovim()
  local Opts

  Opts = {
    prompt_title = "neovim",
    shorten_path = false,
    cwd = "~/code/dotfiles/config/nvim",
  }

  require('telescope.builtin').find_files(Opts)
end

function EditDotfiles()
  local Opts

  Opts = {
    prompt_title = "dotfiles",
    shorten_path = false,
    cwd = "~/code/dotfiles",
  }

  require('telescope.builtin').find_files(Opts)
end


