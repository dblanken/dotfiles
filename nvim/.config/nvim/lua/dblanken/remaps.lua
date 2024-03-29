vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

vim.keymap.set("x", "<leader>p", "_dP")

vim.keymap.set({"n", "v"}, "<leader>y", "+y")
vim.keymap.set("n", "<leader>Y", "+Y")

vim.keymap.set({"n", "v"}, "<leader>d", "_d")

vim.keymap.set("n", "Q", "@q")
vim.keymap.set("n", "Y", "y$")

vim.keymap.set("n", "<Leader>=", "migg=G`i")
vim.keymap.set("n", "<Leader>f", "migg=G`i")

vim.keymap.set("n", "<M-f>", ":silent !tmux neww tmux-sessionizer<CR>", { noremap = true })
