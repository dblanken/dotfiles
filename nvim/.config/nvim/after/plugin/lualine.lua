local navic = require('nvim-navic')

require('lualine').setup({
  options = { theme = 'base16' },
  winbar = {
    lualine_c = {
      "navic",
      color_correction = nil,
      navic_opts = nil
    }
  }
})
