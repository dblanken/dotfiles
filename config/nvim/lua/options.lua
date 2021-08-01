-- Options
vim.o.backup = true
vim.o.backupdir=vim.fn.expand("~/.local/share/nvim/backup")
vim.o.clipboard = 'unnamedplus,unnamed'
vim.o.colorcolumn = "81"
vim.o.errorbells = false
vim.o.hidden = true
vim.o.number = true
vim.o.relativenumber = true
vim.o.shada = "!,'1000,<50,s10,h"
vim.o.signcolumn = 'yes'
vim.o.swapfile = false
vim.o.undofile = true
vim.o.formatoptions = "jnrqc"
vim.o.foldmethod = "marker"

-- For formatoptions
  -- - "a" -- Auto formatting is BAD.
  -- - "t" -- Don't auto format my code. I got linters for that.
  -- + "c" -- In general, I like it when comments respect textwidth
  -- + "q" -- Allow formatting comments w/ gq
  -- - "o" -- O and o, don't continue comments
  -- + "r" -- But do continue when pressing enter.
  -- + "n" -- Indent past the formatlistpat, not underneath it.
  -- + "j" -- Auto-remove comments if possible.
  -- - "2" -- I'm not in gradeschool anymore
