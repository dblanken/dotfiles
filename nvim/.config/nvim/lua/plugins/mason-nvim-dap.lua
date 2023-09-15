return {
  'jay-babu/mason-nvim-dap.nvim',
  dependencies = { 'mfussenegger/nvim-dap' },
  config = function()
    require('mason').setup()
    require('mason-nvim-dap').setup({
      ensure_installed = {'php'},
      handlers = {},
    })

    -- Manually fix the port and pathMappings for PHP to work with default
    -- Xdebug port and Drupal
    require('dap').configurations.php[1].port = 9003
    require('dap').configurations.php[1].pathMappings = {
      ["/app/"] = "${workspaceFolder}"
    }
  end,
}
