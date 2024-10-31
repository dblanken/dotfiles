return {
	{
		"nomnivore/ollama.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},

		-- All the user commands added by the plugin
		cmd = { "Ollama", "OllamaModel", "OllamaServe", "OllamaServeStop" },

		keys = {
			-- Sample keybind for prompt menu. Note that the <c-u> is important for selections to work properly.
			{
				"<leader>oo",
				":<c-u>lua require('ollama').prompt()<cr>",
				desc = "ollama prompt",
				mode = { "n", "v" },
			},

			-- Sample keybind for direct prompting. Note that the <c-u> is important for selections to work properly.
			{
				"<leader>og",
				":<c-u>lua require('ollama').prompt('Generate_Code')<cr>",
				desc = "ollama Generate Code",
				mode = { "n", "v" },
			},
		},
		opts = {
			model = "mistral",
			url = "http://127.0.0.1:11434",
			serve = {
				on_start = false,
				command = "ollama",
				args = { "serve" },
				stop_command = "pkill",
				stop_args = { "-SIGTERM", "ollama" },
			},
			-- View the actual default prompts in ./lua/ollama/prompts.lua
			prompts = {
				Ask_About_Code = {
					prompt = "I have a question about this: $input\n\n Here is the code:\n```$ftype\n$sel```",
					input_label = "Q",
					model = "codellama",
				},

				Explain_Code = {
					prompt = "Explain this code:\n```$ftype\n$sel\n```",
					model = "codellama",
				},

				-- basically "no prompt"
				Raw = {
					prompt = "$input",
					input_label = ">",
					action = "display",
				},

				Simplify_Code = {
					prompt = "Simplify the following $ftype code so that it is both easier to read and understand. "
						.. "\n\n```$ftype\n$sel```",
					action = "replace",
					model = "codellama",
				},

				Modify_Code = {
					prompt = "Modify this $ftype code in the following way: $input\n\n" .. "\n\n```$ftype\n$sel```",
					action = "replace",
					model = "codellama",
				},

				Generate_Code = {
					prompt = "Generate $ftype code that does the following: $input\n\n",
					action = "insert",
					model = "codellama",
				},

				Generate_Commit_Message = {
					prompt = "Generate a git commit message for the following $ftype diffs: $sel\n\n",
					action = "display",
					model = "codellama",
				},
			},
		},
	},
}

