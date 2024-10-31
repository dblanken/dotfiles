return {
	{
		"nvim-lualine/lualine.nvim",
		optional = true,
		dependencies = {
			"nvim-tree/nvim-web-devicons",
			"nomnivore/ollama.nvim",
		},
		opts = function(_, opts)
			table.insert(opts.sections.lualine_x, {
				function()
					local status = require("ollama").status()

					if status == "IDLE" then
						return "󱙺" -- nf-md-robot-outline
					elseif status == "WORKING" then
						return "󰚩" -- nf-md-robot
					end
				end,
				cond = function()
					return package.loaded["ollama"] and require("ollama").status() ~= nil
				end,
			})
		end,
	},
}
