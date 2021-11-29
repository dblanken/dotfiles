local function setupGrepProgram()
  if vim.fn.executable('rg') then
    return 'rg --no-heading --vimgrep --smart-case'
  elseif vim.fn.executable('ag') then
    return 'ag --nogroup --nocolor'
  end

  return vim.o.grepprg
end

vim.opt.grepprg = setupGrepProgram()
