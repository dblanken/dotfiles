function findPhpCsStandards(standards, locations)
	local standardsExist = true

	for _, standard in ipairs(standards) do
		local found = false
		for _, location in ipairs(locations) do
			local path = location .. "/" .. standard
			if vim.fn.isdirectory(path) == 1 then
				found = true
				break
			end
		end
		if not found then
			standardsExist = false
			break
		end
	end

	return standardsExist
end

return {
	"mfussenegger/nvim-lint",
	config = function()
		local lint = require("lint")
		local masonBinPath = vim.fn.stdpath("data") .. "/mason/bin"

		-- Use mason's twigcs
		local twigcs_bin = masonBinPath .. "/twigcs"
		if vim.fn.filereadable(twigcs_bin) == 1 then
			lint.linters.twigcs.cmd = masonBinPath .. "/twigcs"
		end

		-- PHPCS
		-- Attempt to use vendor version if available
		local phpcs = lint.linters.phpcs

		local git_dir = vim.fn.systemlist("git rev-parse --show-toplevel")[1]
		local phpcs_bin = vim.fn.expand(git_dir .. "/vendor/bin/phpcs")
		local coder_location = vim.fn.expand(git_dir .. "/vendor/drupal/coder/coder_sniffer/Drupal/ruleset.xml")

		if vim.fn.filereadable(phpcs_bin) == 1 then
			phpcs.cmd = phpcs_bin

			if vim.fn.filereadable(coder_location) == 1 then
				phpcs.args = {
					"-q",
					"--report=json",
					"--standard=Drupal,DrupalPractice",
					"--extensions=php,module,inc,install,test,profile,theme,info,txt",
					"-", -- need `-` at the end for stdin support
				}
			else
				phpcs.args = {
					"-q",
					"--report=json",
					"--extensions=php,module,inc,install,test,profile,theme,info,txt",
					"-", -- need `-` at the end for stdin support
				}
			end
		end

		lint.linters_by_ft = {
			php = { "phpcs" },
			sh = { "shellcheck" },
			zsh = { "shellcheck" },
			bash = { "shellcheck" },
			yaml = { "yamllint" },
			twig = { "twigcs" },
			javascript = { "eslint_d", "eslint" },
			html = { "htmlhint" },
			css = { "stylelint" },
			scss = { "stylelint" },
			sass = { "stylelint" },
			less = { "stylelint" },
			git = { "gitlint" },
		}

		vim.api.nvim_create_autocmd({ "BufRead", "BufWritePost", "TextChanged", "InsertLeave" }, {
			callback = function()
				require("lint").try_lint()
			end,
		})
	end,
}
