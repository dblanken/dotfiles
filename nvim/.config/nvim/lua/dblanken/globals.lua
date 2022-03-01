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

P = function(v)
  print(vim.inspect(v))
  return v
end

RELOAD = function(...)
  return require("plenary.reload").reload_module(...)
end

R = function(name)
  RELOAD(name)
  return require(name)
end
