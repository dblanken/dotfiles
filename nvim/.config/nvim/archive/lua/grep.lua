if vim.fn.executable('rg') then
    vim.o.grepprg = 'rg --vimgrep --no-heading'
    vim.o.grepformat = '%f:%l:%c:%m,%f:%l:%m'
end
