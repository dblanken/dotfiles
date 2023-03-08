vim.g.vimwiki_list = {
  {
    path = '~/vimwiki',
    syntax = 'markdown',
    ext = '.md'
  },
  {
    path = '~/code/vimwiki',
    syntax = 'markdown',
    ext = '.md'
  }
}

-- Reload variables since vimwiki needs it before it loads usually
vim.fn['vimwiki#vars#init']()
