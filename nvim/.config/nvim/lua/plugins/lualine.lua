return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'SmiteshP/nvim-navic' },
  config = function()
    local navic = require("nvim-navic")

    require('lualine').setup({
      options = { theme = 'base16' },
      winbar = {
        lualine_c = {
          {
            function()
              return navic.get_location()
            end,
            cond = function()
              return navic.is_available()
            end
          },
        }
      }
    })
  end
}
