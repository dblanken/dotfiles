return {
	"tpope/vim-fugitive",
	keys = {
		{ 'gh', '<cmd>diffget //2<CR>' },
		{ 'gk', '<cmd>diffget //3<CR>' },
		{ '<Leader>gs', vim.cmd.Git },
	},
	cmd = {
		"Git",
		"G",
	},
}
