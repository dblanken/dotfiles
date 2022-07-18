vim.api.nvim_set_keymap('n', 'Q', '@q', { noremap = true, silent = true, desc = "Execute macro q" })
vim.api.nvim_set_keymap('n', '<Leader>=', 'migg=G`i', { noremap = true, silent = true, desc = "Format document" })
vim.api.nvim_set_keymap('n', '<Leader><Leader>', ':nohl<CR>', { noremap = true, silent = true, desc = "Clear highlights" })
vim.api.nvim_set_keymap('v', 'p', '"_dp', { noremap = true, silent = true, desc = "Paste without copy" })
vim.api.nvim_set_keymap('v', 'P', '"_dP', { noremap = true, silent = true, desc = "Paste before without copy" })
vim.api.nvim_set_keymap('t', '<Esc>', '<C-\\><C-n>', { noremap = true, silent = true, desc = "Escape from terminal" })

-- Lazy load packer
vim.cmd "silent! command PackerCompile lua require 'pluginList' require('packer').compile()"
vim.cmd "silent! command PackerInstall lua require 'pluginList' require('packer').install()"
vim.cmd "silent! command PackerStatus lua require 'pluginList' require('packer').status()"
vim.cmd "silent! command PackerSync lua require 'pluginList' require('packer').sync()"
vim.cmd "silent! command PackerUpdate lua require 'pluginList' require('packer').update()"
