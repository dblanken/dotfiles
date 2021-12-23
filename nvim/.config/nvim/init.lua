vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

require('dblanken.globals')
require('dblanken.providers')
require('dblanken.disable_builtins')
require('dblanken.options')
require('dblanken.mappings')
require('dblanken.autocmds')
require('dblanken.grep')
require('dblanken.plugins')

local status_ok, _ = pcall(require, 'impatient')
if status_ok == true then
require('impatient')
require('packer_compiled')
end
