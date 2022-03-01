local M = {}

-- Quickly edit any file location with a custom prompt
function M.edit_directory(prompt_title, cwd, hidden)
  local opts_with_preview, opts_without_preview

  opts_with_preview = {
    hidden = hidden,
    prompt_title = prompt_title,
    shorten_path = false,
    cwd = cwd,
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

    mappings = {
      i = {
        ["<C-y>"] = false,
      },
    },

    attach_mappings = function(_, map)
      map("i", "<C-y>", set_prompt_to_empty_value)
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

  require('telescope.builtin').find_files(opts_with_preview)
end

-- Quickly edit overall dotfiles
function M.edit_dotfiles()
  M.edit_directory('Dotfiles', '~/.dotfiles', true)
end

-- Quickly edit neovim files
function M.edit_neovim()
  M.edit_directory('Neovim Files', '~/.config/nvim', true)
end

return M
