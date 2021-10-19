Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'

function! TelescopeSetup() abort
  lua << EOF
  function edit_neovim()
    local opts_with_preview, opts_without_preview

    opts_with_preview = {
      prompt_title = "~ dotfiles ~",
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
EOF

" Find files using Telescope command-line sugar.
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>
nnoremap <C-p> <cmd>Telescope find_files<cr>
nnoremap <leader>en <cmd>lua edit_neovim()<cr>

endfunction

augroup SetupTelescope
  autocmd!
  autocmd User PlugLoaded call TelescopeSetup()
augroup END
