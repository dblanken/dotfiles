require 'neimoon.sets'
require 'neimoon.remaps'
require 'neimoon.plugins'

function R(name)
  require("plenary.reload").reload_module(name)
end
