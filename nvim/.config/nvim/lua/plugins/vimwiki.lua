return {
	'vimwiki/vimwiki',
	config = function()
		vim.g.vimwiki_key_mappings = {
			table_mappings = 0,
		}

		vim.g.vimwiki_list = {
			{
				path = '~/.vimwiki',
				syntax = 'markdown',
				ext = '.md'
			},
			{
				path = '~/Documents/vimwiki',
				syntax = 'markdown',
				ext = '.md'
			}
		}

		-- Reload variables since vimwiki needs it before it loads usually
		vim.fn['vimwiki#vars#init']()
	end,
}
