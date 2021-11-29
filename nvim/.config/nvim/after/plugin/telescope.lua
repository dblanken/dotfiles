require('telescope').setup{}

function custom_edit_files(opts)
  local opts_with_preview, opts_without_preview

  opts_with_preview = {
    prompt_title = opts.title,
    shorten_path = false,
    cwd = opts.cwd,

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

    attach_mappings = function(_, map)
      map("i", "<c-y>", set_prompt_to_entry_value)
      map("i", "<M-c>", function(prompt_bufnr)
        actions.close(prompt_bufnr)
        vim.schedule(function()
          require("telescope.builtin").find_files(opts_without_preview)
        end)
      end)

      return true
    end,
  }

  opts_without_preview = vim.deepcopy(opts_with_preview)
  opts_without_preview.previewer = false

  require("telescope.builtin").find_files(opts_with_preview)
end


local opts = { noremap = true, silent = true }
vim.api.nvim_set_keymap('n', '<leader>ff', '<cmd>lua require("telescope.builtin").find_files()<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>fg', '<cmd>lua require("telescope.builtin").live_grep()<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>fb', '<cmd>lua require("telescope.builtin").buffers()<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>fh', '<cmd>lua require("telescope.builtin").help_tags()<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>fbr', '<cmd>lua require("telescope.builtin").file_browser()<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>en', '<cmd>lua custom_edit_files({ title = "edit neovim", cwd = "~/.config/nvim" })<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>ed', '<cmd>lua custom_edit_files({ title = "edit dotfiles", cwd = "~/.dotfiles" })<CR>', opts)
