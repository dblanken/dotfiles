require 'neimoon.sets'
require 'neimoon.remaps'
require 'neimoon.plugins'

function P(v)
  print(vim.inspect(v))
  return v
end

function R(name)
  require("plenary.reload").reload_module(name)
end
