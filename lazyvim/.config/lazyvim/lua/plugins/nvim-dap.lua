return {
  {
    "mfussenegger/nvim-dap",
    keys = {
      { "<F5>", function() require("dap").continue() end, desc = 'Dap Continue'},
      { "<F10>", function() require("dap").step_over() end, desc = 'Dap Step Over' },
      { "<F11>", function() require("dap").step_into() end, desc = 'Dap Step Into'},
      { "<F12>", function() require("dap").step_out() end, desc = 'Dap Step Out'},
    },
  },
  {
    "jay-babu/mason-nvim-dap.nvim",
    opts = {
      ensure_installed = { "php-debug-adapter" },
      handlers = {
        function(config)
          require('mason-nvim-dap').default_setup(config)
        end,
        php = function(config)
          config.configurations = {
            {
              type = "php",
              request = "launch",
              name = "PHP: Listen for Xdebug",
              port = 9003,
              log = false,
              pathMappings = {
                ["/app/"] = "${workspaceFolder}",
              },
            }
          }
          require('mason-nvim-dap').default_setup(config)
        end,
      }
    }
  }
}
