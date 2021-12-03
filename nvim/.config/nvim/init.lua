--
--              _
--   _ __   ___(_)_ __ ___   ___   ___  _ __
--  | '_ \ / _ \ | '_ ` _ \ / _ \ / _ \| '_ \
--  | | | |  __/ | | | | | | (_) | (_) | | | |
--  |_| |_|\___|_|_| |_| |_|\___/ \___/|_| |_|
--
--
require "impatient"

if require "dblanken.first_load"() then
  return
end

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

require "dblanken.globals"
require "dblanken.disable_builtin"
require "packer_compiled"
require "dblanken.lsp"
