vim.keymap.set("n", "gh", "<cmd>diffget //2<CR>")
vim.keymap.set("n", "gk", "<cmd>diffget //3<CR>")

vim.keymap.set("n", "<leader>gs", vim.cmd.Git);

local dblanken_fugitive = vim.api.nvim_create_augroup("dblanken_fugitive", {})

local autocmd = vim.api.nvim_create_autocmd
autocmd("BufWinEnter", {
  group = dblanken_fugitive,
  pattern = "*",
  callback = function()
    if vim.bo.ft ~= "fugitive" then
      return
    end

    local bufnr = vim.api.nvim_get_current_buf()
    local opts = {buffer = bufnr, remap = false}

    -- Push
    vim.keymap.set("n", "<leader>p", function()
      vim.cmd [[ Git push ]]
    end, opts)

    -- Pull with rebase
    vim.keymap.set("n", "<leader>P", function()
      vim.cmd [[ Git pull --rebase ]]
    end, opts)

    -- Easy branch pushing
    vim.keymap.set("n", "<leader>t", ":Git push -u origin ", opts);
  end,
})
