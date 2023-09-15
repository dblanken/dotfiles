return {
    'RRethy/nvim-base16',
    config = function()
      vim.cmd('colorscheme base16-' .. vim.env["BASE16_THEME"])
    end
  }
