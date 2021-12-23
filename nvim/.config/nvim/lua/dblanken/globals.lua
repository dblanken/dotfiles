vim.g.clipboard = {
  name = 'pbcopy',
  cache_enabled = 1,
  copy = {
    ['+'] = 'pbcopy',
    ['*'] = 'pbcopy'
  },
  paste = {
    ['+'] = 'pbpaste',
    ['*'] = 'pbpaste'
  }
}

vim.g.ruby_fold = 0
