if not pcall(
  function()
    require('telescope').setup {
      extensions = {
        fzf = {
          fuzzy = true,
          override_generic_sorter = false,
          override_file_sorter = true,
          case_mode = "smart_case",
        }
      }
    }

    require('telescope').load_extension('fzf')
  end) then
  print("You need telescope-fzf-native.nvim")
end
