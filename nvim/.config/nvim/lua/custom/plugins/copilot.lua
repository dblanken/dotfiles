return {
	{
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		event = "InsertEnter",
		opts = {
			suggestion = { enabled = false },
			panel = { enabled = false },
			copilot_node_command = os.getenv("HOME") .. "/.local/share/mise/installs/node/20.14/bin/node",
		},
	},
	{
		"zbirenbaum/copilot-cmp",
		dependencies = { "zbirenbaum/copilot.lua" },
		main = "copilot_cmp",
		config = true,
		event = "InsertEnter",
	},
}
