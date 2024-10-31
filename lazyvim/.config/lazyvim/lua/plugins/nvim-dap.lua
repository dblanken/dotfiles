return {
  {
    "mfussenegger/nvim-dap",
    opts = function(_, opts)
      local dap = require("dap")
      dap.configurations.php = {
        {
          type = "php",
          request = "launch",
          name = "1 PHP: Listen for Xdebug",
          port = 9003,
          log = true,
          pathMappings = {
            ["/app/"] = "${workspaceFolder}",
          },
        },
      }
    end,
  },
}
